import 'package:aicx_pro/main.dart';
import 'package:aicx_pro/task_info.dart';
import 'package:aicx_pro/top_tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpManPage extends StatefulWidget {
  @override
  _HelpManPageState createState() => _HelpManPageState();
}

class _HelpManPageState extends State<HelpManPage> {
  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
  SharedPreferences pref;
  String username;

  // var url = "json/helpTask.json";
  // var url = "http://192.168.8.101/API/helpTask.php";
  var url = "http://192.168.43.209/API/helpTask.php";
  List helpTasks;
  bool done = false;
  String _location, _desc;

  get location => this._location;
  get desc => this._desc;

  final formKey = new GlobalKey<FormState>();

  Future<bool> manipulateTask(Map data) async {
    return await MyApp.postData(url, data);
  }

  Future<Null> refreshTasksList() async {
    await MyApp.fetchData(url).then((val) {
      setState(() {
        helpTasks = val;
      });
      return null;
    });
  }

  getUserName() async {
    pref = await _sPref;
    setState(() {
      username = pref.getString("username");
    });
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    refreshTasksList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding:
          EdgeInsets.only(top: 40.0, right: 20.0, bottom: 20.0, left: 20.0),
      child: Column(
        children: <Widget>[
          TopTileHeader("Hlp", username),
          Divider(height: MediaQuery.of(context).size.height * 0.04),
          Form(
              key: formKey,
              child: Expanded(
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: Text("Show Tasks"),
                            onPressed: () {
                              onShowBtnPressed(context);
                            },
                          ),
                          Builder(
                            builder: (context) => RaisedButton(
                                color: Theme.of(context).accentColor,
                                textColor: Colors.white,
                                child: Text("Add Task"),
                                onPressed: () {
                                  onAddBtnSubmited(context);
                                }),
                          ),
                        ],
                      ),
                    ),
                    TextFormField(
                      onSaved: (str) => _location = str,
                      validator: (str) => str.length < 3
                          ? "Location Field must be at least 3 character"
                          : null,
                      decoration: InputDecoration(
                          labelText: "Enter Location",
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor))),
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      autofocus: false,
                      onSaved: (str) => _desc = str,
                      validator: (str) => str.length < 10
                          ? "Description Field must be at least 10 character"
                          : null,
                      minLines: 10,
                      maxLines: null,
                      decoration: InputDecoration(
                          labelText: "Enter Description",
                          prefixIcon: Icon(Icons.speaker_notes),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).accentColor))),
                    )
                  ],
                ),
              ))
        ],
      ),
    ));
  }

  void onShowBtnPressed(BuildContext context) {
    helpTasks != null
        ? navigateToTaskInfoWidget(context)
        : Center(child: CircularProgressIndicator());
  }

  Future navigateToTaskInfoWidget(BuildContext context) {
    return Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => TaskInfo(helpTasks, (index) {
              manipulateTask({"id": helpTasks[index]["id"]}).then((value) {
                refreshTasksList();
              });
              return true;
            })));
  }

  void onAddBtnSubmited(BuildContext context) {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      manipulateTask({"location": "$_location", "desc": "$_desc"})
          .then((value) {
        done = value;
        form.reset();
        refreshTasksList();
        validationMessages(context, "Task request send Successfully");
      });
    }
  }

  void validationMessages(BuildContext context, String message) {
    final snack = SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.5),
      elevation: 0.0,
    );
    Scaffold.of(context).showSnackBar(snack);
  }
}
