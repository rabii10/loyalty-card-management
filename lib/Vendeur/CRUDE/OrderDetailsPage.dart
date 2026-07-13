import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot order;

  const OrderDetailsPage({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
          ),
          child: Center(
            child: Text('Order Details'),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order ID: ${order.id}"),
            Text('Total Price: \DT${order['TotalPrice']}'),
            Text('Status: ${order['status']}'),
            Text('Address: ${order['Address']}'),
            Text('Name: ${order['Name']}'),
            Text('Products: ${order['Products']}'),
            Text('PhoneNumber: ${order['PhoneNumber']}'),
          ],
        ),
      ),
    );
  }
}
