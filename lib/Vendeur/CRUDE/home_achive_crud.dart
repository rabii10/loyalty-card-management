import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeAchiveCRUD extends StatefulWidget {
  const HomeAchiveCRUD({Key? key}) : super(key: key);



  @override
  _HomeAchiveCRUDState createState() => _HomeAchiveCRUDState();
}

class _HomeAchiveCRUDState extends State<HomeAchiveCRUD> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _homeAchiveCollection =
  FirebaseFirestore.instance.collection('homeachive');
  late String _currentProductId;
  late String _currentImageURL;
  Future<void> _addProduct() async {
    String name = _nameController.text.trim();
    String image = _imageController.text.trim();
    int price = int.tryParse(_priceController.text.trim()) ?? 0;

    await _homeAchiveCollection.add({
      'name': name,
      'image': image,
      'price': price,
    });

    _nameController.clear();
    _imageController.clear();
    _priceController.clear();
  }
  Future<void> _deleteProduct(String productId) async {
    await _homeAchiveCollection.doc(productId).delete();
  }
  Future<void> _updateProduct() async {
    String name = _nameController.text.trim();
    String image = _imageController.text.trim();
    int price = int.tryParse(_priceController.text.trim()) ?? 0;

    await _homeAchiveCollection.doc(_currentProductId).update({
      'name': name,
      'image': image,
      'price': price,
    });

    _nameController.clear();
    _imageController.clear();
    _priceController.clear();
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
            : const Text('HomeAchive CRUD'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Product Name'),
            ),
            TextFormField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addProduct,
              child: Text('Add Product'),
            ),
            SizedBox(height: 20),
            Text(
              'Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildProductList(),
          ],
        ),
      ),
    );
  }

  // Construire la liste des produits
  Widget _buildProductList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _homeAchiveCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<QueryDocumentSnapshot> products = snapshot.data!.docs;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              var product = products[index];
              return ListTile(
                title: Text(product['name']),
                subtitle: Text('\$${product['price']}'),
                leading: Image.network(
                  product['image'],
                  width: 50,
                  height: 50,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _currentProductId = product.id;
                          _nameController.text = product['name'];
                          _imageController.text = product['image'];
                          _currentImageURL = product['image'];
                          _priceController.text = product['price'].toString();
                        });
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => _deleteProduct(product.id),
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _imageController.text = _currentImageURL;
                        });
                        _updateProduct();
                      },
                      icon: Icon(Icons.update),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
