import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_checkin/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:event_checkin/ui/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (kDebugMode) {
    String host = "localhost";

    if (!kIsWeb) {
      host = Platform.isAndroid ? "10.0.2.2" : "localhost";
    }
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
    await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  }

  runApp(const EventCheckin());
}

class EventCheckin extends StatelessWidget {
  const EventCheckin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ICC Lyon Check-in',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      // home: const HomeScreen(),
      home: const SplashScreen(),
    );
  }
}
