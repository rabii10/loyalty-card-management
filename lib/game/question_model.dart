import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String docId;
  final String questionText;
  final List<Answer> answersList;

  Question({required this.questionText, required this.answersList, required this.docId});

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'answersList': answersList.map((answer) => answer.toMap()).toList(),
    };
  }

  static Future<Question> fromFirestore(DocumentSnapshot doc) async {
    String questionText = '';
    List<Answer> answersList = [];

    try {
      // Récupérer le texte de la question
      QuerySnapshot questionTextSnapshot = await doc.reference.collection('questionText').get();
      if (questionTextSnapshot.docs.isNotEmpty) {
        questionText = questionTextSnapshot.docs.first.get('question');
      }

      // Récupérer les réponses
      QuerySnapshot answerSnapshot = await doc.reference.collection('answersList').get();
      answersList = answerSnapshot.docs.map((answerDoc) {
        return Answer.fromMap(answerDoc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error loading question data: $e");
    }

    return Question(
      docId: doc.id,
      questionText: questionText,
      answersList: answersList,
    );
  }
}

class Answer {
  final String answerText;
  final bool isCorrect;

  Answer({required this.answerText, required this.isCorrect});

  Map<String, dynamic> toMap() {
    return {
      'answerText': answerText,
      'isCorrect': isCorrect,
    };
  }

  static Answer fromMap(Map<String, dynamic> map) {
    return Answer(
      answerText: map['answerText'],
      isCorrect: map['isCorrect'],
    );
  }
}
