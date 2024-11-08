import 'package:flutter/material.dart';
import 'customdropdown.dart'; // Assuming ReusableDropdown is defined here

class UploadedFilesDropdown extends StatelessWidget {
  final String? selectedItem;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const UploadedFilesDropdown({
    super.key,
    required this.selectedItem,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ReusableDropdown(
      label: "Select Uploaded File",
      hint: "Select",
      items: items,
      selectedItem: selectedItem,
      onChanged: onChanged,
    );
  }
}
