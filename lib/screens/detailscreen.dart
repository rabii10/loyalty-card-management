import 'package:e_commerce/screens/checkout.dart';
import 'package:e_commerce/screens/homepage.dart';
import 'package:e_commerce/widgets/mybutton.dart';
import 'package:e_commerce/widgets/notification_button.dart';
import 'package:flutter/material.dart';
import '../provider/product_provider.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String name;
  final double price;
  DetailScreen({required this.image, required this.name, required this.price});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int count = 1;
  ProductProvider productProvider = ProductProvider();
  final TextStyle myStyle = TextStyle(
    fontSize: 18,
  );
  Widget _buildImage() {
    return Center(
      child: Container(
        width: 380,
        child: Card(
          child: Container(
            padding: EdgeInsets.all(13),
            child: Container(
              height: 260,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(widget.image),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameToDescriptionPart() {
    return Container(
      height: 100,
      child: Row(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.name, style: myStyle),
              Text(
                "\DT ${widget.price.toString()}",
                style: TextStyle(
                    color: Color(0xff9b96d6),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildQuentityPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Text(
          "Quentity",
          style: myStyle,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 40,
          width: 130,
          decoration: BoxDecoration(
            color: Color(0xff746bc9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    if (count > 1) {
                      count--;
                    }
                  });
                },
              ),
              Text(
                count.toString(),
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              GestureDetector(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonPart() {
    return Container(
      height: 60,
      child: MyButton(
        name: "Add To Cart",
        onPressed: buyNow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    productProvider = Provider.of<ProductProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => HomePage(),
          ),
        ).then((value) => true);

      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Detail Page", style: TextStyle(color: Colors.black)),
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
        body: Container(
          child: ListView(
            children: <Widget>[
              _buildImage(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildNameToDescriptionPart(),
                    _buildQuentityPart(),
                    SizedBox(
                      height: 15,
                    ),
                    _buildButtonPart(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buyNow() {
    productProvider.getCheckOutData(
      image: widget.image,
      name: widget.name,
      price: widget.price,
      quentity: count,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => CheckOut(),
      ),
    );
  }
}
