import 'package:flutter/material.dart';

import 'package:whatatrivia/services/auth.dart';

import 'package:whatatrivia/screens/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool hidePassword = true;
  Icon visibilityIcon = const Icon(Icons.visibility);
  String passwordMessage = 'Show password';
  //collecting text field state as credentials to sign user in
  String userName ='';
  String userEmail ='';
  String userPassword ='';
  String userRole ='';
  List<String> userRoleValues = ['user','admin','dev'];
  List<String> inviteCodeValues = ['user','admin','dev'];
  bool inviteCodeAccepted = false;
  String userConfirmPassword ='';
  String errorOnForm ='';

  @override
  Widget build(BuildContext context) {
    if(hidePassword){
      visibilityIcon = const Icon(Icons.visibility);
      passwordMessage = 'Show password';
    }else{
      visibilityIcon = const Icon(Icons.visibility_off);
      passwordMessage = 'Hide password';
    }
    return loading ? const Loading() : Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 20.0),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                        validator: (val) => val!.isEmpty ? 'Enter a valid email address' : null,
                        onChanged: (val){
                          setState(() => userEmail = val);
                        }
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        validator: (val) => val!.length < 6 ? 'Your password must have at least 6 characters' : null,
                        obscureText: hidePassword,
                        onChanged: (val){
                          setState(() => userPassword = val);
                        }),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Confirm password',
                        ),
                        validator: (val) {
                          if (val! != userPassword) {
                            return 'The password confirmation does not match';
                          }
                          return null;
                        },
                        obscureText: hidePassword,
                        onChanged: (val){
                          setState(() => userConfirmPassword = val);
                        }
                    ),
                    TextButton.icon(
                      label: Text(passwordMessage),
                      icon: visibilityIcon,
                      //style:TextButton.styleFrom(primary: Colors.white),
                      onPressed: () {
                        setState(() => hidePassword = !hidePassword);
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Invite code',
                      ),
                      validator: (val) {
                        print(val);
                        for (int i = 0; i < inviteCodeValues.length; i++) {
                          print(inviteCodeValues[i]);
                          if(val == inviteCodeValues[i] || inviteCodeAccepted){
                            inviteCodeAccepted = true;
                            userRole = userRoleValues[i];
                          }
                        }
                        print(inviteCodeAccepted);
                        if (!inviteCodeAccepted) {
                          return 'The invite code is not valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style:ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            widget.toggleView();
                          },
                        ),
                        const SizedBox(width: 20.0),
                        ElevatedButton(
                          style:ElevatedButton.styleFrom(backgroundColor: Colors.lightGreen[800]),
                          child: const Text('Create Account', style: TextStyle(color: Colors.white)),
                          onPressed: () async{
                            if(_formKey.currentState!.validate()){
                              setState (() => loading = true);
                              dynamic result = await _auth.registerWithEmailAndPassword(userEmail, userPassword, userRole);
                              if (result==null){
                                setState(() => errorOnForm = 'Please, provide a valid email address');
                                loading = false;
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0,),
                    Text(errorOnForm, style: const TextStyle(color:Colors.red, fontSize:14.0)),
                    const SizedBox(height: 180.0),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }
}
