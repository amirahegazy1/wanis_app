import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../services/firestore_service.dart';
import '../../../../models/child_profile.dart';
import '../../../levels/presentation/screens/levels_screen.dart';
import '../../models/survey_question.dart';
import '../widgets/survey_option_button.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Stores the selected option index (0 to 3) for each question id
  final Map<int, int> _answers = {};

  final List<String> _options = [
    'دائماً',
    'أحياناً',
    'نادراً',
    'أبداً',
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextQuestion() {
    if (_currentIndex < surveyQuestions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitSurvey();
    }
  }

  Future<void> _submitSurvey() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestoreService = FirestoreService();
        
        final surveyData = _answers.map((key, value) => MapEntry('q${key + 1}', value));
        
        // Try to update the existing child profile created during onboarding.
        final existingChildren = await firestoreService.getChildProfiles(user.uid);
        
        if (existingChildren.isNotEmpty) {
          final child = existingChildren.first;
          final updatedChild = ChildProfile(
            id: child.id,
            name: child.name,
            age: child.age,
            avatarUrl: child.avatarUrl,
            surveyResponses: surveyData,
          );
          await firestoreService.updateChildProfile(user.uid, updatedChild);
        } else {
          // Fallback: create a new child profile if none exists
          final newChild = ChildProfile(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            name: '\u0637\u0641\u0644\u064a',
            age: 4,
            avatarUrl: '1',
            surveyResponses: surveyData,
          );
          await firestoreService.addChildProfile(user.uid, newChild);
        }
        
        await firestoreService.markSurveyCompleted(user.uid);
      }
    } catch (e) {
      debugPrint('Error saving survey: $e');
    }

    if (mounted) {
      Navigator.of(context).pop(); // pop loading dialog
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const LevelsScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = surveyQuestions[_currentIndex];
    final progress = (_currentIndex + 1) / surveyQuestions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _currentIndex > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              )
            : null,
        actions: [
          TextButton(
            onPressed: _submitSurvey,
            child: Text(
              'تخطي',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'السؤال ${_currentIndex + 1} من ${surveyQuestions.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            
            // Question PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe to force button use
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: surveyQuestions.length,
                itemBuilder: (context, index) {
                  final q = surveyQuestions[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Illustration Placeholder
                        Expanded(
                          flex: 3,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 24.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.child_care, // Placeholder icon
                                size: 80,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        
                        // Question Heading
                        Text(
                          q.questionText,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        
                        // Options
                        ...List.generate(_options.length, (optionIndex) {
                          return SurveyOptionButton(
                            label: _options[optionIndex],
                            isSelected: _answers[q.id] == optionIndex,
                            onTap: () {
                              setState(() {
                                _answers[q.id] = optionIndex;
                              });
                            },
                          );
                        }),
                        
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Action Area
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _answers.containsKey(question.id) ? _nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentIndex == surveyQuestions.length - 1 ? 'إنهاء' : 'التالي',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
