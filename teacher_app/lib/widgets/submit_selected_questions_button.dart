import 'package:flutter/material.dart';

class SubmitSelectedQuestionsButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitSelectedQuestionsButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 1, 151, 168),
        ),
        child: const Text(
          'Submit Selected Questions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}