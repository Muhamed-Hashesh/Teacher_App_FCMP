import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:teacher_app/features/home/presentation/views/ask_manually.dart';
import 'package:teacher_app/features/auth/data/auth_service.dart';
import 'package:teacher_app/features/home/presentation/views/generate_ai.dart';
import 'package:teacher_app/features/home/presentation/views/questionbank.dart';
import 'package:teacher_app/features/home/presentation/views/you_question_lists.dart'; // Import the GeneratePage

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final List<String> _classes = [
    'Grade 6 A',
    'Grade 6 B',
    'Grade 5 B',
    'Grade 3 A',
    'Grade 5 C',
    'Grade 4 A'
  ];
  String? _selectedClass;
  bool _isTimed = false;
  bool _isGamified = true;
  bool _isAnonymous = false;
  bool _showOptions = false; // Added variable to track if options are shown

  @override
  Widget build(BuildContext context) {
    // Define the app bar color for reuse
    const Color appBarColor = Color.fromARGB(255, 1, 151, 168);

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 1, 151, 168),
        ),
        child: Text(
          'Teacher App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      ListTile(
        leading: const Icon(Icons.family_restroom),
        title: const Text('Chat', style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
        onTap: () {
          // Handle navigation to Chat page here
          Navigator.pop(context);
        },
      ),
      ListTile(
        leading: const Icon(Icons.school_outlined),
        title: const Text('Student',   style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
        onTap: () {
          // Handle navigation to Student page here
          Navigator.pop(context);
        },
      ),
      const Divider(), // Optional: Adds a separator
      ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Sign Out', style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),),
        onTap: () async {
          // Sign out logic
          await AuthService().signOut();
          // Navigate to sign-in page
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
        },
      ),
    ],
  ),
),

      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text(
          "Create a new session",
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
            children: <Widget>[
              const Text(
                "Which class are you testing?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Required",
                  style: TextStyle(
                    color: Color.fromARGB(255, 97, 97, 97),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: DropdownButton<String>(
                  value: _selectedClass,
                  hint: const Text(
                    "Select a class",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  dropdownColor: Colors.white,
                  underline: const SizedBox(),
                  items: _classes.map((String className) {
                    return DropdownMenuItem<String>(
                      value: className,
                      child: Text(
                        className,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedClass = newValue;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "How will you make the questions for \n this Quiz session?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildButtonWithIcon(
                    FontAwesomeIcons.brain,
                    "Generate using AI",
                    onPressed: () {
                      // Navigate to GeneratePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GeneratePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildButtonWithIcon(
                    Icons.camera_alt,
                    "Generate using camera",
                    onPressed: () {
                      // Navigate to questionBankPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuestionBankPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildButtonWithIcon(
                    Icons.account_balance,
                    "Use Question bank",
                    onPressed: () {
                      // Navigate to questionBankPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const QuestionBankPage()),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildButtonWithIcon(Icons.list, "Your Question lists",
                      onPressed: () {
                    // Navigate to questionBankPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const YourQuestionListsPage()),
                    );
                  }),
                  const SizedBox(height: 8),
                  _buildButtonWithIcon(Icons.edit, "Ask manually",
                      onPressed: () {
                    // Navigate to questionBankPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AskManually()),
                    );
                  }),
                  const SizedBox(height: 20),
                  // Add the Options button here, wrapped in Center if you want it centered
                  Center(
                    child: _buildButtonWithIcon(
                      Icons.settings,
                      "Options",
                      onPressed: () {
                        setState(() {
                          _showOptions = !_showOptions;
                        });
                      },
                      backgroundColor: appBarColor, // Same as app bar
                      foregroundColor: Colors.white, // Text and icon color
                      fullWidth: false, // Do not expand to full width
                    ),
                  ),
                  // Conditionally display the options
                  if (_showOptions) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "Options",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildSwitchTile("Timed", _isTimed, (bool value) {
                      setState(() {
                        _isTimed = value;
                      });
                    }),
                    _buildSwitchTile("Gamified", _isGamified, (bool value) {
                      setState(() {
                        _isGamified = value;
                      });
                    }),
                    _buildSwitchTile("Anonymous", _isAnonymous, (bool value) {
                      setState(() {
                        _isAnonymous = value;
                      });
                    }),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      thumbColor: WidgetStateProperty.all<Color>(Colors.white),
      activeColor: const Color.fromARGB(255, 1, 151, 168),
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildButtonWithIcon(
    IconData icon,
    String label, {
    VoidCallback? onPressed,
    Color? backgroundColor,
    Color? foregroundColor,
    bool fullWidth = true, // Added parameter
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null, // Control the width
      child: ElevatedButton.icon(
        onPressed: onPressed ?? () {},
        icon: Icon(icon, size: 18),
        label: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor ?? Colors.black,
          backgroundColor: backgroundColor ?? Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: backgroundColor == null || backgroundColor == Colors.white
                ? const BorderSide(color: Colors.grey)
                : BorderSide.none, // Remove border if background is colored
          ),
        ),
      ),
    );
  }
}
