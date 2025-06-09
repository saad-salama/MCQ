import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // TODO: Replace with your actual backend URL
  static const String baseUrl = 'https://your-backend-url.com/api';
  
  // Headers for API requests
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Upload MCQ image for processing
  static Future<MCQResult?> uploadMCQImage(File imageFile) async {
    try {
      final uri = Uri.parse('$baseUrl/process-mcq');
      
      // Create multipart request
      var request = http.MultipartRequest('POST', uri);
      
      // Add image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );
      
      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return MCQResult.fromJson(jsonData);
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  // Get user results history
  static Future<List<MCQResult>> getUserResults({String? userId}) async {
    try {
      final uri = Uri.parse('$baseUrl/results${userId != null ? '?userId=$userId' : ''}');
      
      final response = await http.get(uri, headers: headers);
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => MCQResult.fromJson(item)).toList();
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Fetch results error: $e');
      return [];
    }
  }

  // Save user feedback
  static Future<bool> saveFeedback({
    required String resultId,
    required int rating,
    String? comment,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/feedback');
      
      final body = {
        'resultId': resultId,
        'rating': rating,
        'comment': comment,
      };
      
      final response = await http.post(
        uri,
        headers: headers,
        body: json.encode(body),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Save feedback error: $e');
      return false;
    }
  }
}

// Data models for API responses
class MCQResult {
  final String id;
  final String imageUrl;
  final int totalQuestions;
  final int correctAnswers;
  final int wrongAnswers;
  final double accuracy;
  final List<QuestionResult> questions;
  final DateTime createdAt;
  final StudentInfo? studentInfo;

  MCQResult({
    required this.id,
    required this.imageUrl,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.accuracy,
    required this.questions,
    required this.createdAt,
    this.studentInfo,
  });

  factory MCQResult.fromJson(Map<String, dynamic> json) {
    return MCQResult(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      totalQuestions: json['totalQuestions'] ?? 0,
      correctAnswers: json['correctAnswers'] ?? 0,
      wrongAnswers: json['wrongAnswers'] ?? 0,
      accuracy: (json['accuracy'] ?? 0.0).toDouble(),
      questions: (json['questions'] as List<dynamic>?)
          ?.map((q) => QuestionResult.fromJson(q))
          .toList() ?? [],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      studentInfo: json['studentInfo'] != null 
          ? StudentInfo.fromJson(json['studentInfo']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'accuracy': accuracy,
      'questions': questions.map((q) => q.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'studentInfo': studentInfo?.toJson(),
    };
  }
}

class QuestionResult {
  final int questionNumber;
  final String userAnswer;
  final String correctAnswer;
  final bool isCorrect;
  final String? questionText;

  QuestionResult({
    required this.questionNumber,
    required this.userAnswer,
    required this.correctAnswer,
    required this.isCorrect,
    this.questionText,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      questionNumber: json['questionNumber'] ?? 0,
      userAnswer: json['userAnswer'] ?? '',
      correctAnswer: json['correctAnswer'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      questionText: json['questionText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionNumber': questionNumber,
      'userAnswer': userAnswer,
      'correctAnswer': correctAnswer,
      'isCorrect': isCorrect,
      'questionText': questionText,
    };
  }
}

class StudentInfo {
  final String studentName;
  final String studentCode;
  final String? studentId;
  final String? className;
  final String? school;

  StudentInfo({
    required this.studentName,
    required this.studentCode,
    this.studentId,
    this.className,
    this.school,
  });

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      studentName: json['studentName'] ?? '',
      studentCode: json['studentCode'] ?? '',
      studentId: json['studentId'],
      className: json['className'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentName': studentName,
      'studentCode': studentCode,
      'studentId': studentId,
      'className': className,
      'school': school,
    };
  }
} 