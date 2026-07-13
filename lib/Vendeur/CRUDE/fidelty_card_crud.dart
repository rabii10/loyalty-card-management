import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/fidelity_card.dart';
import 'card_widget.dart';

class FidelityCardCRUD extends StatefulWidget {
  const FidelityCardCRUD({Key? key}) : super(key: key);

  @override
  State<FidelityCardCRUD> createState() => _FidelityCardCRUDState();
}

class _FidelityCardCRUDState extends State<FidelityCardCRUD> {
  final CollectionReference _fidelityCardsCollection = FirebaseFirestore.instance.collection('FidelityCards');

  String searchText = '';
  FidelityCard? selectedCard;
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _deleteFidelityCard(String cardId) async {
    await _fidelityCardsCollection.doc(cardId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("You have successfully deleted a Fidelity Card")),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchText = value;
    });
  }

  void _onCardSelected(FidelityCard card) {
    setState(() {
      selectedCard = card;
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
            : const Text('Fidelity Card CRUD'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _fidelityCardsCollection.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  final List<DocumentSnapshot> fidelityCards = streamSnapshot.data!.docs
                      .where((doc) => doc['clientName'].toString().toLowerCase().contains(searchText.toLowerCase()))
                      .toList();
                  return ListView.builder(
                    itemCount: fidelityCards.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot = fidelityCards[index];
                      final card = FidelityCard.fromMap(documentSnapshot.data() as Map<String, dynamic>);
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
                              documentSnapshot['clientName'].toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                          ),
                          title: Text(
                            documentSnapshot['clientName'],
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          subtitle: Text(documentSnapshot['clientAddress'].toString()),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  color: Colors.black,
                                  onPressed: () => _deleteFidelityCard(documentSnapshot.id),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                          onTap: () => _onCardSelected(card),
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
          ),
          if (selectedCard != null)
            Expanded(
              child: Center(
                child: FidelityCardWidget(card: selectedCard!, globalKey: _globalKey),
              ),
            ),
        ],
      ),
    );
  }
}

