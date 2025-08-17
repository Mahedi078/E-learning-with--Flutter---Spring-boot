import 'package:e_learning_management_system/screens/quiz_model.dart';
import 'package:e_learning_management_system/services/quiz_service.dart';
import 'package:flutter/material.dart';

class AdminCreateQuizPage extends StatefulWidget {
  const AdminCreateQuizPage({super.key});

  @override
  State<AdminCreateQuizPage> createState() => _AdminCreateQuizPageState();
}

class _AdminCreateQuizPageState extends State<AdminCreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  List<QuestionInput> questions = [QuestionInput()];
  bool _loading = false;

  void _addQuestion() => setState(() => questions.add(QuestionInput()));
  void _removeQuestion(int i) => setState(() => questions.removeAt(i));

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final quiz = Quiz(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      questions: questions.map((q) => q.toQuestion(withCorrect: true)).toList(),
    );

    final success = await QuizService().createQuiz(quiz);
    setState(() => _loading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quiz created'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to create'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(
        title: const Text('Create Quiz'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Quiz Title',
                      prefixIcon: Icon(Icons.note_alt),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter title' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Short description (optional)',
                      prefixIcon: Icon(Icons.description),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      return QuestionCard(
                        key: ValueKey(index),
                        index: index,
                        questionInput: questions[index],
                        onRemove: questions.length > 1
                            ? () => _removeQuestion(index)
                            : null,
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Question'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                        ),
                        onPressed: _addQuestion,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('Save Quiz'),
                        ),
                      ),
                    ],
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

class QuestionInput {
  final TextEditingController qCtrl = TextEditingController();
  final TextEditingController aCtrl = TextEditingController();
  final TextEditingController bCtrl = TextEditingController();
  final TextEditingController cCtrl = TextEditingController();
  final TextEditingController dCtrl = TextEditingController();
  String correct = 'A';

  Question toQuestion({bool withCorrect = false}) {
    return Question(
      questionText: qCtrl.text.trim(),
      optionA: aCtrl.text.trim(),
      optionB: bCtrl.text.trim(),
      optionC: cCtrl.text.trim(),
      optionD: dCtrl.text.trim(),
      correctOption: withCorrect ? correct : null,
    );
  }
}

class QuestionCard extends StatefulWidget {
  final int index;
  final QuestionInput questionInput;
  final VoidCallback? onRemove;
  const QuestionCard({
    super.key,
    required this.index,
    required this.questionInput,
    this.onRemove,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  @override
  Widget build(BuildContext context) {
    final qi = widget.questionInput;
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Q${widget.index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (widget.onRemove != null)
                  IconButton(
                    onPressed: widget.onRemove,
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                  ),
              ],
            ),
            TextField(
              controller: qi.qCtrl,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: qi.aCtrl,
                    decoration: const InputDecoration(labelText: 'Option A'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: qi.bCtrl,
                    decoration: const InputDecoration(labelText: 'Option B'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: qi.cCtrl,
                    decoration: const InputDecoration(labelText: 'Option C'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: qi.dCtrl,
                    decoration: const InputDecoration(labelText: 'Option D'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Correct:'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: qi.correct,
                  items: const ['A', 'B', 'C', 'D']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => qi.correct = v);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
