import 'package:cloud_firestore/cloud_firestore.dart';

class Participant {
  String docId;
  final String name;
  final int score;

  Participant({
    required this.docId,
    required this.name,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'score': score,
    };
  }

  static Participant fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Participant(
      docId: doc.id,
      name: data['name'] ?? '',
      score: data['score'] ?? 0,
    );
  }
}
