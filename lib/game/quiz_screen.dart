import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/game/question_model.dart';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  final Function(int score, bool isPassed) onQuizComplete;

  QuizScreen({required this.onQuizComplete});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questionList = [];
  int currentQuestionIndex = 0;
  int score = 0;
  Answer? selectedAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    try {
      QuerySnapshot questionSnapshot = await _db.collection('questions').get();
      List<Question> loadedQuestions = await Future.wait(
        questionSnapshot.docs.map((doc) async {
          print("Loading question: ${doc.id}");
          Question question = await Question.fromFirestore(doc);
          print("Loaded question: ${question.questionText}");
          return question;
        }).toList(),
      );

      setState(() {
        questionList = loadedQuestions;
      });

      print("Total questions loaded: ${questionList.length}");
    } catch (e) {
      print("Error loading questions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 50, 80),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Quiz Game",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            Expanded(
              child: questionList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _questionWidget(),
                  _answerList(),
                ],
              ),
            ),
            _nextButton(),
          ],
        ),
      ),
    );
  }

  Widget _questionWidget() {
    if (questionList.isEmpty) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Question ${currentQuestionIndex + 1}/${questionList.length.toString()}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            questionList[currentQuestionIndex].questionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  Widget _answerList() {
    if (questionList.isEmpty) {
      return Container();
    }
    return Column(
      children: questionList[currentQuestionIndex]
          .answersList
          .map(
            (e) => _answerButton(e),
      )
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 48,
      child: ElevatedButton(
        child: Text(answer.answerText),
        style: ElevatedButton.styleFrom(
          foregroundColor: isSelected ? Colors.white : Colors.black,
          backgroundColor: isSelected ? Colors.orangeAccent : Colors.white,
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          if (selectedAnswer == null) {
            if (answer.isCorrect) {
              score++;
            }
            setState(() {
              selectedAnswer = answer;
            });
          }
        },
      ),
    );
  }

  Widget _nextButton() {
    bool isLastQuestion = currentQuestionIndex == questionList.length - 1;

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      child: ElevatedButton(
        child: Text(isLastQuestion ? "Submit" : "Next"),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          shape: const StadiumBorder(),
        ),
        onPressed: () {
          if (selectedAnswer == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please select an answer")),
            );
            return;
          }
          if (isLastQuestion) {
            widget.onQuizComplete(score, score >= questionList.length * 0.6);
            Navigator.pop(context);
          } else {
            setState(() {
              selectedAnswer = null;
              currentQuestionIndex++;
            });
          }
        },
      ),
    );
  }
}
