import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'services/camera_service.dart';
import 'services/api_service.dart';
import 'screens/results_screen.dart';

void main() {
  runApp(const MCQApp());
}

class MCQApp extends StatelessWidget {
  const MCQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MCQ Corrector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4686F5)),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const CameraScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFF0F2F5), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF111318),
          unselectedItemColor: const Color(0xFF60708A),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: PhosphorIcon(
                PhosphorIcons.house(),
                color: _currentIndex == 0 ? const Color(0xFF111318) : const Color(0xFF60708A),
              ),
                             activeIcon: PhosphorIcon(
                 PhosphorIcons.house(PhosphorIconsStyle.fill),
                 color: const Color(0xFF111318),
               ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(
                PhosphorIcons.camera(),
                color: _currentIndex == 1 ? const Color(0xFF111318) : const Color(0xFF60708A),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: PhosphorIcon(
                PhosphorIcons.user(),
                color: _currentIndex == 2 ? const Color(0xFF111318) : const Color(0xFF60708A),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Spacer(),
                  const Text(
                    'MCQ Corrector',
                    style: TextStyle(
                      color: Color(0xFF111318),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.015,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      onPressed: () {
                        // Settings functionality
                      },
                      icon: PhosphorIcon(
                        PhosphorIcons.gear(),
                        color: const Color(0xFF111318),
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            
            // Subtitle
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Text(
                'Capture and correct your MCQ papers instantly with our app. Get accurate results and detailed feedback on your performance.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF111318),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Take Photo Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    // Take photo and process MCQ
                    final imageFile = await CameraService.takePhotoFromCamera();
                    if (imageFile != null && context.mounted) {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF4686F5),
                          ),
                        ),
                      );
                      
                      // Process with API (mock result for now)
                      await Future.delayed(const Duration(seconds: 2));
                      
                      // Create mock result - replace with actual API call
                      final mockResult = MCQResult(
                        id: 'mock_id',
                        imageUrl: imageFile.path,
                        totalQuestions: 10,
                        correctAnswers: 7,
                        wrongAnswers: 3,
                        accuracy: 0.7,
                        questions: List.generate(10, (index) => QuestionResult(
                          questionNumber: index + 1,
                          userAnswer: index < 7 ? 'A' : 'B',
                          correctAnswer: 'A',
                          isCorrect: index < 7,
                        )),
                        createdAt: DateTime.now(),
                        studentInfo: StudentInfo(
                          studentName: 'Ethan Carter',
                          studentCode: '12345',
                          studentId: 'STD-2024-001',
                          className: 'Class 10-A',
                          school: 'Springfield High School',
                        ),
                      );
                      
                      if (context.mounted) {
                        Navigator.pop(context); // Remove loading
                        
                        // Navigate to results
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultsScreen(result: mockResult),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4686F5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Take Photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.015,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

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
          'Camera',
          style: TextStyle(
            color: Color(0xFF111318),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 80,
              color: Color(0xFF60708A),
            ),
            SizedBox(height: 16),
            Text(
              'Camera functionality will be implemented here',
              style: TextStyle(
                color: Color(0xFF60708A),
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This will connect to your backend API',
              style: TextStyle(
                color: Color(0xFF60708A),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Spacer(),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Color(0xFF111318),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.015,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      onPressed: () {
                        // Settings functionality
                      },
                      icon: PhosphorIcon(
                        PhosphorIcons.gear(),
                        color: const Color(0xFF111318),
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 80,
                      color: Color(0xFF60708A),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Profile features coming soon',
                      style: TextStyle(
                        color: Color(0xFF60708A),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
