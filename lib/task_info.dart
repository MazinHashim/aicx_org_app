import 'package:flutter/material.dart';

class TaskInfo extends StatefulWidget {
  final List taskList;
  final Function onDissmiss;
  TaskInfo(this.taskList, this.onDissmiss);

  @override
  _TaskInfoState createState() => _TaskInfoState();
}

class _TaskInfoState extends State<TaskInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TODO Tasks")),
      body: widget.taskList.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Card(
                child: ListView.builder(
                    itemCount: widget.taskList.length,
                    itemBuilder: (BuildContext context, int index) => Column(
                          children: <Widget>[
                            Dismissible(
                              background: Container(
                                color: Colors.grey[100],
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              direction: DismissDirection.startToEnd,
                              onDismissed: (dirction) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: Text("Confirm"),
                                    titleTextStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0),
                                    content: Text(
                                        "Are you sure for deleting this task ?"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("CANCEL"),
                                        textColor: Theme.of(context).accentColor,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("DELETE"),
                                        textColor: Theme.of(context).accentColor,
                                        onPressed: () {
                                          bool done = widget.onDissmiss(index);
                                          print(done);
                                          if (done) {
                                            validationMessages(context,
                                                "Task Number ${widget.taskList[index]["id"]} has been Deleted Successfully");
                                          }
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              key: Key("${widget.taskList[index]["Location"]}"),
                              child: ExpansionTile(
                                title: Text(
                                    "${widget.taskList[index]["Location"]}"),
                                subtitle: Text(
                                    "${widget.taskList[index]["Descrption"].substring(0, 10)}..."),
                                leading: DecoratedBox(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(13.0),
                                        border: Border.all(
                                            color:
                                                Theme.of(context).accentColor,
                                            width: 5.0)),
                                    child: CircleAvatar(
                                      radius: 20.0,
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: Text(
                                          "${widget.taskList[index]["id"]}"),
                                    )),
                                children: <Widget>[
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height: 150.0,
                                      margin: const EdgeInsets.all(20.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0.0, 10.0),
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.2),
                                                blurRadius: 10.0)
                                          ]),
                                      child: ListView(
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 30.0),
                                              child: Text(
                                                "${widget.taskList[index]["Descrption"]}",
                                                textAlign: TextAlign.center,
                                              ))
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            index != (widget.taskList.length - 1)
                                ? Divider(
                                    color: Theme.of(context).accentColor,
                                    indent: 20.0,
                                    endIndent: 20.0,
                                    height: MediaQuery.of(context).size.height *
                                        0.04)
                                : Container(),
                          ],
                        )),
              ),
            )
          : Center(child: Text("No Tasks Found, Please Add Task")),
    );
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
