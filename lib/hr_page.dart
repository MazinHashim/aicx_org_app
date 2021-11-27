import 'package:aicx_pro/top_tile.dart';
import 'package:flutter/material.dart';
import 'package:aicx_pro/empInfo.dart';
import 'package:aicx_pro/model/emp_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class HRPage extends StatefulWidget {
  HRPage({Key key}) : super(key: key);

  @override
  _HRPageState createState() => _HRPageState();
}

class _HRPageState extends State<HRPage> {
  Set<String> names;
  Set<String> years;
  static final String dayString =
      "01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31";
  final days = dayString.split(" ");
  static final String monthString = "01 02 03 04 05 06 07 08 09 10 11 12";
  final months = monthString.split(" ");

  String nameVal;
  String yearVal;
  String monthVal;
  String dayVal;

  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
  SharedPreferences pref;
  String username;

  // var url = "json/emp.json";
  // var url = "http://192.168.8.101/API/hrEmp.php";
  var url = "http://192.168.43.209/API/hrEmp.php";
  Future<List<Employees>> employees;
  List<Employees> employeesList;

  getUserName() async {
    pref = await _sPref;
    setState(() {
      username = pref.getString("username");
    });
  }

  Future<List<Employees>> refreshEmployeesList() async {
    setState(() {
      employees = MyApp.fetchempData(url);
    });
    return employees;
  }

  void clearDrop() {
    setState(() {
      dayVal = null;
      monthVal = null;
      yearVal = null;
      nameVal = null;
      employeesList.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    employeesList = new List();
    refreshEmployeesList();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    names = new Set();
    years = new Set();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          refreshEmployeesList();
          clearDrop();
        },
        child: Icon(Icons.refresh),
      ),
      body: Padding(
        padding:
            EdgeInsets.only(top: 40.0, right: 20.0, bottom: 20.0, left: 20.0),
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            TopTileHeader("Hr", username),
            Divider(height: MediaQuery.of(context).size.height * 0.06),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Search By",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            RefreshIndicator(
              onRefresh: refreshEmployeesList,
              child: FutureBuilder(
                future: employees,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    if (snapshot.error.runtimeType
                            .toString()
                            .compareTo("SocketException") ==
                        0) {
                      return buildServerErrorMessages(context,
                          "Request timeout, Please check your internet connection");
                    } else {
                      return buildServerErrorMessages(context,
                          "DB Error: Unexpected Character\nProblem with API");
                    }
                  } else if (snapshot.hasData) {
                    snapshot.data.forEach((emp) {
                      names.add(emp.name);
                      years.add(emp.year);
                    });
                    return Column(
                      children: <Widget>[
                        dropdownSearchBy(
                            context, names.toList(), true, "Name(optional)"),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            dropdownSearchBy(
                                context, years.toList(), false, "Year"),
                            dropdownSearchBy(context, months, false, "Month"),
                            dropdownSearchBy(context, days, false, "Day"),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RaisedButton(
                              child: Text("Clear"),
                              elevation: 5.0,
                              highlightColor: Colors.white,
                              hoverElevation: 20.0,
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              onPressed: clearDrop,
                            ),
                            RaisedButton(
                              child: Text("Search"),
                              elevation: 5.0,
                              highlightColor: Colors.white,
                              hoverElevation: 20.0,
                              textColor: Colors.white,
                              color: Theme.of(context).accentColor,
                              onPressed: () {
                                setState(() {
                                  employeesList.clear();
                                  if (nameVal != null ||
                                      (dayVal != null &&
                                          monthVal != null &&
                                          yearVal != null)) {
                                    snapshot.data.forEach((Employees emp) {
                                      if (emp.name.compareTo(nameVal ?? "") ==
                                              0 ||
                                          (emp.day.compareTo(dayVal ?? "") ==
                                                  0 &&
                                              emp.month.compareTo(
                                                      monthVal ?? "") ==
                                                  0 &&
                                              emp.year.compareTo(
                                                      yearVal ?? "") ==
                                                  0)) {
                                        employeesList.insert(0, emp);
                                      }
                                    });
                                  } else {
                                    employeesList.clear();
                                    // validation code here
                                    final snack = SnackBar(
                                      content:
                                          Text("Date records are required"),
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Theme.of(context)
                                          .accentColor
                                          .withOpacity(0.5),
                                      elevation: 0.0,
                                    );
                                    Scaffold.of(context).showSnackBar(snack);
                                  }
                                });
                              },
                            )
                          ],
                        ),
                        EmployeeInfo(employees: employeesList)
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Center buildServerErrorMessages(BuildContext context, String message) {
    return Center(
      child: Card(
        margin: EdgeInsets.only(top: 30.0),
        color: Theme.of(context).accentColor,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.error, color: Colors.white, size: 52),
              SizedBox(height: 20.0),
              Text("$message",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<String> dropdownSearchBy(BuildContext context,
      List<String> searchList, bool isExpanded, String hint) {
    String myVal() {
      if (hint.contains("Name")) return nameVal;
      if (hint.contains("Year")) return yearVal;
      if (hint.contains("Month")) return monthVal;
      if (hint.contains("Day")) return dayVal;
      return nameVal;
    }

    return DropdownButton<String>(
        isExpanded: isExpanded,
        items: searchList.map((String value) {
          return DropdownMenuItem<String>(child: Text(value), value: value);
        }).toList(),
        itemHeight: 50.0,
        hint: Text(
          hint,
          style: TextStyle(color: Colors.black, fontSize: 17.0),
        ),
        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
        value: myVal(),
        onChanged: (String value) {
          setState(() {
            if (hint.contains("Name"))
              nameVal = value;
            else if (hint.contains("Year"))
              yearVal = value;
            else if (hint.contains("Month"))
              monthVal = value;
            else if (hint.contains("Day")) dayVal = value;
          });
        });
  }
}
