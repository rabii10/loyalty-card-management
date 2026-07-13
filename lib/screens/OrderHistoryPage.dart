import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtenir l'utilisateur actuellement connecté
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Orders History'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Orders').where('UserID', isEqualTo: user!.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No orders found.'));
          }
          List<QueryDocumentSnapshot> orders = snapshot.data!.docs;
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              return ListTile(
                title: Text("Order ID: ${order.id}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Price: \DT${order['TotalPrice']}'),
                    Text('Status: ${order['status']}'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailsPage(order: order),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class OrderDetailsPage extends StatelessWidget {
  final QueryDocumentSnapshot order;

  const OrderDetailsPage({required this.order});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Container(
          height: 40,
          decoration: BoxDecoration(),
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
            Text('PhoneNumber: ${order['PhoneNumber']}'),
          ],
        ),
      ),
    );
  }
}
