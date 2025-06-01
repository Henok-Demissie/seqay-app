import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/exam.dart';
import '../../models/question.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MockExamScreen extends StatefulWidget {
  final Exam exam;

  const MockExamScreen({
    super.key,
    required this.exam,
  });

  @override
  State<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends State<MockExamScreen> {
  late PageController _pageController;
  late List<Question> questions;
  late Timer _timer;
  late Duration _remainingTime;
  bool _isExamComplete = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    questions = widget.exam.questions;
    _remainingTime = widget.exam.duration;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        } else {
          _submitExam();
        }
      });
    });
  }

  void _submitExam() {
    _timer.cancel();
    setState(() {
      _isExamComplete = true;
    });
    _showResults();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isExamComplete) {
      return _buildResultsScreen();
    }

    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Exam?'),
            content: const Text(
                'Are you sure you want to exit? Your progress will be lost.'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        return shouldPop;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.exam.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _remainingTime.inMinutes < 5
                    ? Colors.red.withOpacity(0.1)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.timer,
                    size: 18,
                    color: _remainingTime.inMinutes < 5
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_remainingTime.inHours.toString().padLeft(2, '0')}:${(_remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _remainingTime.inMinutes < 5
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ).animate(onComplete: (controller) => controller.repeat())
                .conditional(
                  condition: _remainingTime.inMinutes < 5,
                  animate: (target) => target.fadeOut(duration: const Duration(milliseconds: 700))
                      .fadeIn(duration: const Duration(milliseconds: 700)),
                ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Question ${_pageController.hasClients ? (_pageController.page?.toInt() ?? 0) + 1 : 1} of ${questions.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _showQuestionOverview(),
                    icon: const Icon(Icons.grid_view, size: 18),
                    label: const Text('Question Overview'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      foregroundColor: Theme.of(context).colorScheme.secondary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: questions.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildQuestionCard(questions[index], index);
                },
              ),
            ),
            _buildNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Question ${index + 1} of ${questions.length}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        question.isMarkedForReview ? Icons.flag : Icons.flag_outlined,
                        color: question.isMarkedForReview ? Colors.orange : Colors.grey,
                      ),
                      tooltip: question.isMarkedForReview ? 'Remove flag' : 'Flag for review',
                      onPressed: () {
                        setState(() {
                          question.isMarkedForReview = !question.isMarkedForReview;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  question.text,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(
            question.options.length,
            (optionIndex) => _buildOptionCard(
              question,
              optionIndex,
              question.options[optionIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(Question question, int optionIndex, String optionText) {
    bool isSelected = question.selectedOptionIndex == optionIndex;

    return Card(
      elevation: isSelected ? 2 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.withOpacity(0.2),
          width: isSelected ? 2 : 1,
        ),
      ),
      color: isSelected
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : Theme.of(context).cardColor,
      child: InkWell(
        onTap: () {
          setState(() {
            question.selectedOptionIndex = optionIndex;
            question.isAnswered = true;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + optionIndex),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            title: Text(
              optionText,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(Icons.arrow_back_ios, size: 16),
            label: const Text('Previous'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _submitExam,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Submit Exam'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            label: const Text('Next'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showQuestionOverview() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.grid_view,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Question Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  Color backgroundColor = Colors.grey.shade200;
                  Color textColor = Colors.grey.shade700;
                  
                  if (question.isAnswered) {
                    backgroundColor = Colors.green.shade100;
                    textColor = Colors.green.shade800;
                  }
                  if (question.isMarkedForReview) {
                    backgroundColor = Colors.orange.shade100;
                    textColor = Colors.orange.shade800;
                  }

                  return InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem(Colors.grey.shade200, 'Not Answered'),
                  _buildLegendItem(Colors.green.shade100, 'Answered'),
                  _buildLegendItem(Colors.orange.shade100, 'Marked for Review'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsScreen() {
    int totalQuestions = questions.length;
    int answeredQuestions = questions.where((q) => q.isAnswered).length;
    int correctAnswers = questions.where((q) => q.isCorrect).length;
    double percentage = (correctAnswers / totalQuestions) * 100;
    
    Color resultColor = Colors.blue;
    if (percentage >= 80) {
      resultColor = Colors.green;
    } else if (percentage >= 60) {
      resultColor = Colors.orange;
    } else if (percentage < 40) {
      resultColor = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exam Results',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            strokeWidth: 12,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(resultColor),
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: resultColor,
                              ),
                            ),
                            Text(
                              'Score',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _getResultMessage(percentage),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: resultColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Performance Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildResultsStat('Total Questions', totalQuestions, Icons.help_outline),
                    const Divider(),
                    _buildResultsStat('Questions Attempted', answeredQuestions, Icons.check_circle_outline),
                    const Divider(),
                    _buildResultsStat('Correct Answers', correctAnswers, Icons.thumb_up_outlined),
                    const Divider(),
                    _buildResultsStat('Incorrect Answers', answeredQuestions - correctAnswers, Icons.thumb_down_outlined),
                    const Divider(),
                    _buildResultsStat('Questions Skipped', totalQuestions - answeredQuestions, Icons.skip_next),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.home),
                label: const Text('Return to Study Hub'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getResultMessage(double percentage) {
    if (percentage >= 90) {
      return 'Excellent! Outstanding performance!';
    } else if (percentage >= 80) {
      return 'Great job! Very good performance!';
    } else if (percentage >= 70) {
      return 'Good work! You\'re on the right track.';
    } else if (percentage >= 60) {
      return 'Not bad. Keep practicing!';
    } else if (percentage >= 50) {
      return 'You passed, but there\'s room for improvement.';
    } else {
      return 'Keep studying. You\'ll do better next time!';
    }
  }

  Widget _buildResultsStat(String label, int value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResults() {
    // Here you would typically save the results to local storage
    // and sync with Firebase when online
  }
}