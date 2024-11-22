import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/features/quiz/presentation/views/live_exam.dart';
import 'package:teacher_app/widgets/custombutton.dart';
import 'package:teacher_app/widgets/manual_question_form.dart';
import 'package:teacher_app/widgets/upload_file_button.dart';
import 'package:uuid/uuid.dart';

class YourQuestionListsPage extends StatefulWidget {
  const YourQuestionListsPage({super.key});

  @override
  State<YourQuestionListsPage> createState() => _YourQuestionListsPageState();
}

class _YourQuestionListsPageState extends State<YourQuestionListsPage> {
  bool generateQuestions = false;
  String? _selectedSheetId;
  bool _isLoading = false;

  List<SheetInfo> _uploadedSheets = [];

  List<Question> _questions = [];

  final Set<String> _visibleAnswers = {};

  final Set<String> _selectedQuestions = {};

  final Uuid _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _fetchAvailableSheets();
  }

  /// Fetch existing sheets from Firestore on initialization
  Future<void> _fetchAvailableSheets() async {
    setState(() {
      _isLoading = true;
    });

    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('available_sheets').get();
      List<SheetInfo> sheetInfos = snapshot.docs.map((doc) {
        return SheetInfo.fromDocument(doc);
      }).toList();

      setState(() {
        _uploadedSheets = sheetInfos;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch available sheets: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Method to upload any file
  void _uploadFile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final PlatformFile file = result.files.single;

        Uint8List fileBytes = file.bytes!;
        String fileName = file.name;

        if (_isExcelFile(file.extension)) {
          await _decodeAndUploadExcelFile(fileBytes, fileName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File "$fileName" is not an Excel file.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No file selected or failed to load the file.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Helper method to check if the file is an Excel file
  bool _isExcelFile(String? extension) {
    return extension != null &&
        (extension.toLowerCase() == 'xlsx' || extension.toLowerCase() == 'xls');
  }

  /// Method to decode Excel file from bytes and upload to Firestore
  Future<void> _decodeAndUploadExcelFile(
      Uint8List fileBytes, String originalFileName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      var excel = Excel.decodeBytes(fileBytes);
      if (excel.tables.isEmpty) {
        throw FormatException('The Excel file contains no sheets.');
      }

      for (String sheetName in excel.tables.keys) {
        final sheet = excel.tables[sheetName];
        if (sheet == null) continue;

        List<List<dynamic>> excelRows = [];

        for (var row in sheet.rows) {
          excelRows.add(row.map((cell) => cell?.value ?? "").toList());
        }

        if (excelRows.isEmpty) {
          throw FormatException('Sheet "$sheetName" is empty.');
        }

        final headers = excelRows.first
            .map((e) => e.toString().trim().toLowerCase())
            .toList();
        List<String> expectedHeaders = [
          'question',
          'a',
          'b',
          'c',
          'd',
          'correctanswer'
        ];

        bool headersValid = true;
        for (int i = 0; i < expectedHeaders.length; i++) {
          if (i >= headers.length || headers[i] != expectedHeaders[i]) {
            headersValid = false;
            break;
          }
        }

        if (!headersValid) {
          throw FormatException(
              'The headers in sheet "$sheetName" do not match the expected format.');
        }

        QuerySnapshot duplicateCheck = await FirebaseFirestore.instance
            .collection('available_sheets')
            .where('sheet_name', isEqualTo: sheetName)
            .where('file_name', isEqualTo: originalFileName)
            .get();

        if (duplicateCheck.docs.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Sheet "$sheetName" from file "$originalFileName" already exists. Skipping upload.')),
          );
          continue;
        }

        final dataRows = excelRows.sublist(1);

        DocumentReference sheetDocRef =
            FirebaseFirestore.instance.collection('available_sheets').doc();

        await sheetDocRef.set({
          'sheet_name': sheetName,
          'file_name': originalFileName,
        });

        setState(() {
          _uploadedSheets.add(SheetInfo(
            id: sheetDocRef.id,
            fileName: originalFileName,
            sheetName: sheetName,
            headers: [],
          ));
        });

        await _uploadDataToFirestore(
            dataRows, sheetName, originalFileName, sheetDocRef.id);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All sheets uploaded successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process Excel file: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Method to upload data to Firestore in 'available_sheets' subcollections
  Future<void> _uploadDataToFirestore(List<List<dynamic>> dataRows,
      String sheetName, String fileName, String sheetId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    CollectionReference subCollectionRef = FirebaseFirestore.instance
        .collection('available_sheets')
        .doc(sheetId)
        .collection(fileName);

    for (int i = 0; i < dataRows.length; i++) {
      var row = dataRows[i];
      // Map the row data to the appropriate fields
      final Map<String, dynamic> questionData = {
        'question': row.isNotEmpty ? row[0].toString() : '',
        'A': row.length > 1 ? row[1].toString() : '',
        'B': row.length > 2 ? row[2].toString() : '',
        'C': row.length > 3 ? row[3].toString() : '',
        'D': row.length > 4 ? row[4].toString() : '',
        'correctanswer': row.length > 5 ? row[5].toString() : '',
        'sheet_id': sheetId,
        'sheet_name': sheetName,
        'file_name': fileName,
        'created_at': FieldValue.serverTimestamp(),
      };

      if (questionData['question'].isEmpty ||
          questionData['correctanswer'].isEmpty) {
        continue;
      }

      String questionDocId = 'question${i + 1}';

      DocumentReference questionDocRef = subCollectionRef.doc(questionDocId);
      batch.set(questionDocRef, questionData);
    }

    // Commit the batch
    await batch.commit();
  }

  /// Method to show the manual question form in a dialog
  void _showManualQuestionDialog() async {
    final questionData = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return ManualQuestionForm(
          selectedFileName: _selectedSheetId,
        );
      },
    );

    if (questionData != null) {
      // Create a unique ID for the manual question
      String manualQuestionId = 'manual_${_uuid.v4()}';

      Question manualQuestion = Question(
        id: manualQuestionId,
        question: questionData['question'] ?? '',
        optionA: questionData['A'] ?? '',
        optionB: questionData['B'] ?? '',
        optionC: questionData['C'] ?? '',
        optionD: questionData['D'] ?? '',
        correctAnswer: questionData['correctanswer'] ?? '',
      );

      // Add the manual question to the _questions list
      setState(() {
        _questions.add(manualQuestion);
        _visibleAnswers
            .remove(manualQuestion.id); // Ensure answer is hidden initially
        _selectedQuestions
            .remove(manualQuestion.id); // Ensure it's not selected
      });

      // Provide feedback to the user
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content:
      //           Text('Manually added question displayed successfully.')),
      // );
    }
  }

  /// Method to fetch questions for the selected sheet
  Future<void> _fetchQuestionsForSelectedSheet() async {
    if (_selectedSheetId == null) {
      setState(() {
        _questions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Find the selected sheet's SheetInfo
      SheetInfo selectedSheet =
          _uploadedSheets.firstWhere((sheet) => sheet.id == _selectedSheetId);

      // Reference to the selected sheet document
      DocumentReference sheetDocRef = FirebaseFirestore.instance
          .collection('available_sheets')
          .doc(selectedSheet.id);

      // Fetch questions from the subcollection named after the file
      QuerySnapshot questionsSnapshot =
          await sheetDocRef.collection(selectedSheet.fileName).get();

      List<Question> fetchedQuestions = questionsSnapshot.docs
          .map((doc) => Question.fromDocument(doc))
          .toList();

      setState(() {
        _questions = fetchedQuestions;
        _visibleAnswers.clear(); // Reset visibility when new sheet is selected
        _selectedQuestions
            .clear(); // Reset selections when new sheet is selected
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch questions: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Method to handle selection toggle for a question
  void _toggleQuestionSelection(String questionId, bool? isSelected) {
    setState(() {
      if (isSelected == true) {
        _selectedQuestions.add(questionId);
      } else {
        _selectedQuestions.remove(questionId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Generate list of dropdown items with unique keys (sheet IDs)
    List<String> dropdownItems =
        _uploadedSheets.map((sheet) => sheet.id).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const Drawer(
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 151, 168),
        title: const Text(
          "Question Lists",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload File Button
                UploadFileButton(
                  onPressed: _uploadFile,
                ),
                const SizedBox(height: 24),

                // Select Uploaded File Dropdown
                _buildDropdown(dropdownItems),
                // const SizedBox(height: 24),
                //
                // // Add Using AI and Add Manually Buttons
                // ActionButtons(
                //   onAddUsingAI: () {
                //     if (generateQuestions == false) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         const SnackBar(
                //             content: Text(
                //                 'Add Using AI functionality not implemented.')),
                //       );
                //     }
                //     setState(() {
                //       generateQuestions = true;
                //     });
                //
                //     // Handle add using AI action
                //     // Implement this functionality as needed
                //   },
                //   onAddManually: () {
                //     _showManualQuestionDialog();
                //   },
                // ),
                // const SizedBox(height: 24),
                // ...generateQuestions
                //     ? List.generate(aiQuestionsList.length, (index) {
                //         final question = aiQuestionsList[index];
                //         final options = question['options'] as List<String>;
                //         return AiGeneratedQuestion(
                //           question: question['question'],
                //           options: options,
                //           correctAnswer: question['correctAnswer'],
                //           questionNumber: index,
                //           onSelectionChanged: (bool value) {},
                //         );
                //       })
                //     : [],
                // Display Questions if any
                if (_questions.isNotEmpty) ...[
                  const Text(
                    'Questions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Optional: Add a "Select All" checkbox

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      final question = _questions[index];
                      bool isVisible = _visibleAnswers.contains(question.id);
                      bool isSelected =
                          _selectedQuestions.contains(question.id);
                      return Card(
                        shape: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: Colors.white,
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Question Row with Checkbox and Eye Icon
                              Row(
                                children: [
                                  // Checkbox
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (bool? value) {
                                      _toggleQuestionSelection(
                                          question.id, value);
                                    },
                                  ),
                                  // Expanded to take up remaining space
                                  Expanded(
                                    child: Text(
                                      'Q${index + 1}: ${question.question}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  // Eye Icon Button
                                  IconButton(
                                    icon: Icon(
                                      isVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: isVisible
                                          ? Colors.green
                                          : Colors.grey,
                                    ),
                                    tooltip: isVisible
                                        ? 'Hide Correct Answer'
                                        : 'Show Correct Answer',
                                    onPressed: () {
                                      setState(() {
                                        if (isVisible) {
                                          _visibleAnswers.remove(question.id);
                                        } else {
                                          _visibleAnswers.add(question.id);
                                        }
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Align answers to start with padding
                              Padding(
                                padding: const EdgeInsets.only(left: 32.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '   A: ${question.optionA}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      '   B: ${question.optionB}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      '   C: ${question.optionC}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      '   D: ${question.optionD}',
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Correct Answer
                              if (isVisible)
                                Padding(
                                  padding: const EdgeInsets.only(left: 32.0),
                                  child: Text(
                                    'Correct Answer: ${question.correctAnswer}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],

                // Start Quiz Button
                SizedBox(
                  width: double.infinity,
                  child: ReusableButton(
                    label: "Start Quiz",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const LiveExam(),
                        ),
                      );
                    },
                    backgroundColor: const Color.fromARGB(255, 1, 151, 168),
                    textColor: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          // Loading Indicator
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  /// Builds the dropdown menu for selecting uploaded files
  Widget _buildDropdown(List<String> dropdownItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Uploaded File',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButton<String>(
            dropdownColor: Colors.white,
            isExpanded: true,
            value: _selectedSheetId,
            hint: const Text(
              'Select',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            underline: const SizedBox(),
            items: dropdownItems.map((String sheetId) {
              SheetInfo sheet = _uploadedSheets.firstWhere(
                  (sheet) => sheet.id == sheetId,
                  orElse: () => SheetInfo.empty());
              String displayText = sheet.isEmpty()
                  ? 'Unknown Sheet'
                  : '${sheet.fileName} - ${sheet.sheetName}';
              return DropdownMenuItem<String>(
                value: sheetId,
                child: Text(
                  displayText,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedSheetId = newValue;
                _fetchQuestionsForSelectedSheet();
              });
            },
          ),
        ),
      ],
    );
  }

  /// Method to delete selected questions
}

/// Helper class to store sheet information
class SheetInfo {
  final String id;
  final String fileName;
  final String sheetName;
  final List<String> headers;

  SheetInfo({
    required this.id,
    required this.fileName,
    required this.sheetName,
    required this.headers,
  });

  /// Factory constructor to create SheetInfo from Firestore document
  factory SheetInfo.fromDocument(DocumentSnapshot doc) {
    return SheetInfo(
      id: doc.id,
      fileName: doc['file_name'] as String? ?? 'Unknown',
      sheetName: doc['sheet_name'] as String? ?? 'Unknown',
      headers: [], // Populate if needed
    );
  }

  /// Creates an empty SheetInfo instance
  factory SheetInfo.empty() {
    return SheetInfo(
      id: '',
      fileName: '',
      sheetName: '',
      headers: [],
    );
  }

  /// Checks if the SheetInfo instance is empty
  bool isEmpty() {
    return id.isEmpty && fileName.isEmpty && sheetName.isEmpty;
  }
}

/// Model class to represent a Question
class Question {
  final String id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;

  Question({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
  });

  factory Question.fromDocument(DocumentSnapshot doc) {
    return Question(
      id: doc.id,
      question: doc['question'] ?? '',
      optionA: doc['A'] ?? '',
      optionB: doc['B'] ?? '',
      optionC: doc['C'] ?? '',
      optionD: doc['D'] ?? '',
      correctAnswer: doc['correctanswer'] ?? '',
    );
  }
}
