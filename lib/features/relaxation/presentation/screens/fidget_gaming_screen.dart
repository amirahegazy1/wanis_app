import 'package:flutter/material.dart';

class FidgetGamingScreen extends StatefulWidget {
  const FidgetGamingScreen({super.key});

  @override
  State<FidgetGamingScreen> createState() => _FidgetGamingScreenState();
}

class _FidgetGamingScreenState extends State<FidgetGamingScreen> {
  // Simple 4x5 grid for bubbles
  final int rows = 5;
  final int cols = 4;
  late List<bool> _poppedBubbles;

  @override
  void initState() {
    super.initState();
    _poppedBubbles = List.filled(rows * cols, false);
  }

  void _popBubble(int index) {
    if (!_poppedBubbles[index]) {
      setState(() {
        _poppedBubbles[index] = true;
      });
      // Optionally trigger haptic feedback here (using flutter/services or a sound)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF2D3748), size: 20),
                    ),
                  ),
                  const Text(
                    'فقع الفقاعات',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22543D),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for centering
                ],
              ),
              const SizedBox(height: 64),
              
              // Bubble Wrap Grid
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFED7E2).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: rows * cols,
                      itemBuilder: (context, index) {
                        final isPopped = _poppedBubbles[index];
                        return GestureDetector(
                          onTap: () => _popBubble(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isPopped ? const Color(0xFFFCC2D7) : const Color(0xFFF687B3),
                              boxShadow: isPopped ? [] : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                )
                              ],
                              border: Border.all(
                                color: isPopped ? const Color(0xFFF687B3) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: isPopped
                              ? null // Empty if popped
                              : Center(
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                'اضغط على الفقاعات لتسمع "بوب"!',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF718096),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
