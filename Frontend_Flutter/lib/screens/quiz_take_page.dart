// lib/screens/quiz_take_page.dart
import 'package:e_learning_management_system/screens/quiz_model.dart';
import 'package:e_learning_management_system/services/quiz_service.dart';
import 'package:flutter/material.dart';

class QuizTakePage extends StatefulWidget {
  final int quizId;
  const QuizTakePage({super.key, required this.quizId});

  @override
  State<QuizTakePage> createState() => _QuizTakePageState();
}

class _QuizTakePageState extends State<QuizTakePage> {
  late Future<Quiz> _futureQuiz;
  int currentIndex = 0;
  final Map<int, String> selected = {};

  @override
  void initState() {
    super.initState();
    _futureQuiz = QuizService().fetchById(widget.quizId);
  }

  void _nextOrSubmit(Quiz quiz) async {
    if (currentIndex < quiz.questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      final result = await QuizService().submitAnswers(quiz.id!, selected);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QuizResultPage(resultText: result['message'] ?? ''),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Quiz>(
      future: _futureQuiz,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snap.error}')));
        }
        final quiz = snap.data!;
        final q = quiz.questions[currentIndex];

        return Scaffold(
          appBar: AppBar(
            title: Text(quiz.title),
            backgroundColor: Colors.deepPurple,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (currentIndex + 1) / quiz.questions.length,
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 12),
                Text(
                  'Question ${currentIndex + 1}/${quiz.questions.length}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.questionText,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ..._optionTile(q.id!, 'A', q.optionA),
                        ..._optionTile(q.id!, 'B', q.optionB),
                        ..._optionTile(q.id!, 'C', q.optionC),
                        ..._optionTile(q.id!, 'D', q.optionD),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    if (currentIndex > 0)
                      OutlinedButton(
                        onPressed: () => setState(() => currentIndex--),
                        child: const Text('Back'),
                      ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => _nextOrSubmit(quiz),
                      child: Text(
                        currentIndex == quiz.questions.length - 1
                            ? 'Submit'
                            : 'Next',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _optionTile(int qid, String code, String text) {
    return [
      RadioListTile<String>(
        value: code,
        groupValue: selected[qid],
        title: Text(text),
        onChanged: (v) => setState(() => selected[qid] = v!),
      ),
    ];
  }
}

class QuizResultPage extends StatelessWidget {
  final String resultText;
  const QuizResultPage({super.key, required this.resultText});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Result'), backgroundColor: Colors.teal),
      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, size: 56, color: Colors.orange),
                const SizedBox(height: 12),
                Text(
                  resultText,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
