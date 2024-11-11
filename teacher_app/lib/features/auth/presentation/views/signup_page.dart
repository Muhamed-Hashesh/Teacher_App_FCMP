// import 'package:flutter/material.dart';
// import 'auth_service.dart'; // Import the auth service

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   void _signUp() async {
//     final email = _emailController.text;
//     final password = _passwordController.text;

//     final user = await AuthService().signUp(email, password);
//     if (user != null) {
//       // Navigate to home page if sign up is successful
//       Navigator.pushReplacementNamed(context, '/myhomepage');
//     } else {
//       // Handle errors (you can use SnackBar or Dialog)
//       print('Sign up failed');
//     }
//   }

//     OutlineInputBorder _customBorder(Color borderColor) {
//     return OutlineInputBorder(
//       borderSide: BorderSide(color: borderColor, width: 2.0),
//       borderRadius: BorderRadius.circular(12.0),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(  backgroundColor: Colors.white,
//         centerTitle: true,title: const Text('Sign Up',
//           style: TextStyle(
//             fontSize: 25,
//             color: Color.fromARGB(255, 1, 151, 168),
//           ),)),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//                SizedBox(
//                 height: 20,
//               ),
//               Container(
//                   height: 200,
//                   width: 200,
//                   child: Image.asset("assets/images/logopulse.jpg")),
//               SizedBox(
//                 height: 40,
//               ),
//               TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   labelStyle:
//                       const TextStyle(color: Color.fromARGB(255, 1, 151, 168)),
//                   enabledBorder: _customBorder(const Color.fromARGB(
//                       255, 218, 218, 218)), // Grey when not focused
//                   focusedBorder: _customBorder(Color.fromARGB(
//                       255, 1, 151, 168)), // Custom color when focused
//                   //  disabledBorder: _customBorder(Colors.grey), // Grey when disabled
//                 ),
//               ),
//               const SizedBox(height: 20),
//               TextField(
//                 controller: _passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   labelStyle: TextStyle(color: Color.fromARGB(255, 1, 151, 168)),
//                   enabledBorder: _customBorder(const Color.fromARGB(
//                       255, 218, 218, 218)), // Grey when not focused
//                   focusedBorder: _customBorder(const Color.fromARGB(
//                       255, 1, 151, 168)), // Custom color when focused
//                   //  disabledBorder: _customBorder(Colors.grey), // Grey when disabled
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _signUp,
//                 style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 1, 151, 168)),
//                 child: const Text(
//                   'Sign Up',
//                   style: TextStyle(color:   Colors.white , fontSize: 20),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/signin');
//                 },
//                 style: ElevatedButton.styleFrom(backgroundColor:  const Color.fromARGB(255, 244, 244, 244)),
//                 child: const Text(
//                   'Already have an account? Sign In',
//                   style: TextStyle(color: const Color.fromARGB(255, 1, 151, 168)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
