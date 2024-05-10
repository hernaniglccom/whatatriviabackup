import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatatrivia/services/dbaseUser.dart';
import 'package:whatatrivia/private_classes/user.dart';
import 'package:whatatrivia/services/auth.dart';
import 'package:whatatrivia/screens/authentication/authentication.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDI0GoNYYjkbZ6cTG73tGAzhVXzmEo9Zbs",
      authDomain: "whatatrivia.firebaseapp.com",
      projectId: "whatatrivia",
      storageBucket: "whatatrivia.appspot.com",
      messagingSenderId: "118013003766",
      appId: "1:118013003766:web:63d14b737badd4251029d7",
      measurementId: "G-PFZDCV8K17"
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser>.value(
      initialData: AppUser(userId: 'none'),
      value: AuthService().user,
      child: MaterialApp(
        title: 'WhatATrivia',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'What a Trivia'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    final AuthService _auth = AuthService();

    return user.userId == 'none' ? const Authenticate() : StreamProvider<UserData?>.value(
        value: UserDatabaseService(userId: user.userId).userData,
        initialData: null,
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Tooltip(
              message: 'Log out',
              child: InkWell(
                /// Log out
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child:  Icon(Icons.logout_rounded,
                        color: Colors.blueGrey),
                  ),
                  onTap: () async {
                    await _auth.signOut();
                  }
              ),
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    ),
    );
  }
}
