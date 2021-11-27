import 'package:flutter/material.dart';
import 'package:aicx_pro/model/emp_api.dart';

import 'Animation/fade_animation.dart';

class EmployeeInfo extends StatelessWidget {
  const EmployeeInfo({
    Key key,
    @required this.employees,
  }) : super(key: key);

  final List<Employees> employees;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(top: 40.0),
      height: Orientation.landscape == null ? height * 0.45 : height * 0.3,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).accentColor.withOpacity(0.2),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: employees.length <= 0
          ? Center(
              child: Text("Search For Employees"),
            )
          : ListView.builder(
              itemExtent: width * 0.9,
              scrollDirection: Axis.horizontal,
              itemCount: employees.length,
              itemBuilder: (context, index) {
                return FadeAnimation(800, Card(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Date\n\n${employees[index].day}\n${employees[index].month}\n${employees[index].year}",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        VerticalDivider(
                          color: Theme.of(context).accentColor,
                          width: 30.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).accentColor,
                                    radius: 15.0,
                                    child: Text("${employees[index].iD}",
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.white
                                        )),
                                  ),
                                ),
                                Text("${employees[index].name}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                padding: EdgeInsets.only(left: 40.0),
                                width: width * 0.50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("Time In"),
                                        Icon(Icons.subdirectory_arrow_left),
                                        Text("${employees[index].arraivtime}")
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text("Time Out"),
                                        Icon(Icons.subdirectory_arrow_right),
                                        Text("${employees[index].livvingtime}")
                                      ],
                                    )

                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ));
              }),
    );
  }
}
