import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/screens/homepage.dart';
import 'package:e_commerce/screens/login.dart';
import 'package:e_commerce/widgets/changescreen.dart';
import 'package:e_commerce/widgets/mybutton.dart';
import 'package:e_commerce/widgets/mytextformField.dart';
import 'package:e_commerce/widgets/passwordtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/fidelity_card_provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RegExp regExp = RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  bool obserText = true;
  TextEditingController email = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController address = TextEditingController();

  bool isMale = true;
  bool isLoading = false;

  void submit() async {
    UserCredential? result;
    try {
      setState(() {
        isLoading = true;
      });
      result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      print(result);
      await FidelityCardProvider().createFidelityCardForUser(userName.text, address.text);
    } on PlatformException catch (error) {
      var message = "Please Check Your Internet Connection ";
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: Duration(milliseconds: 600),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          duration: Duration(milliseconds: 600),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      print(error);
    }

    FirebaseFirestore.instance.collection("User").doc(result?.user?.uid).set({
      "UserName": userName.text,
      "UserId": result?.user?.uid,
      "UserEmail": email.text,
      "UserAddress": address.text,
      "UserGender": isMale == true ? "Male" : "Female",
      "UserNumber": phoneNumber.text,
    });

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
    setState(() {
      isLoading = false;
    });
  }

  void validation() {
    if (userName.text.isEmpty &&
        email.text.isEmpty &&
        password.text.isEmpty &&
        phoneNumber.text.isEmpty &&
        address.text.isEmpty) {
      showSnackBar("All Fields Are Empty");
    } else if (userName.text.length < 6) {
      showSnackBar("Name Must Be at Least 6 Characters");
    } else if (email.text.isEmpty) {
      showSnackBar("Email is Empty");
    } else if (!regExp.hasMatch(email.text)) {
      showSnackBar("Please Enter a Valid Email");
    } else if (password.text.isEmpty) {
      showSnackBar("Password is Empty");
    } else if (password.text.length < 8) {
      showSnackBar("Password Must Be at Least 8 Characters");
    } else if (phoneNumber.text.length != 8) {
      showSnackBar("Phone Number Must Be 8");
    } else if (address.text.isEmpty) {
      showSnackBar("Address is Empty");
    } else {
      submit();
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget buildAllTextFormField() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          MyTextFormField(
            name: "UserName",
            controller: userName,
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "Email",
            controller: email,
          ),
          SizedBox(
            height: 10,
          ),
          PasswordTextFormField(
            obserText: obserText,
            controller: password,
            name: "Password",
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                obserText = !obserText;
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isMale = !isMale;
              });
            },
            child: Container(
              height: 60,
              padding: EdgeInsets.only(left: 10),
              width: double.infinity,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      isMale == true ? "Male" : "Female",
                      style: TextStyle(color: Colors.black87, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "Phone Number",
            controller: phoneNumber,
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "Address",
            controller: address,
          ),
        ],
      ),
    );
  }

  Widget buildBottomPart() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildAllTextFormField(),
          SizedBox(
            height: 10,
          ),
          isLoading == false
              ? MyButton(
            name: "SignUp",
            onPressed: () {
              validation();
            },
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
          ChangeScreen(
            name: "Login",
            whichAccount: "I Have Already An Account!",
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => Login(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: [
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 500,
            child: buildBottomPart(),
          ),
        ],
      ),
    );
  }
}

