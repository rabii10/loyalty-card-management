import 'package:e_commerce/screens/homepage.dart';
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => HomePage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xfff8f8f8),
          title: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => HomePage()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 27),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20), // Add some space at the top
                Text(
                  "About",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
                Image(
                  image: AssetImage("images/about.png"),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 280,
                  width: 360,
                  child: Wrap(
                    children: [
                      Text(
                        "With This App You Can Buy Watch Perfume Makeup Glasses And Bracelet And Many Other Product In Cheap Price, "
                            "Now Its Time Buy SomeThing",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Add some space at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }
}
