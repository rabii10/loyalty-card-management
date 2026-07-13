import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/model/usermodel.dart';
import 'package:e_commerce/screens/homepage.dart';
import 'package:e_commerce/widgets/mybutton.dart';
import 'package:e_commerce/widgets/mytextformField.dart';
import 'package:e_commerce/widgets/notification_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserModel userModel;
  late TextEditingController phoneNumber;
  late TextEditingController address;
  late TextEditingController userName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
  bool isMale = false;
  void validation() async {
    if (userName.text.isEmpty && phoneNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("All Fields Are Empty"),
        ),
      );
    } else if (userName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Name Is Empty "),
        ),
      );
    } else if (userName.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Name Must Be 6 "),
        ),
      );
    } else if (phoneNumber.text.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Phone Number Must Be 8 "),
        ),
      );
    } else {
      userDetailUpdate();
    }
  }
  File? _pickedImage;
  XFile? _image;

  Future<void> getImage({required ImageSource source}) async {
    _image = await ImagePicker().pickImage(source: source);
    if (_image != null) {
      setState(() {
        _pickedImage = File(_image!.path);
      });
    }
  }
  late String userUid;

  Future<String> _uploadImage({required File? image}) async {
    if (image != null) {
      Reference storageReference =
      FirebaseStorage.instance.ref().child("UserImage/$userUid");
      UploadTask uploadTask = storageReference.putFile(image);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    }
    return "";
  }
  void getUserUid() {
    User? myUser = FirebaseAuth.instance.currentUser;
    userUid = myUser!.uid;
  }

  bool centerCircle = false;
  var imageMap;
  void userDetailUpdate() async {
    setState(() {
      centerCircle = true;
    });
    if (_pickedImage != null) {
      String imageUrl = await _uploadImage(image: _pickedImage!);
      if (imageUrl.isNotEmpty) {
        await FirebaseFirestore.instance.collection("User").doc(userUid).update({
          "UserName": userName.text,
          "UserGender": isMale ? "Male" : "Female",
          "UserNumber": phoneNumber.text,
          "UserImage": imageUrl,
          "UserAddress": address.text
        });
      } else {
        print("Échec de l'upload de l'image");
      }
    } else {
      await FirebaseFirestore.instance.collection("User").doc(userUid).update({
        "UserName": userName.text,
        "UserGender": isMale ? "Male" : "Female",
        "UserNumber": phoneNumber.text,
        "UserAddress": address.text
      });
    }
    setState(() {
      centerCircle = false;
      edit = false;
    });
  }




  Widget _buildSingleContainer(
      {required Color color, required String startText, required String endText}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        height: 55,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: edit == true ? color : Colors.white,
          borderRadius: edit == false
              ? BorderRadius.circular(30)
              : BorderRadius.circular(0),
        ),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startText,
              style: TextStyle(fontSize: 17, color: Colors.black45),
            ),
            Text(
              endText,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  late String userImage;
  bool edit = false;
  Widget _buildContainerPart() {
    address = TextEditingController(text: userModel.userAddress);
    userName = TextEditingController(text: userModel.userName);
    phoneNumber = TextEditingController(text: userModel.userPhoneNumber);
    if (userModel.userGender == "Male") {
      isMale = true;
    } else {
      isMale = false;
    }
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSingleContainer(
            endText: userModel.userName,
            startText: "Name", color: Colors.white,
          ),
          _buildSingleContainer(
            endText: userModel.userEmail,
            startText: "Email", color: Colors.white,
          ),
          _buildSingleContainer(
            endText: userModel.userGender,
            startText: "Gender", color: Colors.white,
          ),
          _buildSingleContainer(
            endText: userModel.userPhoneNumber,
            startText: "Phone Number", color: Colors.white,
          ),
          _buildSingleContainer(
            endText: userModel.userAddress,
            startText: "Address", color: Colors.white,
          ),
        ],
      ),
    );
  }

  Future<void> myDialogBox(context) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Pick Form Camera"),
                    onTap: () {
                      getImage(source: ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Pick Form Gallery"),
                    onTap: () {
                      getImage(source: ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTextFormFliedPart() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MyTextFormField(
            name: "UserName",
            controller: userName,
          ),
          _buildSingleContainer(
            color: Colors.grey[300]!,
            endText: userModel.userEmail,
            startText: "Email",
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isMale = !isMale;
              });
            },
            child: _buildSingleContainer(
              color: Colors.white,
              endText: isMale == true ? "Male" : "Female",
              startText: "Gender",
            ),
          ),
          MyTextFormField(
            name: "Phone Number",
            controller: phoneNumber,
          ),
          MyTextFormField(
            name: "Address",
            controller: address,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getUserUid();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: Color(0xfff8f8f8),
      appBar: AppBar(
        leading: edit == true
            ? IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.redAccent,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              edit = false;
            });
          },
        )
            : IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black45,
            size: 30,
          ),
          onPressed: () {
            setState(() {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (ctx) => HomePage(),
                ),
              );
            });
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          edit == false
              ? NotificationButton()
              : IconButton(
            icon: Icon(
              Icons.check,
              size: 30,
              color: Color(0xff746bc9),
            ),
            onPressed: () {
              validation();
            },
          ),
        ],
      ),
      body: centerCircle == false
          ? ListView(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("User").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var myDoc = snapshot.data?.docs;
                myDoc?.forEach((checkDocs) {
                  if (checkDocs.data() is Map<String, dynamic> && (checkDocs.data() as Map<String, dynamic>)["UserId"] == userUid) {
                    userModel = UserModel(
                      userEmail: (checkDocs.data() as Map<String, dynamic>)["UserEmail"] ?? "",
                      userImage: (checkDocs.data() as Map<String, dynamic>)["UserImage"] ?? "",
                      userAddress: (checkDocs.data() as Map<String, dynamic>)["UserAddress"] ?? "",
                      userGender: (checkDocs.data() as Map<String, dynamic>)["UserGender"] ?? "",
                      userName: (checkDocs.data() as Map<String, dynamic>)["UserName"] ?? "",
                      userPhoneNumber: (checkDocs.data() as Map<String, dynamic>)["UserNumber"]?.toString() ?? "",

                    );
                  }
                });

                return Container(
                  height: 603,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  maxRadius: 65,
                                  backgroundImage: _pickedImage == null
                                      ? userModel.userImage == null
                                      ? AssetImage("images/userImage.png") as ImageProvider<Object>?
                                      : NetworkImage(userModel.userImage) as ImageProvider<Object>?
                                      : FileImage(_pickedImage!) as ImageProvider<Object>?,
                                ),
                              ],
                            ),
                          ),
                          edit == true
                              ? Padding(
                            padding: EdgeInsets.only(
                                left: MediaQuery.of(context)
                                    .viewPadding
                                    .left +
                                    220,
                                top: MediaQuery.of(context)
                                    .viewPadding
                                    .left +
                                    110),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(20),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  myDialogBox(context);
                                },
                                child: CircleAvatar(
                                  backgroundColor:
                                  Colors.transparent,
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Color(0xff746bc9),
                                  ),
                                ),
                              ),
                            ),
                          )
                              : Container(),
                        ],
                      ),
                      Container(
                        height: 350,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                child: edit == true
                                    ? _buildTextFormFliedPart()
                                    : _buildContainerPart(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: edit == false
                              ? MyButton(
                            name: "Edit Profile",
                            onPressed: () {
                              setState(() {
                                edit = true;
                              });
                            },
                          )
                              : Container(),
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}