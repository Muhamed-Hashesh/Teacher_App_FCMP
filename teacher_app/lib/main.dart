import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teacher_app/createsessionpage.dart';
import 'package:teacher_app/homepage.dart';
import 'auth_service.dart';
import 'signin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
      ),
      initialRoute: AuthService().currentUser == null ? '/signin' : '/myhomepage',
      routes: {
        '/signin': (context) => const SignInPage(),
        // '/signup': (context) => const SignUpPage(),
        '/myhomepage': (context) => const MyHomePage(),
          '/createsessionpage': (context) => const CreateSessionPage(),
      },
    );
  }
}

