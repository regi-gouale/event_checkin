import 'package:event_checkin/ui/screens/home_screen.dart';
import 'package:event_checkin/ui/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen(
      (user) {
        Widget nextScreen = const LoginScreen();
        if (user != null) {
          nextScreen = const HomeScreen();
        }
        if (mounted){
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => nextScreen,
            ),
            (route) => false,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('SplashScreen'),
      ),
    );
  }
}
