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

  // Define subject-specific questions
  static final Map<String, List<Map<String, dynamic>>> _subjectQuestions = {
    'Applied Math ': [
      {
        'text': 'What is the derivative of x^2?',
        'options': ['2x', 'x', 'x^2/2', '2'],
        'correctOptionIndex': 0,
        'explanation': 'The power rule states that the derivative of x^n is nx^(n-1). So for x^2, it is 2x^(2-1) = 2x.'
      },
      {
        'text': 'Solve for x: 2x + 5 = 11',
        'options': ['3', '4', '5', '6'],
        'correctOptionIndex': 0,
        'explanation': '2x + 5 = 11  => 2x = 11 - 5 => 2x = 6 => x = 3.'
      },
      {
        'text': 'What is the integral of 3x^2 dx?',
        'options': ['x^3 + C', '3x^3 + C', '6x + C', '3x + C'],
        'correctOptionIndex': 0,
        'explanation': 'The power rule for integration states that the integral of x^n dx is (x^(n+1))/(n+1) + C. So for 3x^2, it is 3 * (x^3)/3 + C = x^3 + C.'
      },
    ],
    'Physics': [
      {
        'text': 'What is Newton\'s second law of motion?',
        'options': ['F=ma', 'E=mc^2', 'P=IV', 'V=IR'],
        'correctOptionIndex': 0,
        'explanation': 'Newton\'s second law states that the force (F) acting on an object is equal to its mass (m) times its acceleration (a).'
      },
      {
        'text': 'What is the unit of electrical resistance?',
        'options': ['Ohm', 'Ampere', 'Volt', 'Watt'],
        'correctOptionIndex': 0,
        'explanation': 'The SI unit of electrical resistance is the Ohm (Ω).'
      },
      {
        'text': 'What phenomenon causes rainbows?',
        'options': ['Dispersion of light', 'Reflection of light', 'Refraction of light', 'Diffraction of light'],
        'correctOptionIndex': 0,
        'explanation': 'Rainbows are caused by the dispersion of sunlight by raindrops, which separates light into its different colors.'
      },
    ],
    'Chemistry': [
      {
        'text': 'What is the chemical symbol for water?',
        'options': ['H2O', 'CO2', 'O2', 'NaCl'],
        'correctOptionIndex': 0,
        'explanation': 'Water is a molecule composed of two hydrogen atoms and one oxygen atom, so its chemical formula is H2O.'
      },
      {
        'text': 'What is the pH of a neutral solution?',
        'options': ['7', '0', '14', '1'],
        'correctOptionIndex': 0,
        'explanation': 'A neutral solution has a pH of 7. Values below 7 are acidic, and values above 7 are alkaline (basic).'
      },
      {
        'text': 'Which gas is most abundant in Earth\'s atmosphere?',
        'options': ['Nitrogen', 'Oxygen', 'Carbon Dioxide', 'Argon'],
        'correctOptionIndex': 0,
        'explanation': 'Nitrogen (N2) makes up about 78% of Earth\'s atmosphere.'
      },
    ],
    'English': [
      {
        'text': 'Which of the following is a synonym for "happy"?',
        'options': ['Joyful', 'Sad', 'Angry', 'Tired'],
        'correctOptionIndex': 0,
        'explanation': '"Joyful" means feeling or expressing great happiness.'
      },
      {
        'text': 'Identify the correct sentence: "They\'re going to ___ house."',
        'options': ['their', 'there', 'they are', 'theirs'],
        'correctOptionIndex': 0,
        'explanation': '"Their" is a possessive pronoun indicating ownership.'
      },
      {
        'text': 'What is the past tense of "go"?',
        'options': ['Went', 'Gone', 'Going', 'Goed'],
        'correctOptionIndex': 0,
        'explanation': 'The past tense of the verb "go" is "went".'
      },
    ],
    'Python': [
      {
        'text': 'What keyword is used to define a function in Python?',
        'options': ['def', 'function', 'fun', 'define'],
        'correctOptionIndex': 0,
        'explanation': 'The "def" keyword is used to define a function in Python.'
      },
      {
        'text': 'Which data type is used to store a sequence of characters?',
        'options': ['str', 'int', 'list', 'bool'],
        'correctOptionIndex': 0,
        'explanation': 'The string (str) data type is used for textual data.'
      },
      {
        'text': 'How do you comment a single line in Python?',
        'options': ['# This is a comment', '// This is a comment', '/* This is a comment */', '-- This is a comment'],
        'correctOptionIndex': 0,
        'explanation': 'A single-line comment in Python starts with the hash (#) symbol.'
      },
    ],
  };


  List<Exam> _getDummyExams() {
    final specificQuestions = _subjectQuestions[subject] ?? [];
    // Fallback to generic questions if no specific questions are defined for the subject
    final defaultQuestionSet = [
      {
        'text': 'Sample question 1 for $subject (default)',
        'options': ['Option A', 'Option B', 'Option C', 'Option D'],
        'correctOptionIndex': 0,
        'explanation': 'This is a default explanation for question 1'
      }
    ];

    final questionsToUse = specificQuestions.isNotEmpty ? specificQuestions : defaultQuestionSet;

    return List.generate(
      10, // Number of exams
      (index) => Exam(
        id: 'exam_s_${subject.replaceAll(' ', '_')}_$index',
        title: '$subject - ${2023 - index}',
        subject: subject,
        year: 2023 - index,
        duration: const Duration(hours: 3),
        questions: List.generate(
          40, // Number of questions per exam
          (qIndex) {
            // Cycle through the available questions if 40 is more than available
            final questionData = questionsToUse[qIndex % questionsToUse.length];
            return Question(
              id: 'q_s_${subject.replaceAll(' ', '_')}_${index}_$qIndex',
              text: questionData['text'] as String,
              options: List<String>.from(questionData['options'] as List),
              correctOptionIndex: questionData['correctOptionIndex'] as int,
              explanation: questionData['explanation'] as String,
            );
          },
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
