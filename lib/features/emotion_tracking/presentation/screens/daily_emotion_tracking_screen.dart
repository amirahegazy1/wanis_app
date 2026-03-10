import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/daily_emotion_success_dialog.dart';

class DailyEmotionTrackingScreen extends StatefulWidget {
  const DailyEmotionTrackingScreen({super.key});

  @override
  State<DailyEmotionTrackingScreen> createState() => _DailyEmotionTrackingScreenState();
}

class _DailyEmotionTrackingScreenState extends State<DailyEmotionTrackingScreen> {
  // Store the selected emotion index. null means none selected.
  int? _selectedEmotionIndex;

  final List<Map<String, String>> _emotions = [
    {'emoji': '😄', 'label': 'سعيد'},
    {'emoji': '😌', 'label': 'هادئ'},
    {'emoji': '😢', 'label': 'حزين'},
    {'emoji': '😡', 'label': 'غاضب'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back Button (Frame 352 in Figma)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(38),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF2D3748)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Titles
                Text(
                  'كيف تشعر اليوم يا زين؟',
                  style: GoogleFonts.readexPro(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'اضغط على الوجه الذي يشبهك',
                  style: GoogleFonts.readexPro(
                    fontSize: 16,
                    color: const Color(0xFFA0AEC0),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Emotions Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _emotions.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final emotion = _emotions[index];
                    final isSelected = _selectedEmotionIndex == index;
                    
                    return GestureDetector(
                      onTap: () {
                        setState(() { _selectedEmotionIndex = index; });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : const Color(0xFFF7FAFC),
                              shape: BoxShape.circle,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      )
                                    ]
                                  : null,
                              border: isSelected
                                  ? Border.all(color: const Color(0xFF5D9CEC), width: 2)
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              emotion['emoji']!,
                              style: const TextStyle(fontSize: 60),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            emotion['label']!,
                            style: GoogleFonts.readexPro(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D3748),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 60),

                // Submit Button
                Opacity(
                  opacity: _selectedEmotionIndex != null ? 1.0 : 0.5,
                  child: InkWell(
                    onTap: _selectedEmotionIndex != null
                        ? () {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) => const DailyEmotionSuccessDialog(),
                            );
                          }
                        : null,
                    borderRadius: BorderRadius.circular(44),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5D9CEC),
                        borderRadius: BorderRadius.circular(44),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تسجيل شعوري',
                            style: GoogleFonts.readexPro(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '✅',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
