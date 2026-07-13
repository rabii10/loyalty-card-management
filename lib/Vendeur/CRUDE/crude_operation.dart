import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class CRUDEoperation extends StatefulWidget {
  const CRUDEoperation({Key? key}) : super(key: key);

  @override
  State<CRUDEoperation> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<CRUDEoperation> {
  // text field controller
  final TextEditingController _UserAddressController = TextEditingController();
  final TextEditingController _UserEmailController = TextEditingController();
  final TextEditingController _UserGenderController = TextEditingController();
  final TextEditingController _UserNameController = TextEditingController();
  final TextEditingController _UserNumberController = TextEditingController();

  final CollectionReference _User = FirebaseFirestore.instance.collection('User');

  String searchText = '';

  // for delete operation
  Future<void> _delete(String productID) async {
    await _User.doc(productID).delete();

    // for snackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You have successfully deleted a User")),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
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
            : const Text('CRUD Operation'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _User.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final List<DocumentSnapshot> User = streamSnapshot.data!.docs
                .where((doc) => doc['UserName'].toLowerCase().contains(searchText.toLowerCase()))
                .toList();
            return ListView.builder(
              itemCount: User.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = User[index];
                return Card(
                  color: const Color.fromARGB(255, 88, 136, 190),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 17,
                      backgroundColor: const Color.fromARGB(255, 26, 226, 76),
                      child: Text(
                        documentSnapshot['UserEmail'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                    title: Text(
                      documentSnapshot['UserName'],
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    subtitle: Text(documentSnapshot['UserNumber'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            color: Colors.black,
                            onPressed: () => _delete(documentSnapshot.id),
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Create new project button
    );
  }
}