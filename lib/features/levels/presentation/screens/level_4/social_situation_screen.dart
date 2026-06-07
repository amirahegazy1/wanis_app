import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/feedback_dialogs.dart';
import '../../../domain/models/level4_task.dart';

class SocialSituationScreen extends StatefulWidget {
  final Level4Task task;
  final VoidCallback onTaskCompleted;

  const SocialSituationScreen({
    super.key,
    required this.task,
    required this.onTaskCompleted,
  });

  @override
  State<SocialSituationScreen> createState() => _SocialSituationScreenState();
}

class _SocialSituationScreenState extends State<SocialSituationScreen> {
  String? _selectedOptionId;

  TextStyle _cairo({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w400,
    Color color = Colors.black,
  }) {
    return GoogleFonts.cairo(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  void _onOptionSelected(Level4Option option) {
    setState(() {
      _selectedOptionId = option.id;
    });

    if (option.isCorrect) {
      _showSuccessDialog(context, 'لقد اخترت التصرف الصحيح واللطيف! أحسنت صنعاً يا بطل 🌟');
    } else {
      _showErrorDialog(context, 'هذا التصرف غير مناسب في هذا الموقف. دعنا نفكر في خيار أفضل! 💪');
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    FeedbackDialogs.showSuccess(
      context: context,
      title: 'أحسنت يا بطل! 🌟',
      message: message,
      buttonText: 'التالي',
      onPressed: () {
        widget.onTaskCompleted(); // trigger complete sequence
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    FeedbackDialogs.showError(
      context: context,
      title: 'لا بأس يا بطل!',
      message: message,
      buttonText: 'حاول مرة أخرى',
      onPressed: () {},
    );
  }

  // A helper to display an image if it exists, otherwise fall back to a colored container with an emoji
  Widget _buildImageWithFallback(String path, Color placeholderColor, String emoji, {double? width, double? height, BoxFit fit = BoxFit.cover}) {
    return Container(
      width: width,
      height: height,
      color: placeholderColor,
      child: Image.asset(
        path,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Text(
              emoji,
              style: TextStyle(fontSize: (height ?? 100) * 0.4),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F0FF), // Premium soft lavender/purple background
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Standardized Premium Header
              Container(
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.04),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'ونيس',
                      style: _cairo(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF4A90E2)),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.close, color: Color(0xFF475569)),
                      ),
                    ),
                  ],
                ),
              ),

              // Standardized Main Canvas Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        children: [
                          // Level Badge & Title
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C63FF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(99),
                              border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.2)),
                            ),
                            child: Text(
                              'المستوى ٤',
                              style: _cairo(fontSize: 14, fontWeight: FontWeight.w700, color: const Color(0xFF6C63FF)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F3FF),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.15), width: 1.5),
                            ),
                            child: Text(
                              widget.task.question,
                              style: _cairo(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Target Scenario Image Card
                          Container(
                            width: double.infinity,
                            height: 260,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white, width: 6),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF6C63FF).withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 6),
                                )
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: _buildImageWithFallback(
                              widget.task.scenarioImagePath,
                              widget.task.scenarioPlaceholderColor,
                              widget.task.scenarioPlaceholderEmoji,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Options Container
                          Column(
                            children: widget.task.options.map((option) {
                              final isSelected = _selectedOptionId == option.id;
                              return GestureDetector(
                                onTap: () => _onOptionSelected(option),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFF0FDF4) : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFE2E8F0),
                                      width: isSelected ? 2.5 : 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isSelected 
                                            ? const Color(0xFF4CAF50).withOpacity(0.1) 
                                            : Colors.black.withOpacity(0.03),
                                        blurRadius: isSelected ? 12 : 6,
                                        offset: const Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                if (isSelected)
                                                  const Padding(
                                                    padding: EdgeInsets.only(left: 8.0),
                                                    child: Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                                                  ),
                                                Text(
                                                  option.title, 
                                                  style: _cairo(
                                                    fontSize: 18, 
                                                    fontWeight: FontWeight.bold, 
                                                    color: isSelected ? const Color(0xFF2E7D32) : const Color(0xFF0F172A),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              option.subtitle, 
                                              style: _cairo(
                                                fontSize: 14, 
                                                color: isSelected ? const Color(0xFF4C7F53) : const Color(0xFF64748B),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Option Image
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isSelected ? const Color(0xFF4CAF50).withOpacity(0.3) : const Color(0xFFECEDF5),
                                            width: 1.5,
                                          ),
                                        ),
                                        clipBehavior: Clip.antiAlias,
                                        child: _buildImageWithFallback(
                                          option.imagePath,
                                          option.placeholderColor,
                                          option.placeholderEmoji,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
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
