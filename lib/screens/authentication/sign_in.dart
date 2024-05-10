import 'dart:math';
import 'package:flutter/material.dart';
import 'package:whatatrivia/screens/authentication/sign_in_anonymous.dart';

import 'package:whatatrivia/services/auth.dart';
import 'package:whatatrivia/screens/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  const SignIn({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String userEmail ='';
  String userPassword ='';
  String errorOnForm ='';
  //collecting text field state as credentials to sign user in

  @override

  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double horizontalPadding = size.width/30;
    final double verticalPadding = size.height/40;
    final double fontSizeTitle = pow(size.height, 1/2).toDouble();
    final double fontSizeSubtitle = pow(size.height, 1/2) / 1.5;
    //final double fontSizeText = pow(size.height, 1/2) / 1.75;
    final double padding = pow(size.width, 1/4)*1.5;

    return loading ? const Loading() : Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding*2),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                    height: min(size.height/3, size.width*(3/4)/1.618),
                    width: min(size.width*3/4, size.height/3*1.618),
                    semanticLabel: 'Golf Ball Country',
                    image: const AssetImage('assets/images/GBCLogo.png')),
                SizedBox(height: verticalPadding),
                Text('Sign In to Continue', style: TextStyle(color:Colors.lightBlue[700], fontSize:fontSizeTitle)),
                SizedBox(height: verticalPadding),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: verticalPadding),
                      TextFormField(
                          decoration: const InputDecoration(labelText: 'Email'),
                          style: TextStyle(fontSize:fontSizeSubtitle),
                          validator: (val) =>  (!(val!.contains('@')) || !(val.toLowerCase().contains('.com'))) ? 'Enter a valid email address' : null,
                          onChanged: (val){
                            setState(() => userEmail = val);
                          }
                      ),
                      SizedBox(height: verticalPadding),
                      TextFormField(
                          decoration: const InputDecoration(labelText: 'Password',),
                          style: TextStyle(fontSize:fontSizeSubtitle),
                          validator: (val) => (val!.length < 6) ? 'Valid passwords have at least 6 characters' : null,
                          obscureText: true,
                          onChanged: (val){
                            setState(() => userPassword = val);
                          }
                      ),
                      SizedBox(height: verticalPadding*2),
                      ElevatedButton(
                        style:ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen[800]),
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Text('        Sign In        ', style: TextStyle(color: Colors.white, fontSize:fontSizeSubtitle)),
                        ),
                        onPressed: () async{
                          setState (() => loading = true);
                          if(_formKey.currentState!.validate()){
                            dynamic result = await _auth.signInWithEmailAndPassword(userEmail, userPassword);
                            loading = false;
                            if (result==null){
                              setState(() {
                                errorOnForm = 'Incorrect email and/or password';
                              });
                            }
                          }else{
                            errorOnForm = 'Please, review your email and/or password';
                            loading = false;
                          }
                        },
                      ),
                      SizedBox(height: verticalPadding/2, width: horizontalPadding/2),
                      ElevatedButton(
                        style:ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                        onPressed: (){},
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Text('Reset Password', style: TextStyle(color: Colors.white, fontSize:fontSizeSubtitle)),
                        ),
                      ),
                      SizedBox(height: verticalPadding),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            label: Text('Create a new account', style: TextStyle(fontSize:fontSizeSubtitle)),
                            icon: const Icon(Icons.person_add_alt_1_rounded),
                            style:TextButton.styleFrom(foregroundColor: Colors.lightBlue[600]),
                            onPressed: () {
                              widget.toggleView();
                            },
                          ),
                          Text('or', style: TextStyle(color:Colors.lightBlue[600], fontSize:fontSizeSubtitle)),
                          SignInAnonymously(toggleView: widget.toggleView),
                        ],
                      ),
                      SizedBox(height: verticalPadding/2,),
                      Text(errorOnForm, style: TextStyle(color:Colors.red, fontSize:fontSizeSubtitle)),
                    ],
                  ),
                ),
                SizedBox(height: verticalPadding*4),
              ]
          ),
        ),
      ),
    );
  }
}
