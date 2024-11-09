import 'package:flutter/material.dart';
import 'package:teacher_app/features/create_session_page/presentation/views/createsessionpage.dart';
import 'package:teacher_app/quiz_reports.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const Center(child: Text('Chat Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    const Center(child: Text('Question Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    const CreateSessionPage(), // Remove const
    const QuizReportsPage(), // Remove const
    const Center(child: Text('Student Page', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.family_restroom),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_rounded),
            label: 'Questions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Quiz Reports',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            label: 'Student',
          ),
        ],
      ),
    );
  }
}
