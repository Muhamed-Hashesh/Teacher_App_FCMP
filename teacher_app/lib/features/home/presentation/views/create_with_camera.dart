import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:teacher_app/features/home/presentation/views/camera_page.dart';
import 'package:teacher_app/features/quiz/presentation/views/live_exam.dart';
import 'package:teacher_app/widgets/ai_generated_question.dart';
import 'package:teacher_app/widgets/custombutton.dart';

class CreateWithCameraPage extends StatefulWidget {
  const CreateWithCameraPage({super.key});

  @override
  CreateWithCameraPageState createState() => CreateWithCameraPageState();
}

class CreateWithCameraPageState extends State<CreateWithCameraPage> {
  String? capturedImagePath;
  String? extractedText;
  File? uploadedFile;
  bool _isLoading = false;

  List<String> questions = [];
  List<List<String>> answers = [];
  List<String> correctAnswers = [];

  Future<void> pickFile() async {
    try {
      // Open file picker for images
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          uploadedFile = File(result.files.single.path!);
        });

        // Extract text and show appropriate messages
        bool isTextExtracted = await extractTextFromImage(uploadedFile!);
        if (isTextExtracted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File uploaded: ${uploadedFile!.path}')),
          );
        }
      } else {
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick file')),
      );
    }
  }

  Future<bool> extractTextFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      if (recognizedText.text.isNotEmpty) {
        setState(() {
          extractedText = recognizedText.text;
        });

        Map<String, dynamic> parsedData =
            parseQuestionsAndAnswers(recognizedText.text);

        setState(() {
          questions = parsedData['questions'];
          answers = parsedData['answers'];
          correctAnswers = parsedData['correctAnswers'];
        });

        textRecognizer.close();
        return true;
      } else {
        throw Exception("No text found in the image.");
      }
    } catch (e) {
      print("Error extracting text: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to extract text: $e')),
      );
      return false;
    }
  }

  Map<String, dynamic> parseQuestionsAndAnswers(String rawText) {
    Map<String, dynamic> result = {
      "questions": <String>[],
      "answers": <List<String>>[],
      "correctAnswers": <String>[]
    };

    List<String> lines = rawText.split("\n");

    String? currentQuestion;
    List<String> currentAnswers = [];
    String? correctAnswer;

    for (String line in lines) {
      if (line.endsWith("?")) {
        // Save the previous question and answers
        if (currentQuestion != null) {
          result['questions'] = List<String>.from(result['questions'])
            ..add(currentQuestion);
          result['answers'] = List<List<String>>.from(result['answers'])
            ..add(List<String>.from(currentAnswers));
          result['correctAnswers'] = List<String>.from(result['correctAnswers'])
            ..add(correctAnswer ?? "Not provided");
        }

        // Start new question
        currentQuestion = line.trim();
        currentAnswers = [];
        correctAnswer = null;
      } else if (line.startsWith(RegExp(r"[A-D]\."))) {
        // Add answer choices
        currentAnswers.add(line.trim());
      } else if (line.startsWith("Correct Answer:")) {
        // Extract correct answer
        correctAnswer = line.split(":").last.trim();
      }
    }

    if (currentQuestion != null) {
      result['questions'] = List<String>.from(result['questions'])
        ..add(currentQuestion);
      result['answers'] = List<List<String>>.from(result['answers'])
        ..add(List<String>.from(currentAnswers));
      result['correctAnswers'] = List<String>.from(result['correctAnswers'])
        ..add(correctAnswer ?? "Not provided");
    }

    return result;
  }

  Future<void> openCameraPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CameraPage(),
      ),
    );

    if (result != null && result is Map) {
      setState(() {
        capturedImagePath = result['imagePath'];
        extractedText = result['extractedText'];

        Map<String, dynamic> parsedData =
            parseQuestionsAndAnswers(extractedText!);

        questions.addAll(parsedData['questions']);
        answers.addAll(parsedData['answers']);
        correctAnswers.addAll(parsedData['correctAnswers']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double verticalPadding = screenHeight * 0.02;
    double fontSize = screenWidth * 0.045;
    double buttonFontSize = screenWidth * 0.04;

    fontSize = fontSize.clamp(14.0, 20.0);
    buttonFontSize = buttonFontSize.clamp(12.0, 18.0);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 151, 168),
        title: const Text(
          "New Session",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReusableButton(
                    label: 'Use Camera',
                    onPressed: openCameraPage,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    hasIcon: true,
                    icon: Icons.camera_alt_rounded,
                  ),
                  const SizedBox(width: 10),
                  ReusableButton(
                    label: 'Upload',
                    onPressed: pickFile,
                    hasIcon: true,
                    icon: Icons.upload_file,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Uploaded'),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        uploadedFile != null
                            ? uploadedFile!.path.split('/').last
                            : 'No file selected',
                        style: TextStyle(
                          color:
                              uploadedFile != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                    if (uploadedFile != null)
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () {
                          setState(() {
                            uploadedFile = null;
                            extractedText = null;
                          });
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Which questions do you want to include in the session?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              if (questions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Extracted Questions:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        // return Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text("Q${index + 1}: ${questions[index]}"),
                        //     ...answers[index]
                        //         .map((answer) => Text(answer))
                        //         .toList(),
                        //     Text(
                        //       "Correct Answer: ${correctAnswers[index]}",
                        //       style: const TextStyle(color: Colors.green),
                        //     ),
                        //     const SizedBox(height: 10),
                        //   ],
                        // );
                        return AiGeneratedQuestion(
                            question: questions[index],
                            options: answers[index],
                            correctAnswer: correctAnswers[index],
                            questionNumber: index,
                            onSelectionChanged: (bool value) {});
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_isLoading) return;

                    if (questions.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Please upload an image or capture text to include questions.'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _isLoading = true; // Start loading
                    });

                    try {
                      final firestore = FirebaseFirestore.instance;

                      // 1. Fetch all existing SessionIDs
                      final sessionsSnapshot =
                          await firestore.collection('Sessions').get();
                      final sessionIDs = sessionsSnapshot.docs
                          .map((doc) => doc.id)
                          .where((id) => id.startsWith('SessionID'))
                          .map((id) =>
                              int.tryParse(id.replaceFirst('SessionID', '')))
                          .whereType<int>()
                          .toList();
                      sessionIDs.sort(); // Sort SessionIDs in ascending order

                      // 2. Determine the next SessionID
                      int nextSessionID =
                          sessionIDs.isNotEmpty ? sessionIDs.last + 1 : 1;

                      // 3. Create a new session document
                      final newSessionDoc = firestore
                          .collection('Sessions')
                          .doc('SessionID$nextSessionID');
                      await newSessionDoc
                          .set({}); // Create the new session document

                      // 4. Reference the QuestionLists collection in the new session
                      final questionListsCollection =
                          newSessionDoc.collection('QuestionLists');

                      // 5. Save questions with sequential numbers starting from 1
                      for (int i = 0; i < questions.length; i++) {
                        await questionListsCollection.doc('${i + 1}').set({
                          'question_name': questions[i],
                          'A': answers[i].length > 0 ? answers[i][0] : '',
                          'B': answers[i].length > 1 ? answers[i][1] : '',
                          'C': answers[i].length > 2 ? answers[i][2] : '',
                          'D': answers[i].length > 3 ? answers[i][3] : '',
                          'correct_answer': correctAnswers[i],
                        });
                      }

                      // 6. Navigate to LiveExam after successful data save
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LiveExam()),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'SessionID$nextSessionID created successfully!')),
                      );
                    } catch (e) {
                      debugPrint('Error saving questions to Firebase: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Failed to save questions to Firebase.'),
                        ),
                      );
                    } finally {
                      setState(() {
                        _isLoading = false; // Stop loading
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: verticalPadding),
                    backgroundColor: const Color.fromARGB(255, 1, 151, 168),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Start Quiz",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: buttonFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
