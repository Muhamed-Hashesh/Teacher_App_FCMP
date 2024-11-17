import 'package:flutter/material.dart';

class ReusableButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool hasIcon;
  final IconData icon;

  const ReusableButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color.fromARGB(255, 1, 151, 168),
    this.textColor = Colors.white,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.hasIcon = false,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: const BorderSide(color: Colors.grey),
          ),
          minimumSize: const Size(150, 50), // Width and height
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            hasIcon ? Icon(icon, color: textColor) : const SizedBox(),
            SizedBox(width: hasIcon ? 8 : 0),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
