import 'package:flutter/material.dart';

class UploadFileButton extends StatelessWidget {
  final VoidCallback onPressed;

  const UploadFileButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 1, 151, 168),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            //side: const BorderSide(color: Colors.grey),
          ),
        ),
        onPressed: onPressed,
        icon: const Icon(
          Icons.upload_file,
          color: Colors.white,
        ),
        label: const Text(
          "Upload File",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
