import 'package:flutter/material.dart';

class TopTileHeader extends StatelessWidget {
  
  TopTileHeader(this.type,this.username);

  final String username;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).accentColor.withOpacity(0.2),
              blurRadius: 10.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).accentColor,
          child: Text(
            "$type",
            style: TextStyle(color: Colors.white),
          ),
          radius: 25.0,
        ),
        title: Text("$username"),
        trailing: IconButton(
          iconSize: 25.0,
          highlightColor: Colors.white,
          color: Theme.of(context).accentColor,
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}