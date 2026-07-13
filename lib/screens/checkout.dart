import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce/provider/product_provider.dart';
import 'package:e_commerce/widgets/mybutton.dart';
import 'package:e_commerce/widgets/notification_button.dart';
import 'package:e_commerce/model/cartmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../provider/fidelity_card_provider.dart';
import '../widgets/checkout_singleproduct.dart';
import 'homepage.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  TextStyle myStyle = TextStyle(
    fontSize: 18,
  );

  late User user;
  double total = 0.0;
  List<CartModel> myList = [];
  double subTotal = 0;

  ProductProvider productProvider = ProductProvider();

  Widget _buildBottomSingleDetail(
      {required String startName, required String endName}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          startName,
          style: myStyle,
        ),
        Text(
          endName,
          style: myStyle,
        ),
      ],
    );
  }

  Widget _buildButton() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => buyWithCashOnDelivery(subTotal),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue,
          ),
          child: Text("Buy"),
        ),
      ],
    );
  }

  @override
  void initState() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    myList = productProvider.checkOutModelList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = FirebaseAuth.instance.currentUser!;
    subTotal = 0;

    productProvider = Provider.of<ProductProvider>(context);
    productProvider.getCheckOutModelList.forEach((element) {
      subTotal += element.price * element.quentity;
    });

    if (productProvider.checkOutModelList.isEmpty) {}

    return WillPopScope(
      onWillPop: () async {
        return Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()))
            .then((value) => true);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("CheckOut Page", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => HomePage(),
                ),
              );
            },
          ),
          actions: <Widget>[
            NotificationButton(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 70,
          width: 100,
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.only(bottom: 15),
          child: _buildButton(),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: ListView.builder(
                    itemCount: myList.length,
                    itemBuilder: (ctx, myIndex) {
                      return CheckOutSingleProduct(
                        index: myIndex,
                        image: myList[myIndex].image,
                        name: myList[myIndex].name,
                        price: myList[myIndex].price,
                        quentity: myList[myIndex].quentity,
                        status: myList[myIndex].status,
                        color: '',
                        size: '',
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildBottomSingleDetail(
                        startName: "Subtotal",
                        endName: "\DT ${subTotal.toStringAsFixed(2)}",
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void buyWithCashOnDelivery(double subTotal) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String? name;
    String? address;
    String? phoneNumber;

    // Obtenir l'utilisateur actuellement connecté
    User user = FirebaseAuth.instance.currentUser!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Cash On Delivery'),
          content: Form(
            key: _formKey,
            child: Container(
              height: 200,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      name = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      address = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneNumber = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final fidelityCardProvider = Provider.of<FidelityCardProvider>(context, listen: false);
                  final productProvider = Provider.of<ProductProvider>(context, listen: false);
                  final user = FirebaseAuth.instance.currentUser!;
                  final fidelityCard = await fidelityCardProvider.getFidelityCardForUser();

                  // Calcul du nombre de points à ajouter
                  int pointsToAdd = productProvider.checkOutModelList.fold(0, (sum, item) => sum + item.quentity);

                  // Mise à jour du nombre de points de fidélité
                  int newLoyaltyPoints = fidelityCard.loyaltyPoints + pointsToAdd;
                  await fidelityCardProvider.updateLoyaltyPoints(user.uid, newLoyaltyPoints);

                  // Enregistrement de la commande avec l'ID de l'utilisateur
                  FirebaseFirestore.instance.collection("Orders").add({
                    // Ajouter l'ID de l'utilisateur à chaque commande
                    "UserID": user.uid,
                    // Autres champs de la commande
                    "Products": productProvider.getCheckOutModelList
                        .map((c) => {
                      "ProductName": c.name,
                      "ProductPrice": c.price,
                      "ProductQuantity":
                      c.quentity,
                      "ProductImage": c.image,
                    })
                        .toList(),
                    "TotalPrice": subTotal.toStringAsFixed(2),
                    "Name": name,
                    "Address": address,
                    "PhoneNumber": phoneNumber,
                    "status": "waiting",
                  });

                  setState(() {
                    myList.clear();
                  });
                  productProvider.addNotification("Notification");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Your order has been placed successfully. We will contact you shortly to arrange delivery.'),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
              child: Text('Pay On Delivery'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
