import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MultiplicationApp());
}

class MultiplicationApp extends StatelessWidget {
  const MultiplicationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tabla Inmultirii',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Main Home Page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int selectedTable = 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFB6C1), Color(0xFFFFF0F5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Header with Matilda
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.95, end: 1.05)
                          .animate(_animationController),
                      child: const Text(
                        'Salut! Eu sunt Matilda!', // Emoji removed
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B008B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Vino sa invatam tabla inmultirii JUCAND!', // Emoji removed
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFFFF1493),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Table Selection
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Ce tabla vrei sa inveti?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF8B008B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List<Widget>.generate(10, (int index) {
                        final int num = index + 1;
                        final bool isSelected = selectedTable == num;
                        return GestureDetector(
                          onTap: () => setState(() => selectedTable = num),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFFF1493)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: isSelected
                                      ? const Color(0xFFFF1493)
                                      : Colors.grey,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '$num',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFFFF1493),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),

              // Start Button
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF1493),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    onPressed: () => Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            QuizPage(table: selectedTable),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Incepe Aventura!', // Emoji removed
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.play_arrow, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Quiz Page
class QuizPage extends StatefulWidget {
  final int table;

  const QuizPage({Key? key, required this.table}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> with TickerProviderStateMixin {
  late List<Question> questions;
  int currentQuestionIndex = 0;
  int score = 0;
  bool answered = false;
  int? selectedAnswer;
  late AnimationController _celebrationController;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    generateQuestions();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  void generateQuestions() {
    questions = <Question>[];
    final Random random = Random();
    for (int i = 0; i < 10; i++) {
      final int num = random.nextInt(10) + 1;
      final int answer = widget.table * num;
      final Set<int> options = <int>{answer};

      while (options.length < 4) {
        options.add(random.nextInt(100) + 1);
      }

      questions.add(
        Question(
          question: '${widget.table} x $num = ?',
          correctAnswer: answer,
          options: options.toList()..shuffle(),
        ),
      );
    }
  }

  void handleAnswer(int selected) {
    if (answered) return;

    setState(() {
      selectedAnswer = selected;
      answered = true;
      if (selected == questions[currentQuestionIndex].correctAnswer) {
        score += 10;
        _celebrationController.forward().then((_) {
          _celebrationController.reverse();
        });
      }
    });
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answered = false;
        selectedAnswer = null;
      });
    } else {
      Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => ResultsPage(
            score: score,
            total: questions.length * 10,
            table: widget.table,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Question question = questions[currentQuestionIndex];
    final double progress = (currentQuestionIndex + 1) / questions.length;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFFFFB6C1), Color(0xFFFFF0F5)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Puncte: $score',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF1493),
                          ),
                        ),
                        Text(
                          '${currentQuestionIndex + 1}/${questions.length}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B008B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress < 0.5
                              ? const Color(0xFFFF1493)
                              : Color.lerp(
                                  const Color(0xFFFF1493),
                                  Colors.green,
                                  progress,
                                )!,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Question
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ScaleTransition(
                        scale: Tween<double>(begin: 0.8, end: 1.0)
                            .animate(_celebrationController),
                        child: Container(
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B008B),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Answers
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: <Widget>[
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: question.options.map<Widget>((int option) {
                        final bool isSelected = selectedAnswer == option;
                        final bool isCorrect =
                            option == question.correctAnswer;
                        final bool shouldShowGreen = answered && isCorrect;
                        final bool shouldShowRed =
                            answered && isSelected && !isCorrect;

                        return GestureDetector(
                          onTap: () => handleAnswer(option),
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: shouldShowGreen
                                  ? Colors.green
                                  : shouldShowRed
                                      ? Colors.red
                                      : isSelected
                                          ? const Color(0xFFFF1493)
                                          : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: isSelected
                                      ? const Color(0xFFFF1493)
                                      : Colors.grey,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '$option',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ||
                                          shouldShowGreen ||
                                          shouldShowRed
                                      ? Colors.white
                                      : const Color(0xFFFF1493),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    if (answered)
                      Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: selectedAnswer ==
                                      question.correctAnswer
                                  ? Colors.green
                                  : Colors.orange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                if (selectedAnswer == question.correctAnswer)
                                  const Icon(Icons.check_circle,
                                      color: Colors.white),
                                if (selectedAnswer != question.correctAnswer)
                                  const Icon(Icons.cancel,
                                      color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  selectedAnswer ==
                                          question.correctAnswer
                                      ? 'Corect! Bravo!' // Emoji removed
                                      : 'Incearca din nou! Raspunsul corect era ${question.correctAnswer}', // Emoji removed
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFFFF1493),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: nextQuestion,
                              child: const Text(
                                'Urmatoarea',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Results Page
class ResultsPage extends StatefulWidget {
  final int score;
  final int total;
  final int table;

  const ResultsPage({
    Key? key,
    required this.score,
    required this.total,
    required this.table,
  }) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String getAchievement() {
    final double percentage = (widget.score / widget.total) * 100;
    if (percentage == 100) {
      return 'PERFECTIUNE!'; // Emoji removed
    } else if (percentage >= 80) {
      return 'EXCELENT!'; // Emoji removed
    } else if (percentage >= 60) {
      return 'BRAVO!'; // Emoji removed
    } else {
      return 'INCEARCA DIN NOU!'; // Emoji removed
    }
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = (widget.score / widget.total) * 100;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[Color(0xFFFFB6C1), Color(0xFFFFF0F5)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Celebration icon
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.5, end: 1.2)
                        .animate(_confettiController),
                    child: const Icon(
                      Icons.celebration, // Replaced emoji with IconData
                      size: 80,
                      color: Color(0xFF8B008B),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Achievement
                  Text(
                    getAchievement(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B008B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Score
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Scor Final',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFFFF1493),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${widget.score}/${widget.total}',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B008B),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF1493),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () => Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => QuizPage(table: widget.table),
                        ),
                        (Route<dynamic> route) => false,
                      ),
                      child: const Text(
                        'Incearca Aceeasi Tabla',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            color: Color(0xFFFF1493),
                            width: 2,
                          ),
                        ),
                      ),
                      onPressed: () => Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const HomePage(),
                        ),
                        (Route<dynamic> route) => false,
                      ),
                      child: const Text(
                        'Intoarce la Home',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF1493),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Question Model
class Question {
  final String question;
  final int correctAnswer;
  final List<int> options;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });
}
