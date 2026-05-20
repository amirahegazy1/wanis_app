import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('أحسنت!', style: _cairo(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF4CAF50)), textAlign: TextAlign.center),
          content: Text('لقد اخترت التصرف الصحيح!', style: _cairo(fontSize: 16), textAlign: TextAlign.center),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  widget.onTaskCompleted(); // move to next
                },
                child: Text('التالي', style: _cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('إجابة غير صحيحة، حاول مرة أخرى!', style: _cairo(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
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
        backgroundColor: const Color(0xFF717783), // Background color from Figma
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Container(
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
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

              // Main Canvas
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: Column(
                        children: [
                          // Level Badge & Title
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2976C7),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text('المستوى ٤', style: _cairo(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F3FB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF2976C7).withOpacity(0.2), width: 2),
                            ),
                            child: Text(
                              widget.task.question,
                              style: _cairo(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF191C21)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Target Scenario Image
                          Container(
                            width: double.infinity,
                            height: 280,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))
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
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFFECEDF5),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(option.title, style: _cairo(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF005DA7))),
                                            const SizedBox(height: 4),
                                            Text(option.subtitle, style: _cairo(fontSize: 14, color: const Color(0xFF414751))),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      // Option Image
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: const Color(0xFFECEDF5)),
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
