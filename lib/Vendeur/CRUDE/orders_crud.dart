import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../screens/OrderHistoryPage.dart';

class OrderCRUD extends StatefulWidget {
  const OrderCRUD({Key? key}) : super(key: key);

  @override
  _OrderCRUDState createState() => _OrderCRUDState();
}

class _OrderCRUDState extends State<OrderCRUD> {
  final CollectionReference _ordersCollection = FirebaseFirestore.instance.collection('Orders');

  Future<void> _deleteOrder(String orderId) async {
    await _ordersCollection.doc(orderId).delete();
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    await _ordersCollection.doc(orderId).update({"status": status});
  }

  Widget _buildOrderList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _ordersCollection.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            // Convert DocumentSnapshot to QueryDocumentSnapshot
            QueryDocumentSnapshot orderDocument = document as QueryDocumentSnapshot;

            Map<String, dynamic> data = orderDocument.data()! as Map<String, dynamic>;
            String orderId = orderDocument.id;
            String status = data['status'] ?? "waiting"; // Add a default value

            return ListTile(
              title: Text("Order ID: $orderId"),
              subtitle: Text("Status: $status"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteOrder(orderId),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _showEditDialog(orderId, status),
                  ),
                ],
              ),
              onTap: () {
                // Pass the QueryDocumentSnapshot instead of DocumentSnapshot
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsPage(order: orderDocument),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _showEditDialog(String orderId, String currentStatus) {
    String newStatus = currentStatus;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update Order Status"),
          content: DropdownButton<String>(
            value: newStatus,
            onChanged: (String? newValue) {
              setState(() {
                newStatus = newValue!;
              });
            },
            items: <String>['waiting', 'confirmed', 'not confirmed']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _updateOrderStatus(orderId, newStatus);
                Navigator.of(context).pop();
              },
              child: Text("Update"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
  bool isSearchClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: isSearchClicked
            ? Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 95, 226, 77),
            borderRadius: BorderRadius.circular(20.0),
          ),
        )
            : const Text('Manage Orders'),
        centerTitle: true,
      ),
      body: _buildOrderList(),
    );
  }
}
