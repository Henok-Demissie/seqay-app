import 'package:flutter/material.dart';
import '../../models/exam.dart';
import '../../models/question.dart';
import 'practice_mode_screen.dart';
import 'mock_exam_screen.dart';

class StudyHubScreen extends StatelessWidget {
  const StudyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = [
      'Applied Math ',
      'Physics',
      'Chemistry',
      'English',
      'Python',
    ];

    return DefaultTabController(
      length: subjects.length,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            isScrollable: true,
            tabs: subjects.map((subject) => Tab(text: subject)).toList(),
          ),
        ),
        body: TabBarView(
          children: subjects
              .map((subject) => _SubjectExamList(subject: subject))
              .toList(),
        ),
      ),
    );
  }
}

class _SubjectExamList extends StatelessWidget {
  final String subject;

  const _SubjectExamList({
    required this.subject,
  });

  List<Exam> _getDummyExams() {
    return List.generate(
      10,
      (index) => Exam(
        id: 'exam_$index',
        title: '$subject - ${2023 - index}',
        subject: subject,
        year: 2023 - index,
        duration: const Duration(hours: 3),
        questions: List.generate(
          40,
          (qIndex) => Question(
            id: 'q_$qIndex',
            text: 'Sample question ${qIndex + 1} for $subject',
            options: [
              'Option A',
              'Option B',
              'Option C',
              'Option D',
            ],
            correctOptionIndex: 0,
            explanation:
                'This is a detailed explanation for question ${qIndex + 1}',
          ),
        ),
        lastScore: (index % 2 == 0) ? 85.0 : null,
        questionsAttempted: (index % 2 == 0) ? 38 : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final exams = _getDummyExams();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        final exam = exams[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        exam.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (exam.lastScore != null)
                      CircleAvatar(
                        backgroundColor: Colors.green.shade100,
                        radius: 18,
                        child: Text('${exam.lastScore!.toInt()}%',
                            style: const TextStyle(fontSize: 12)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${exam.questions.length} questions',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (exam.lastScore != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.history, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Last: ${exam.questionsAttempted} attempted',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
                const Divider(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PracticeModeScreen(exam: exam),
                            ),
                          );
                        },
                        icon: const Icon(Icons.book, size: 18),
                        label: const Text('Practice'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MockExamScreen(exam: exam),
                            ),
                          );
                        },
                        icon: const Icon(Icons.timer, size: 18),
                        label: const Text('Mock Exam'),
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
}
