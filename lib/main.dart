import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aicx_pro/Inventory_menu.dart';
import 'package:aicx_pro/help_man.dart';
import 'package:aicx_pro/hr_page.dart';
import 'package:aicx_pro/it_repo.dart';
import 'package:aicx_pro/login_page.dart';
import 'package:aicx_pro/menu.dart';
import 'package:aicx_pro/model/emp_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  static Future<List> fetchUserData(String url, Map data) async {
    try {
      http.Response res = await http.post(Uri.encodeFull(url), body: data);
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } on SocketException {
      return throw SocketException(
          "Request timeout, Please check your internet connection");
    } on FormatException {
      return throw FormatException(
          "DB Error: Unexpected Character\nProblem with API");
    }
    return null;
  }

  static Future<bool> postData(String url, Map data) async {
    try {
      http.Response res = await http.post(Uri.encodeFull(url), body: data);
      if (res.statusCode == 200) {
        return true;
      }
    } on SocketException {
      return throw SocketException(
          "Request timeout, Please check your internet connection");
    } on FormatException {
      return throw FormatException(
          "DB Error: Unexpected Character\nProblem with API");
    }
    return false;
  }

  static Future<List<Employees>> fetchempData(String url) async {
    try {
      http.Response res = await http.get(url);
      if (res.statusCode == 200) {
        EmpApi empApi = EmpApi.fromJson(jsonDecode(res.body));
        return empApi.employees;
      }
    } on SocketException {
      return throw SocketException(
          "Request timeout, Please check your internet connection");
    } on FormatException {
      return throw FormatException(
          "DB Error: Unexpected Character\nProblem with API");
    }
    return null;
  }

  static Future<List> fetchData(String url) async {
    try {
      http.Response res = await http.get(Uri.encodeFull(url));
      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      }
    } on SocketException {
      return throw SocketException(
          "Request timeout, Please check your internet connection");
    } on FormatException {
      return throw FormatException(
          "DB Error: Unexpected Character\nProblem with API");
    }
    return null;
  }

  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
  SharedPreferences pref;
  String username;
  bool indicator = true;

  getUserName() async {
    pref = await _sPref;
    setState(() {
      username = pref.getString("username");
      indicator = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    print(username);
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          accentTextTheme: TextTheme(body1: TextStyle(color: Colors.black)),
          primaryColor: Color.fromRGBO(170, 45, 0, 1.0),
          accentColor: Color.fromRGBO(232, 116, 0, 1.0)),
      debugShowCheckedModeBanner: false,
      home: indicator
          ? Container(
              color: Colors.white,
            )
          : username != null ? HomeMenu() : LoginPage(),
      routes: {
        "menus": (context) => HomeMenu(),
        "login": (context) => LoginPage(),
        "hrPage": (context) => HRPage(),
        "inventory": (context) => InventoryMenu(),
        "helpMan": (context) => HelpManPage(),
        "itRepo": (context) => ITRepo()
      },
      title: "AICS App",
    );
  }
}
