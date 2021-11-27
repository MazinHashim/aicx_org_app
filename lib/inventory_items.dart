import 'package:aicx_pro/itemInfo.dart';
import 'package:aicx_pro/main.dart';
import 'package:aicx_pro/top_tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryItems extends StatefulWidget {
  final String searchType;
  InventoryItems(this.searchType);

  @override
  _InventoryItemsState createState() => _InventoryItemsState();
}

class _InventoryItemsState extends State<InventoryItems> {
  Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
  SharedPreferences pref;
  String username;
  // var url = "json/items.json";
  // var url = "http://192.168.8.101/API/showItems.php";
  var url = "http://192.168.43.209/API/showItems.php";
  List items;
  List itemsList;

  getUserName() async {
    pref = await _sPref;
    setState(() {
      username = pref.getString("username");
    });
  }

  @override
  void initState() {
    super.initState();
    itemsList = new List();
    getUserName();
    refreshItemsList();
  }

  Future<Null> refreshItemsList() async {
    await MyApp.fetchData(url).then((val) {
      setState(() {
        items = val;
      });
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.only(
                top: 40.0, right: 20.0, bottom: 20.0, left: 20.0),
            child: Column(children: <Widget>[
              TopTileHeader("Inv", username),
              Divider(height: MediaQuery.of(context).size.height * 0.04),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: buildSearchTextField(widget.searchType),
              ),
              SizedBox(height: 20.0),
              Expanded(
                  child: itemsList != null
                      ? Card(
                          child: ItemInfo(itemsList: itemsList),
                        )
                      : Center(child: CircularProgressIndicator()))
            ])));
  }

  DecoratedBox buildSearchTextField(String type) {
    return DecoratedBox(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
                blurRadius: 10.0,
                color: Theme.of(context).accentColor.withOpacity(0.2))
          ]),
      child: TextField(
        autocorrect: true,
        onChanged: (val) {
          setState(() {
            itemsList.clear();
            items.forEach((item) {
              if (item[type]
                      .toString()
                      .toLowerCase()
                      .compareTo(val.toLowerCase()) ==
                  0) {
                itemsList.add(item);
              }
            });
          });
        },
        decoration: InputDecoration(
            suffix: Text("$type"),
            suffixIcon: Icon(Icons.search),
            contentPadding: EdgeInsets.only(left: 20.0),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: "Enter $type",
            hintStyle: TextStyle(fontSize: 13.0)),
      ),
    );
  }
}
