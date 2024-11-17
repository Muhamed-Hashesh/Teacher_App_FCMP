import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teacher_app/features/home/presentation/views/camera_page.dart';
import 'package:teacher_app/widgets/custombutton.dart';

class CreateWithCameraPage extends StatefulWidget {
  const CreateWithCameraPage({super.key});

  @override
  CreateWithCameraPageState createState() => CreateWithCameraPageState();
}

class CreateWithCameraPageState extends State<CreateWithCameraPage> {
  String? capturedImagePath;
  String? extractedText;

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
                  ReusableButton(
                    label: 'Use Camera',
                    onPressed: () async {
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
                        });
                      }
                    },
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    hasIcon: true,
                    icon: Icons.camera_alt_rounded,
                  ),
                  const SizedBox(width: 10),
                  ReusableButton(
                    label: 'Upload',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Upload not implemented')),
                      );
                    },
                    hasIcon: true,
                    icon: Icons.upload_file,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Uploaded file display
              const Text('Uploaded'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.insert_drive_file, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'No file selected',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                          enabled: false,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () {
                        // Add functionality to clear uploaded file
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Questions Section
              const Text(
                'Which questions do you want to include in the session?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),

              // Placeholder for List of Questions (empty for now)

              const SizedBox(height: 20),

              // Display Captured Image (if any)
              if (capturedImagePath != null)
                Column(
                  children: [
                    const Text(
                      'Captured Image:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Image.file(
                      File(capturedImagePath!),
                      height: 200,
                    ),
                  ],
                ),

              // Display Extracted Text (if any)
              if (extractedText != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Extracted Text:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(extractedText!),
                  ],
                ),

              const SizedBox(height: 20),

              // Generate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add functionality to start the quiz
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
