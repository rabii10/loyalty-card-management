import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/model/categoryicon.dart';
import 'package:e_commerce/model/product.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  List<Product> watch = [];
  late Product watchData;
  List<Product> makeup = [];
  late Product makeupData;
  List<Product> sunglasses = [];
  late Product sunglassesData;
  List<Product> bracelet = [];
  late Product braceletData;
  List<CategoryIcon> watchIcon = [];
  late CategoryIcon watchiconData;


  Future<void> getWatchIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot watchSnapShot = await FirebaseFirestore.instance
        .collection("categoryicon")
        .doc("0LUmzVuADyaNeobBHzQZ")
        .collection("watch")
        .get();
    watchSnapShot.docs.forEach((element) {
      var data = element.data();
      if (data is Map<String, dynamic>) {
        var image = data["image"];
        if (image is String) {
          watchiconData = CategoryIcon(image: image);
          newList.add(watchiconData);
        }
      }
    });
    watchIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getwatchIconData {
    return watchIcon;
  }
  List<CategoryIcon> makeupIcon = [];
  late CategoryIcon makeupiconData;
  Future<void> getmakeupIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot makeupSnapShot = await FirebaseFirestore.instance
        .collection("categoryicon")
        .doc("0LUmzVuADyaNeobBHzQZ")
        .collection("makeup")
        .get();
    makeupSnapShot.docs.forEach((element) {
      var data = element.data();
      if (data is Map<String, dynamic>) {
        var image = data["image"];
        if (image is String) {
          makeupiconData = CategoryIcon(image: image);
          newList.add(makeupiconData);
        }
      }
    });
    makeupIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getMakeupIcon {
    return makeupIcon;
  }

  List<CategoryIcon> glassesdIcon = [];
  late CategoryIcon glassesiconData;
  Future<void> getGlassesIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot glassesSnapShot = await FirebaseFirestore.instance
        .collection("categoryicon")
        .doc("0LUmzVuADyaNeobBHzQZ")
        .collection("glasses")
        .get();
    glassesSnapShot.docs.forEach((element) {
      var data = element.data();
      if (data is Map<String, dynamic>) {
        var image = data["image"];
        if (image is String) {
          glassesiconData = CategoryIcon(image: image);
          newList.add(glassesiconData);
        }
      }
    });
    glassesdIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getGlassesIcon {
    return glassesdIcon;
  }

  List<CategoryIcon> braceletIcon = [];
  late CategoryIcon braceletIconData;
  Future<void> getBraceletIconData() async {
    List<CategoryIcon> newList = [];
    QuerySnapshot braceletSnapShot = await FirebaseFirestore.instance
        .collection("categoryicon")
        .doc("0LUmzVuADyaNeobBHzQZ")
        .collection("bracelet")
        .get();
    braceletSnapShot.docs.forEach((element) {
      var data = element.data();
      if (data is Map<String, dynamic>) {
        var image = data["image"];
        if (image is String) {
          braceletIconData = CategoryIcon(image: image);
          newList.add(braceletIconData);
        }
      }
    });
    braceletIcon = newList;
    notifyListeners();
  }

  List<CategoryIcon> get getBraceletIcon {
    return braceletIcon;
  }
  Future<void> getWatchData() async {
    List<Product> newList = [];
    QuerySnapshot watchSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("OhJMArB03sqeTQdNwzPS")
        .collection("watch")
        .get();
    watchSnapShot.docs.forEach((element) {
      Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
      if (data != null) {
        watchData = Product(
            image: data["image"],
            name: data["name"],
            price: data["price"]);
        newList.add(watchData);
      }
    });
    watch = newList;
    notifyListeners();
  }

  List<Product> get getWatchList {
    return watch;
  }
  Future<void> getSunglassesData() async {
    List<Product> newList = [];
    QuerySnapshot sunglassesSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("OhJMArB03sqeTQdNwzPS")
        .collection("sunglasses")
        .get();
    sunglassesSnapShot.docs.forEach((element) {
      Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
      if (data != null) {
        sunglassesData = Product(
            image: data["image"],
            name: data["name"],
            price: data["price"]);
        newList.add(sunglassesData);
      }
    });
    sunglasses = newList;
    notifyListeners();
  }

  List<Product> get getsunglassesList {
    return sunglasses;
  }
  
  Future<void> getMakeupData() async {
    List<Product> newList = [];
    QuerySnapshot makeupSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("OhJMArB03sqeTQdNwzPS")
        .collection("makeup")
        .get();
    makeupSnapShot.docs.forEach((element) {
      Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
      if (data != null) {
        makeupData = Product(
            image: data["image"],
            name: data["name"],
            price: data["price"]);
        newList.add(makeupData);
      }
    });
    makeup = newList;
    notifyListeners();
  }

  List<Product> get getMakeupList {
    return makeup;
  }

  Future<void> getBraceletData() async {
    List<Product> newList = [];
    QuerySnapshot braceletSnapShot = await FirebaseFirestore.instance
        .collection("category")
        .doc("OhJMArB03sqeTQdNwzPS")
        .collection("bracelet")
        .get();
    braceletSnapShot.docs.forEach((element) {
      Map<String, dynamic>? data = element.data() as Map<String, dynamic>?;
      if (data != null) {
        braceletData = Product(
            image: data["image"],
            name: data["name"],
            price: data["price"]);
        newList.add(braceletData);
      }
    });
    bracelet = newList;
    notifyListeners();
  }

  List<Product> get getBraceletList {
    return bracelet;
  }

  late List<Product> searchList;
  void getSearchList({required List<Product> list}) {
    searchList = list;
  }

  List<Product> searchCategoryList(String query) {
    List<Product> searchShirt = searchList.where((element) {
      return element.name.toUpperCase().contains(query) ||
          element.name.toLowerCase().contains(query);
    }).toList();
    return searchShirt;
  }
}