import 'package:aicx_pro/Animation/fade_animation.dart';
import 'package:aicx_pro/inventory_items.dart';
import 'package:flutter/material.dart';

class InventoryMenu extends StatefulWidget {
  @override
  _InventoryMenuState createState() => _InventoryMenuState();
}

class _InventoryMenuState extends State<InventoryMenu> {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text("Inventory Menu"),
      ),
      body: Center(
        child: Container(
          width: width * 0.85,          
          margin: EdgeInsets.only(top: 80.0),
          child: Center(
            child: GridView.count(
              crossAxisCount: 2,
              children: <Widget>[
                FadeAnimation(
                    500,
                    buildMenuButton(context, "Search By Id", Icons.vpn_key, () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InventoryItems("id")));
                    })),
                FadeAnimation(
                    800,
                    buildMenuButton(context, "Search By Item", Icons.clear_all, () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InventoryItems("Item")));
                    })),
                FadeAnimation(
                    1200,
                    buildMenuButton(context, "Search By Category", Icons.category, () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InventoryItems("Cat")));
                    })),
                FadeAnimation(
                    1500,
                    buildMenuButton(context, "Search By Location", Icons.location_on,
                        () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InventoryItems("location")));
                    })),
                FadeAnimation(
                    1800,
                    buildMenuButton(
                        context, "Back", Icons.subdirectory_arrow_left,
                        () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "menus", (Route<dynamic> route) => false);
                    })),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuButton(
      BuildContext context, String text, IconData icon, Function onPressed) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(left: 15.0, right: 15.0, bottom: height * 0.06),
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
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 30.0,
              color: Colors.black,
            ),
            FlatButton(
                child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 17.0),),
                textColor: Colors.black,
                splashColor: Theme.of(context).primaryColor,
                onPressed: onPressed),
          ],
        ),
      ),
    );
  }
}
