import 'dart:io';

import 'package:aicx_pro/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Animation/fade_animation.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email, _username, _password;
  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
  SharedPreferences pref;
  // var url = "http://192.168.8.101/API/login.php";
  var url = "http://192.168.43.209/API/login.php";
  List user;
  bool isNotExist = false;

  get password => this._password;
  get email => this._email;

  final formKey = new GlobalKey<FormState>();
  getUserName() async {
    pref = await _sPref;
    setState(() {
      _username = pref.getString("username");
    });
  }

  Future<Null> getUserByEmailAndPasswordJSON(Map data) async {
    try {
      await MyApp.fetchUserData(url, data).then((val) {
        setState(() {
          user = val;
        });
        return null;
      });
    } on SocketException {
      setState(() {
        isNotExist = true;
      });
    var form = formKey.currentState;
    form.validate();
      print("object");
    }
  }

  @override
  void initState() {
    super.initState();
    // getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: 10.0, color: Colors.blueGrey.withOpacity(0.5))
              ],
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor
                  ]),
            ),
            padding: EdgeInsets.only(
                top: 40.0, right: 25.0, bottom: 50.0, left: 25.0),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FadeAnimation(
                  800,
                  Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("img/Logo.png"),
                            fit: BoxFit.fill)),
                  ),
                ),
                Text("Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Josefin",
                        fontSize: 45.0,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          SizedBox(height: 80.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black,
                        )),
                    validator: (str) {
                      if (isNotExist) {
                        setState(() {
                          isNotExist = false;
                        });
                        return "Email Is Wrong, or check the internet";
                      } else if (str.length < 3) {
                        return "Email must be at least 3 character";
                      } else if (!str.contains("@")) {
                        return "Please Enter Valid Email";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (str) => _email = str,
                  ),
                  SizedBox(height: 30.0),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        labelStyle: TextStyle(color: Colors.black),
                        labelText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.black,
                        )),
                    obscureText: true,
                    validator: (str) {
                      if (isNotExist) {
                        setState(() {
                          isNotExist = false;
                        });
                        return "Password is Wrong, or check the internet";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (str) => _password = str,
                  ),
                  SizedBox(height: 50.0),
                  Container(
                    width: 200.0,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).accentColor
                        ]),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10.0,
                            color: Colors.blueGrey.withOpacity(0.5),
                            offset: Offset(-3.0, 7.0),
                          )
                        ],
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: FlatButton(
                      highlightColor: Colors.white,
                      color: Colors.transparent.withOpacity(0.0),
                      padding: EdgeInsets.all(20.0),
                      child: Text("Login"),
                      textColor: Colors.white,
                      onPressed: () {
                        onLoginBtnPressed(context);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onLoginBtnPressed(BuildContext context) async {
    final pref = await _sPref;
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      getUserByEmailAndPasswordJSON(
          {"email": "$_email", "password": "$_password"}).then((val) {
        if (user != null && user.isNotEmpty && !isNotExist) {
          _username = user[0]["username"];
          
          pref.setString("username", _username);
          pref.setString("uid", user[0]["userid"]);
          form.reset();
          Navigator.of(context).pushNamedAndRemoveUntil(
              'menus', (Route<dynamic> route) => false);
        } else {
          setState(() {
            isNotExist = true;
          });
          form.validate();
        }
      });
      form.reset();
    }
  }
}
