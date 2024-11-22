import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/features/create_session_page/presentation/views/createsessionpage.dart';
import 'package:teacher_app/quiz_reports.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => onAppOpen());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onAppOpen();
    }
  }

  /// Method to check session collections and create a new session if conditions are met
  Future<void> checkAndCreateSession() async {
    final firestore = FirebaseFirestore.instance;
    final sessionsCollection = firestore.collection('Sessions');

    try {
      final sessionsSnapshot = await sessionsCollection.get();
      final sessionIDs = sessionsSnapshot.docs
          .map((doc) => doc.id)
          .where((id) => id.startsWith('SessionID'))
          .map((id) => int.tryParse(id.replaceFirst('SessionID', '')))
          .whereType<int>()
          .toList();
      sessionIDs.sort();

      final latestSessionID = sessionIDs.isNotEmpty ? sessionIDs.last : 0;
      final latestSessionDocRef =
          sessionsCollection.doc('SessionID$latestSessionID');

      int subcollectionCount = 0;

      try {
        final subcollection1Snapshot = await latestSessionDocRef
            .collection('QuestionLists')
            .limit(1)
            .get();
        if (subcollection1Snapshot.docs.isNotEmpty) {
          subcollectionCount++;
        }
      } catch (e) {
        log('QuestionLists does not exist.');
      }

      try {
        final subcollection2Snapshot =
            await latestSessionDocRef.collection('ClassLists').limit(1).get();
        if (subcollection2Snapshot.docs.isNotEmpty) {
          subcollectionCount++;
        }
      } catch (e) {
        log('ClassLists does not exist.');
      }

      if (subcollectionCount >= 2) {
        final nextSessionID = latestSessionID + 1;
        final nextSessionDocRef =
            sessionsCollection.doc('SessionID$nextSessionID');

        final newSessionSnapshot = await nextSessionDocRef.get();
        if (!newSessionSnapshot.exists) {
          await nextSessionDocRef.set({});
          log('Created new session: SessionID$nextSessionID');
        } else {
          log('SessionID$nextSessionID already exists, skipping creation.');
        }
      } else {
        log('Not enough subcollections in SessionID$latestSessionID, no new session created.');
      }
    } catch (e) {
      log('Error checking or creating session: $e');
    }
  }

  /// Method triggered when the app is opened or resumed
  void onAppOpen() async {
    log('App opened or resumed!');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('App opened or resumed!'),
    ));
    await checkAndCreateSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const Center(
        child: Text('Chat Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    const Center(
        child: Text('Question Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    const CreateSessionPage(),
    const QuizReportsPage(),
    const Center(
        child: Text('Student Page',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
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
