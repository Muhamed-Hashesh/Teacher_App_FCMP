import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentGrid extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final double baseFontSize;

  const StudentGrid({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.baseFontSize,
  });

  @override
  State<StudentGrid> createState() => _StudentGridState();
}

class _StudentGridState extends State<StudentGrid> {
  late Future<List<Map<String, dynamic>>> _studentsFuture;

  @override
  void initState() {
    super.initState();
    _studentsFuture = _fetchStudentsFromLatestSession();
  }

  Future<List<Map<String, dynamic>>> _fetchStudentsFromLatestSession() async {
    List<Map<String, dynamic>> students = [];
    try {
      // Fetch all SessionIDs
      final sessionsSnapshot =
          await FirebaseFirestore.instance.collection('Sessions').get();

      // Extract the latest session ID
      final sessionIDs = sessionsSnapshot.docs
          .map((doc) => doc.id)
          .where((id) => id.startsWith('SessionID'))
          .map((id) => int.tryParse(id.replaceFirst('SessionID', '')))
          .whereType<int>()
          .toList();

      if (sessionIDs.isEmpty) {
        throw Exception('No SessionIDs found.');
      }

      sessionIDs.sort((a, b) => b.compareTo(a)); // Sort in descending order
      final latestSessionID = sessionIDs.first; // Get the latest session ID

      debugPrint('Latest SessionID: SessionID$latestSessionID');

      // Fetch student data from the responses collection
      final responsesSnapshot = await FirebaseFirestore.instance
          .collection('Sessions')
          .doc('SessionID$latestSessionID')
          .collection('responses')
          .get();

      for (var doc in responsesSnapshot.docs) {
        students.add({
          'id': doc.id,
          'name': doc['name'],
          'hasResponded': false, // Default value; update as needed
        });
      }

      debugPrint(
          'Fetched ${students.length} students from SessionID$latestSessionID');
    } catch (e) {
      debugPrint('Error fetching students: $e');
    }
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _studentsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No students found.'));
        }

        List<Map<String, dynamic>> students = snapshot.data!;
        List<Map<String, dynamic>> respondedStudents =
            students.where((student) => student['hasResponded']).toList();
        List<Map<String, dynamic>> notRespondedStudents =
            students.where((student) => !student['hasResponded']).toList();

        List<Map<String, dynamic>> orderedStudents = [
          ...respondedStudents,
          ...notRespondedStudents,
        ];

        return GridView.builder(
          padding: EdgeInsets.all(widget.screenWidth * 0.01),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 1,
            crossAxisSpacing: widget.screenWidth * 0.01,
            mainAxisSpacing: widget.screenHeight * 0.01,
          ),
          itemCount: orderedStudents.length,
          itemBuilder: (context, index) {
            final student = orderedStudents[index];
            bool hasResponded = student['hasResponded'];

            return Container(
              decoration: BoxDecoration(
                color: hasResponded
                    ? const Color.fromARGB(255, 1, 151, 168)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/images/Male-Doctor.png",
                      fit: BoxFit.cover,
                    ),
                    Center(
                      child: Text(
                        student['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: widget.baseFontSize * 1.6,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
