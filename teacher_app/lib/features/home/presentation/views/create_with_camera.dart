import 'package:flutter/material.dart';
import 'package:teacher_app/widgets/custombutton.dart';

class CreateWithCameraPage extends StatelessWidget {
  const CreateWithCameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    double horizontalPadding = screenWidth * 0.05;
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
                  // "Use Camera" Button
                  ReusableButton(
                    label: 'Use Camera',
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    hasIcon: true,
                    icon: Icons.camera_alt_rounded,
                  ),
                  SizedBox(width: 10),
                  ReusableButton(
                    label: 'Upload',
                    onPressed: () {},
                    hasIcon: true,
                    icon: Icons.upload_file,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Uploaded file display
              Text('Uploaded'),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(Icons.insert_drive_file, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                        hintText: 'No file selected',
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                        enabled: false,
                      ),
                    )),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.grey),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Questions Section
              Text(
                'Which questions do you want to include in the session?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10),

              // List of questions

              SizedBox(height: 20),

              // Generate Button
              SizedBox(
                width: double.infinity,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
