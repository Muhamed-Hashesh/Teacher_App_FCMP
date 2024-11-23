import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:teacher_app/features/create_session_page/presentation/views/createsessionpage.dart';
import 'package:teacher_app/features/home/presentation/views/homepage.dart';
import 'package:teacher_app/features/quiz/presentation/views/display_mac&grade.dart';

import 'features/auth/data/auth_service.dart';
import 'features/auth/presentation/views/signin_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('Error loading .env file: $e');
  }
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
      initialRoute:
          AuthService().currentUser == null ? '/signin' : '/myhomepage',
      // home: QuestionGeneratorWidget(),
      routes: {
        '/signin': (context) => const SignInPage(),
        // '/signup': (context) => const SignUpPage(),
        '/myhomepage': (context) => const MyHomePage(),
        '/createsessionpage': (context) => const CreateSessionPage(),
        '/resultsPage': (context) => const ResultsPage(),
      },
    );
  }
}
