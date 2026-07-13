import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsCRUD extends StatefulWidget {
  const ProductsCRUD({Key? key}) : super(key: key);

  @override
  _ProductsCRUDState createState() => _ProductsCRUDState();
}

class _ProductsCRUDState extends State<ProductsCRUD> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _featureProductCollection =
  FirebaseFirestore.instance.collection('products').doc('featureproduct').collection('items');
  final CollectionReference _newAchivesCollection =
  FirebaseFirestore.instance.collection('products').doc('newachives').collection('items');

  Future<void> _addProduct(String collection) async {
    String name = _nameController.text.trim();
    String image = _imageController.text.trim();
    int price = int.tryParse(_priceController.text.trim()) ?? 0;

    if (collection == 'featureproduct') {
      await _featureProductCollection.add({
        'name': name,
        'image': image,
        'price': price,
      });
    } else if (collection == 'newachives') {
      await _newAchivesCollection.add({
        'name': name,
        'image': image,
        'price': price,
      });
    }

    _nameController.clear();
    _imageController.clear();
    _priceController.clear();
  }

  Future<void> _deleteProduct(String collection, String productId) async {
    if (collection == 'featureproduct') {
      await _featureProductCollection.doc(productId).delete();
    } else if (collection == 'newachives') {
      await _newAchivesCollection.doc(productId).delete();
    }
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
            : const Text('Manage Products'),
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
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _addProduct('featureproduct'),
                  child: Text('Add to Feature Product'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => _addProduct('newachives'),
                  child: Text('Add to New Achives'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Feature Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            _buildProductList(_featureProductCollection),
            SizedBox(height: 20),
            Text('New Achives', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            _buildProductList(_newAchivesCollection),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(CollectionReference collectionReference) {
    return StreamBuilder<QuerySnapshot>(
      stream: collectionReference.snapshots(),
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
                trailing: IconButton(
                  onPressed: () => _deleteProduct(collectionReference.id, product.id),
                  icon: Icon(Icons.delete),
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

void main() {
  runApp(MaterialApp(
    home: ProductsCRUD(),
  ));
}
