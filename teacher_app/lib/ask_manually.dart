import 'package:flutter/material.dart';

class AskManually extends StatefulWidget {
  const AskManually({super.key});

  @override
  _AskManuallyState createState() => _AskManuallyState();
}

class _AskManuallyState extends State<AskManually> {
  bool showTextFields = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 151, 168),
        title: const Text(
          "Ask Manually",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding for better UI spacing
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // First button: Collect Student Answers
              ElevatedButton(
                onPressed: () {
                  // Handle Collect Student Answers action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 151, 168),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: const Size(150, 50), // Width and height
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Collect Student Answers Now & Add Questions Later",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Add some space between the buttons

              // Second button: Create a Question List Manually
              ElevatedButton(
                onPressed: () {
                  // Toggle visibility of TextFormFields
                  setState(() {
                    showTextFields = !showTextFields;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 1, 151, 168),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: const Size(150, 50), // Width and height
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Create a Question List Manually, Now",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16), // Space between the button and text fields

              // Display TextFormFields if showTextFields is true
              if (showTextFields) ...[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Enter Question',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Row for Answer A and Answer B
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Answer A',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(17)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Answer B',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(17)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Row for Answer C and Answer D
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Answer C',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(17)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Answer D',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(17)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Handle Ask button press
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 1, 151, 168),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            minimumSize: const Size(double.infinity, 50), // Full-width button
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Ask",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
