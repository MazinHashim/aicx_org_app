import 'dart:io';

import 'package:aicx_pro/Animation/fade_animation.dart';
import 'package:aicx_pro/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeMenu extends StatefulWidget {
  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {

  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
  SharedPreferences pref;
  String username;
  String id;

  var url = "http://192.168.43.209/API/login.php";
  List perm;

  Future<Null> getUserPermissions(Map data) async {
    try {
      await MyApp.fetchUserData(url, data).then((val) {
        setState(() {
          perm = val;
        });
        return null;
      });
    } on SocketException {
      print("Request timeout, Please check your internet connection");
    }
  }

  Future<Null> getUserName() async {
    pref = await _sPref;
    setState(() {
      username = pref.getString("username");
      id = pref.getString("uid");
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    getUserName().then((val){
      getUserPermissions({"id":"$id"});
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(top: 25.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(blurRadius: 10.0, color: Colors.blueGrey)
                  ],
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).accentColor
                      ]),
                ),
                child: Center(
                  child: ListTile(
                    title: Text(
                      "Main Meue",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontFamily: "Josefin",
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Wellcome $username",
                      style:
                          TextStyle(color: Colors.white, fontFamily: "Josefin"),
                    ),
                    leading: FadeAnimation(
                      800,
                      Container(
                        width: 55.0,
                        height: 55.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage("img/Logo.png"),
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: perm != null ? Container(
                width: width * 0.85,
                margin: EdgeInsets.only(top: 30.0),
                child: ListView(
                  children: <Widget>[
                    perm[0]["hr"] == "1" ? FadeAnimation(
                        500,
                        buildMenuButton(context, "Hr System", Icons.perm_identity, () {
                          Navigator.of(context).pushNamed("hrPage");
                        })):Container(),
                    perm[0]["Inventory"] == "1" ? FadeAnimation(
                        800,
                        buildMenuButton(
                            context, "Inventory System", Icons.apps, () {
                          Navigator.of(context).pushNamed("inventory");
                        })):Container(),
                    perm[0]["ahmed"] == "1" ? FadeAnimation(
                        1200,
                        buildMenuButton(context, "Help Man", Icons.perm_identity, () {
                          Navigator.of(context).pushNamed("helpMan");
                        })):Container(),
                    perm[0]["it"] == "1" ? FadeAnimation(
                        1500,
                        buildMenuButton(context, "IT Reporting", Icons.keyboard, () {
                          Navigator.of(context).pushNamed("itRepo");
                        })):Container(),
                    FadeAnimation(
                        1800,
                        buildMenuButton(
                            context, "Logout", Icons.subdirectory_arrow_left,
                            () {
                          pref.clear();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "login", (Route<dynamic> route) => false);
                        })),
                  ],
                ),
              ):Center(child: CircularProgressIndicator(),),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuButton(
      BuildContext context, String text, IconData icon, Function onPressed) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: height * 0.04),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 7.0,
              color: Theme.of(context).primaryColor.withOpacity(0.3),
              offset: Offset(-3.0, 5.0),
            )
          ],
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.white),
      child: FlatButton.icon(
          icon: Icon(
            icon,
            color: Colors.black,
          ),
          label: Text(text),
          textColor: Colors.black,
          splashColor: Theme.of(context).primaryColor,
          padding: EdgeInsets.symmetric(vertical: 15.0),
          onPressed: onPressed),
    );
  }
}
