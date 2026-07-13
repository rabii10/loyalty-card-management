import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class NotificationButton extends StatefulWidget {
  @override
  _NotificationButtonState createState() => _NotificationButtonState();
}

class _NotificationButtonState extends State<NotificationButton> {
  ProductProvider? productProvider;

  @override
  void initState() {
    super.initState();
    productProvider = Provider.of<ProductProvider>(context, listen: false);
  }

  Future<void> myDialogBox(context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          actions: [
            TextButton(
              child: Text("Clear Notification"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  productProvider?.notificationList.clear();
                });
              },
            ),
            TextButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(productProvider!.notificationList.isNotEmpty
                    ? "Your Product On Way"
                    : "No Notification At Yet"),

              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      position: badges.BadgePosition.topStart(top: 8, start: 25),
      badgeContent: Container(
        color: Colors.red,
        child: Text(
          productProvider?.getNotificationIndex.toString() ?? '0',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      child: IconButton(
        icon: Icon(
          Icons.notifications_none,
          color: Colors.black,
        ),
        onPressed: () {
          myDialogBox(context);
        },
      ),
    );
  }
}
