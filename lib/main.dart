import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'views/chat/dashboard_screen_1.dart';
import 'views/authentication/login_screen.dart';
import 'views/authentication/signin_screen.dart';
import 'views/chat/chat_screen.dart';
import 'views/test/firebase_test_simple.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IT Message',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      initialRoute: '/signin',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signin': (context) => const SigninScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/chat': (context) => const ChatScreen(chatUserId: ''),
        '/firebase_test_simple': (context) => const FirebaseTestSimple(),
      },
    );
  }
}
