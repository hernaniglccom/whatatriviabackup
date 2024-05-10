import 'package:flutter/material.dart';
import 'package:whatatrivia/screens/authentication/sign_in.dart';
import 'package:whatatrivia/screens/authentication/sign_in_anonymous.dart';
import 'package:whatatrivia/screens/authentication/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool isNewUser = false;
  void toggleView(){
    setState(() => isNewUser = !isNewUser);
  }

  @override
  Widget build(BuildContext context) {
    if (isNewUser){
      return Register(toggleView:toggleView); //have to pass the function
    }else{
      return SignIn(toggleView:toggleView);
    }
  }
}
