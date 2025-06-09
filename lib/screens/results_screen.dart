import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../services/api_service.dart';

class ResultsScreen extends StatelessWidget {
  final MCQResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: PhosphorIcon(
            PhosphorIcons.arrowLeft(),
            color: const Color(0xFF111318),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Results',
          style: TextStyle(
            color: Color(0xFF111318),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Information at Top
            if (result.studentInfo != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4686F5).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF4686F5).withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.studentInfo!.studentName,
                      style: const TextStyle(
                        color: Color(0xFF111318),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Student Code: ',
                          style: TextStyle(
                            color: const Color(0xFF60708A),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          result.studentInfo!.studentCode,
                          style: const TextStyle(
                            color: Color(0xFF4686F5),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (result.studentInfo!.studentId != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            'Student ID: ',
                            style: TextStyle(
                              color: const Color(0xFF60708A),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            result.studentInfo!.studentId!,
                            style: const TextStyle(
                              color: Color(0xFF4686F5),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            // Overall Score Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4686F5),
                    const Color(0xFF4686F5).withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text(
                    'Your Score',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${result.correctAnswers}/${result.totalQuestions}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(result.accuracy * 100).toStringAsFixed(1)}% Accuracy',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Performance Breakdown
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Correct',
                    result.correctAnswers.toString(),
                    Colors.green,
                    PhosphorIcons.checkCircle(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Wrong',
                    result.wrongAnswers.toString(),
                    Colors.red,
                    PhosphorIcons.xCircle(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    result.totalQuestions.toString(),
                    const Color(0xFF4686F5),
                    PhosphorIcons.listBullets(),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Question-wise Results
            const Text(
              'Question Details',
              style: TextStyle(
                color: Color(0xFF111318),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            ...result.questions.map((question) => _buildQuestionCard(question)),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Share results functionality
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4686F5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PhosphorIcon(
                          PhosphorIcons.shareNetwork(),
                          color: const Color(0xFF4686F5),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Share',
                          style: TextStyle(
                            color: Color(0xFF4686F5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4686F5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color, PhosphorIconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          PhosphorIcon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuestionResult question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: question.isCorrect ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Question Number
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: question.isCorrect ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                question.questionNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Answer Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Your Answer: ',
                      style: TextStyle(
                        color: const Color(0xFF60708A),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      question.userAnswer.isEmpty ? 'Not answered' : question.userAnswer.toUpperCase(),
                      style: TextStyle(
                        color: question.isCorrect ? Colors.green : Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Correct Answer: ',
                      style: TextStyle(
                        color: const Color(0xFF60708A),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      question.correctAnswer.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Status Icon
          PhosphorIcon(
            question.isCorrect ? PhosphorIcons.checkCircle() : PhosphorIcons.xCircle(),
            color: question.isCorrect ? Colors.green : Colors.red,
            size: 20,
          ),
        ],
      ),
    );
  }
} 