import 'dart:math';
import 'package:flutter/material.dart';
import 'package:whatatrivia/services/auth.dart';

class SignInAnonymously extends StatefulWidget {
  final Function toggleView;
  const SignInAnonymously({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignInAnonymously> createState() => _SignInState();
}

class _SignInState extends State<SignInAnonymously> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double fontSizeSubtitle = pow(size.height, 1/2) / 1.5;

    return TextButton.icon(
            label: Text('Enter as a guest', style: TextStyle(fontSize:fontSizeSubtitle)),
            icon: const Icon(Icons.person_add_disabled_rounded),
            style:TextButton.styleFrom(foregroundColor: Colors.lightBlue[600]),
            onPressed: () async{
              dynamic result = await _auth.signInAnon();
              if (result == null){
                //print('Error signing in anonymously.');
              }else{
                //print('signed in');
                //print(result);
                widget.toggleView();
              }
            },
          );
  }
}
