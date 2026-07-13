import 'package:e_commerce/Vendeur/seller_login_form.dart';
import 'package:e_commerce/game/vendor_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CRUDE/bot_crud.dart';
import 'CRUDE/crude_operation.dart';
import 'CRUDE/fidelty_card_crud.dart';
import 'CRUDE/home_achive_crud.dart';
import 'CRUDE/homefeature_crud.dart';
import 'CRUDE/orders_crud.dart';
import 'CRUDE/products_crude.dart';
class SellerHomePage extends StatelessWidget {
  bool isSearchClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: isSearchClicked
            ? Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 95, 226, 77),
            borderRadius: BorderRadius.circular(20.0),
          ),
        )
            : const Text('Seller Home Page'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SellerLoginForm()),
                  (route) => false,
            );
          },
          icon: Icon(Icons.logout),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CRUDEoperation()),
                );
              },
              child: Text('Manage Customers', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsCRUD()),
                );
              },
              child: Text('Manage Products', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FidelityCardCRUD()),
                );
              },
              child: Text('Manage FideltyCards', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeAchiveCRUD()),
                );
              },
              child: Text('Manage HomeAchive', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeFeatureCRUD()),
                );
              },
              child: Text('Manage HomeFeature', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderCRUD()),
                );
              },
              child: Text('Manage Orders', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BotCRUD()),
                );
              },
              child: Text('ChatBot', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VendorHome()),
                );
              },
              child: Text('Manage Game', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
