import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/provider/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce/model/fidelity_card.dart';
import 'package:flutter/cupertino.dart';

class FidelityCardProvider extends ChangeNotifier {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  ProductProvider? productProvider;

  Future<void> createFidelityCardForUser(
      String clientName, String clientAddress) async {
    User? user = auth.currentUser;
    FidelityCard card = FidelityCard(
      id: user!.uid,
      clientName: clientName,
      clientAddress: clientAddress,
      qrCode: 'QR code',
      barCode: 'Barre code',
      loyaltyPoints: 0,
    );
    await db.collection('FidelityCards').doc(user.uid).set(card.toMap());
  }

  Future<void> updateLoyaltyPoints(
      String userId, int newLoyaltyPoints) async {
    await db
        .collection('FidelityCards')
        .doc(userId)
        .update({'loyaltyPoints': newLoyaltyPoints});

  }

  Future<FidelityCard> getFidelityCardForUser() async {
    User? user = auth.currentUser;
    if (user == null) {
      throw Exception("No users are currently logged in.");
    }

    DocumentSnapshot snapshot;
    try {
      snapshot = await db.collection('FidelityCards').doc(user.uid).get();
    } catch (e) {
      throw Exception("Loyalty card recovery failed : $e");
    }

    if (!snapshot.exists) {
      String? clientName = user.displayName;
      if (clientName == null || clientName.isEmpty) {
        clientName = 'Nom inconnu';
      }
      await createFidelityCardForUser(
          clientName, user.email ?? 'Adresse inconnue');
      snapshot = await db.collection('FidelityCards').doc(user.uid).get();
    }

    Map<String, dynamic> data =
    snapshot.data() as Map<String, dynamic>;
    String? clientName = data['clientName'];
    if (clientName == null || clientName.isEmpty) {
      clientName = user.displayName ?? 'Nom inconnu';
    }

    return FidelityCard(
      id: user.uid,
      clientName: clientName,
      clientAddress: data['clientAddress'],
      qrCode: data['qrCode'],
      barCode: data['barCode'],
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
    );
  }
}








