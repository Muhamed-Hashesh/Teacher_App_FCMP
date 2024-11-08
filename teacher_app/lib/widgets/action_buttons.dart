import 'package:flutter/material.dart';
import 'custombutton.dart'; // Assuming ReusableButton is defined here

class ActionButtons extends StatelessWidget {
  final VoidCallback onAddUsingAI;
  final VoidCallback onAddManually;

  const ActionButtons({
    Key? key,
    required this.onAddUsingAI,
    required this.onAddManually,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ReusableButton(
          label: "Add using AI",
          onPressed: onAddUsingAI,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        ),
        const SizedBox(width: 16),
        ReusableButton(
          label: "Add Manually",
          onPressed: onAddManually,
          backgroundColor: Colors.white,
          textColor: Colors.black,
        ),
      ],
    );
  }
}
