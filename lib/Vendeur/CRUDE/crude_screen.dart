import 'package:flutter/material.dart';
import '../seller_login_form.dart';
import 'crude_operation.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Operation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => CRUDEoperation(),
        '/seller_login_form.dart': (context) => SellerLoginForm(),
      },
    );
  }
}

