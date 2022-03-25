import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_checkin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    FirebaseFirestore.instance
        .collection('increment')
        .doc("data")
        .update({
          'value': FieldValue.increment(1),
          'updatedAt': FieldValue.serverTimestamp(),
        })
        .then((value) => setState(() {}))
        .catchError((error) => print(error));
  }

  @override
  void initState() {
    super.initState();
    // FirebaseFirestore.instance
    //     .collection('increment')
    //     .doc("data")
    //     .get()
    //     .then((documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     int value = documentSnapshot.get("value");
    //     setState(() {
    //       _counter = value;
    //     });
    //   }
    // }).catchError((error) {
    //   FirebaseFirestore.instance
    //       .collection('increment')
    //       .doc("data")
    //       .set({'value': 0});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    '${snapshot.data}',
                    style: Theme.of(context).textTheme.headline4,
                  );
                } else {
                  return const Text('Loading...');
                }
              },
              future: _futureFirestoreRequest(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<int> _futureFirestoreRequest() async{
    return await FirebaseFirestore.instance
        .collection('increment')
        .doc("data")
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        int value = documentSnapshot.get("value");
        return value;
      } else {
        return 0;
      }
    }).catchError(
      (error) => print(error),
    );
  }
}
