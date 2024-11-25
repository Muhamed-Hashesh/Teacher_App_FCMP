// result_page.dart

import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  ResultPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Result Page"),
      ),
      body: Center(
        child: Text(
          "This is the Result Page.",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
