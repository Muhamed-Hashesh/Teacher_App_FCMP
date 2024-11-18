import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late List<CameraDescription> cameras;
  bool isInitialized = false;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(
          cameras[0], // Use the first camera (usually rear camera)
          ResolutionPreset.medium,
        );
        await _controller.initialize();
        setState(() {
          isInitialized = true;
        });
      } else {
        print("No cameras available");
      }
    } catch (e) {
      print("Camera initialization failed: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> captureAndProcessImage() async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
    });

    try {
      final image = await _controller.takePicture();

      final extractedText = await extractTextFromImage(File(image.path));

      Navigator.pop(context, {
        'imagePath': image.path,
        'extractedText': extractedText,
      });
    } catch (e) {
      print("Error capturing or processing image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to process the image: $e")),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  Future<String> extractTextFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();

      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);

      await textRecognizer.close();

      if (recognizedText.text.isNotEmpty) {
        print("Extracted Text: ${recognizedText.text}");
        return recognizedText.text;
      } else {
        print("No text found in the image.");
        return "No text found.";
      }
    } catch (e) {
      print("Error extracting text: $e");
      return "Failed to extract text.";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Capture Image")),
      body: Stack(
        children: [
          CameraPreview(_controller),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: captureAndProcessImage,
                child: isProcessing
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text("Capture"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
