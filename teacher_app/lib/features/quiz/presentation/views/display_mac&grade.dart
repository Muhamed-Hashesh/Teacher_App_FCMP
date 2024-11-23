import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  ResultsPageState createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  List<Map<String, dynamic>> studentInfoList = [];
  bool isLoading = true; // To manage the loading state

  @override
  void initState() {
    super.initState();
    performDataOperations(); // Call async method without await
  }

  Future<void> performDataOperations() async {
    await fetchStudentInfoAndScores();
    setState(() {
      isLoading = false; // Data operations are complete
    });
  }

  // Function to fetch student info (macAddress and name) and their scores
  Future<void> fetchStudentInfoAndScores() async {
    try {
      // Fetch all students in '/Sessions/SessionID1/ClassLists/ClassList1/Students/'
      QuerySnapshot studentsSnapshot = await FirebaseFirestore.instance
          .collection('Sessions')
          .doc('SessionID1')
          .collection('ClassLists')
          .doc('ClassList1')
          .collection('Students')
          .get();

      if (studentsSnapshot.docs.isNotEmpty) {
        for (var studentDoc in studentsSnapshot.docs) {
          String studentId = studentDoc.id;
          Map<String, dynamic>? studentData =
              studentDoc.data() as Map<String, dynamic>?;

          if (studentData != null &&
              studentData.containsKey('macAddress') &&
              studentData.containsKey('name')) {
            String macAddress = studentData['macAddress'];
            String name = studentData['name'];

            // Fetch the student's final grade
            DocumentSnapshot finalGradeDoc = await FirebaseFirestore.instance
                .collection('Sessions')
                .doc('SessionID1')
                .collection('collection_data')
                .doc(studentId)
                .collection('questions_answer_id')
                .doc('final_grade')
                .get();

            int? score; // Initialize score as nullable

            if (finalGradeDoc.exists) {
              Map<String, dynamic>? finalGradeData =
                  finalGradeDoc.data() as Map<String, dynamic>?;

              if (finalGradeData != null &&
                  finalGradeData.containsKey('score')) {
                score = finalGradeData['score'];
              } else {
                print(
                    "Field 'score' not found in 'final_grade' document for student $studentId");
              }
            } else {
              print(
                  "'final_grade' document does not exist for student $studentId");
            }

            // Add the student's info and score to the list
            studentInfoList.add({
              'studentId': studentId,
              'macAddress': macAddress,
              'name': name,
              'score': score ?? 0,
            });
          } else {
            print(
                "Missing 'macAddress' or 'name' in student document $studentId");
          }
        }
      } else {
        print("No students found in 'Students' collection");
      }

      // Sort the list by score in descending order
      studentInfoList
          .sort((a, b) => (b['score'] as int).compareTo(a['score'] as int));
    } catch (e) {
      print("Error fetching student info and scores: $e");
    }
  }

  Color getCardColor(int index) {
    if (index == 0) {
      return Colors.green; // First card green
    } else if (index == 1) {
      return Colors.yellow; // Second card yellow
    } else {
      return Colors.black; // Other cards black
    }
  }

  @override
  Widget build(BuildContext context) {
    // Display the fetched data
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Scores'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : studentInfoList.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: studentInfoList.length,
                  itemBuilder: (context, index) {
                    var studentInfo = studentInfoList[index];
                    return Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: getCardColor(index),
                            width: 4.0,
                          ),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                      ),
                      child: ListTile(
                        title: Text(studentInfo['name'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle:
                            Text('Mac Address: ${studentInfo['macAddress']}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Score',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '${studentInfo['score']}',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: getCardColor(index)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 8),
                )
              : const Center(child: Text('No data available')),
    );
  }
}
