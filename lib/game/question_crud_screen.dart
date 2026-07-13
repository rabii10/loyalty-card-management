import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce/game/question_model.dart';

class QuestionCrudScreen extends StatefulWidget {
  @override
  _QuestionCrudScreenState createState() => _QuestionCrudScreenState();
}

class _QuestionCrudScreenState extends State<QuestionCrudScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Question> questionList = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      QuerySnapshot questionSnapshot = await _db.collection('questions').get();
      List<Question> loadedQuestions = await Future.wait(
        questionSnapshot.docs.map((doc) async {
          return Question.fromFirestore(doc);
        }).toList(),
      );

      setState(() {
        questionList = loadedQuestions;
      });
    } catch (e) {
      print("Error loading questions: $e");
    }
  }

  Future<void> _addQuestion(Question question) async {
    DocumentReference docRef = await _db.collection('questions').add(question.toMap());
    // Met à jour l'ID du document dans la base de données
    await docRef.update({'docId': docRef.id});
    _loadQuestions();
  }

  Future<void> _updateQuestion(String id, Question question) async {
    await _db.collection('questions').doc(id).update(question.toMap());
    _loadQuestions();
  }

  Future<void> _deleteQuestion(String id) async {
    await _db.collection('questions').doc(id).delete();
    _loadQuestions();
  }

  void _showQuestionDialog({Question? question, String? docId}) {
    TextEditingController questionController = TextEditingController();
    List<TextEditingController> answerControllers = List.generate(4, (index) => TextEditingController());
    List<bool> answerCorrect = List.generate(4, (index) => false);

    if (question != null) {
      questionController.text = question.questionText;
      for (int i = 0; i < question.answersList.length; i++) {
        answerControllers[i].text = question.answersList[i].answerText;
        answerCorrect[i] = question.answersList[i].isCorrect;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(question == null ? 'Add Question' : 'Edit Question'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: InputDecoration(labelText: 'Question'),
              ),
              for (int i = 0; i < answerControllers.length; i++)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: answerControllers[i],
                        decoration: InputDecoration(labelText: 'Answer ${i + 1}'),
                      ),
                    ),
                    Checkbox(
                      value: answerCorrect[i],
                      onChanged: (bool? value) {
                        setState(() {
                          answerCorrect[i] = value ?? false;
                        });
                      },
                    )
                  ],
                )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                List<Answer> answers = [];
                for (int i = 0; i < answerControllers.length; i++) {
                  answers.add(Answer(
                    answerText: answerControllers[i].text,
                    isCorrect: answerCorrect[i],
                  ));
                }

                if (question == null) {
                  _addQuestion(Question(
                    questionText: questionController.text,
                    answersList: answers,
                    docId: '',
                  ));
                } else {
                  _updateQuestion(docId!, Question(
                    questionText: questionController.text,
                    answersList: answers,
                    docId: '',
                  ));
                }

                Navigator.pop(context);
              },
              child: Text(question == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Container(
          height: 40,
          decoration: BoxDecoration(),
          child: Center(
            child: Text('Manage Questions'),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: questionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(questionList[index].questionText),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: questionList[index].answersList.map((answer) {
                return Text("${answer.answerText} ${answer.isCorrect ? '(Correct)' : ''}");
              }).toList(),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showQuestionDialog(
                      question: questionList[index],
                      docId: questionList[index].docId,
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteQuestion(questionList[index].docId);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showQuestionDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


