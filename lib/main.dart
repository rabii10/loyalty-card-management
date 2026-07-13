import 'package:e_commerce/provider/category_provider.dart';
import 'package:e_commerce/provider/product_provider.dart';

import 'package:e_commerce/screens/homepage.dart';
import 'package:e_commerce/screens/login.dart';
import 'package:e_commerce/screens/welcomescreen.dart';
import 'package:e_commerce/provider/fidelity_card_provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Fake/home_fake_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: '',
    appId: '',
    messagingSenderId: '', projectId: '',),);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>(
          create: (context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
        ChangeNotifierProvider<FidelityCardProvider>(
          create: (context) => FidelityCardProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xff746bc9),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        debugShowCheckedModeBanner: false,
        home: HomePageFake(),
      ),
    );
  }
}
