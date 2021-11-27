import 'package:flutter/material.dart';

class ItemInfo extends StatelessWidget {
  const ItemInfo({
    Key key,
    @required this.itemsList,
  }) : super(key: key);

  final List itemsList;

  @override
  Widget build(BuildContext context) {
    return itemsList.isNotEmpty? ListView.builder(
      itemCount: itemsList.length,
      itemBuilder: (context, index) => Column(
        children: <Widget>[
          ExpansionTile(
            title: Text("${itemsList[index]["Item"]}"),
            subtitle: Text("${itemsList[index]["Cat"]}"),
            leading: DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13.0),
                    border: Border.all(
                        color: Theme.of(context).accentColor, width: 5.0)),
                child: CircleAvatar(
                  radius: 20.0,
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text("${itemsList[index]["id"]}"),
                )),
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 250.0,
                margin: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0.0, 10.0),
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      blurRadius: 10.0
                    )
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text("Id : ${itemsList[index]["id"]}"),
                      Text("Name : ${itemsList[index]["Item"]}"),
                      Text("Brand : ${itemsList[index]["Brand"]}"),
                      Text("Model : ${itemsList[index]["Model"]}"),
                      Text("Category : ${itemsList[index]["Cat"]}"),
                      Text("Inventory # : ${itemsList[index]["InvNum"]}"),
                      Text("Quantity : ${itemsList[index]["quantity"]}"),
                      Text("Specification : ${itemsList[index]["Specification"]}"),
                      Text("Status : ${itemsList[index]["Status"]}"),
                      Text("Location : ${itemsList[index]["location"]}")
                    ],
                  ),
                ),
              )
            ],
          ),
          index != (itemsList.length - 1)
              ? Divider(
                  color: Theme.of(context).accentColor,
                  indent: 20.0,
                  endIndent: 20.0,
                  height: MediaQuery.of(context).size.height * 0.04)
              : Container(),
        ],
      ),
    ):Center(child: Text("Item search result here"),);
  }
}
