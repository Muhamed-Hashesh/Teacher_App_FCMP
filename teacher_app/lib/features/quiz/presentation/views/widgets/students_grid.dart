import 'package:flutter/material.dart';

class StudentGrid extends StatelessWidget {
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
  Widget build(BuildContext context) {
    // Generate a list of students and their response status
    List<Map<String, dynamic>> students = List.generate(26, (index) {
      return {
        'name': 'Student',
        'hasResponded': index % 2 == 0, // Example logic for responding students
      };
    });

    // Separate students based on their response status
    List<Map<String, dynamic>> respondedStudents =
    students.where((student) => student['hasResponded']).toList();
    List<Map<String, dynamic>> notRespondedStudents =
    students.where((student) => !student['hasResponded']).toList();

    // Combine lists with responded students at the top
    List<Map<String, dynamic>> orderedStudents = [
      ...respondedStudents,
      ...notRespondedStudents,
    ];

    return GridView.builder(
      padding: EdgeInsets.all(screenWidth * 0.01),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1,
        crossAxisSpacing: screenWidth * 0.01,
        mainAxisSpacing: screenHeight * 0.01,
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
                      fontSize: baseFontSize * 1.6,
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
  }
}