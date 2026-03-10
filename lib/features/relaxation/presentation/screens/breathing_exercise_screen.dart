import 'package:flutter/material.dart';

import '../widgets/breathing_success_dialog.dart';

class BreathingExerciseScreen extends StatefulWidget {
  const BreathingExerciseScreen({super.key});

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  bool _isInhaling = true;
  int _currentCycle = 1;
  final int _totalCycles = 5;

  @override
  void initState() {
    super.initState();
    // 4 seconds inhale, 4 seconds exhale roughly
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Finished inhaling
        setState(() {
          _isInhaling = false;
        });
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Finished exhaling
        setState(() {
          if (_currentCycle < _totalCycles) {
            _currentCycle++;
            _isInhaling = true;
            _controller.forward();
          } else {
            // Finished all cycles
            _showSuccessDialog();
          }
        });
      }
    });

    // Start the breathing exercise
    _controller.forward();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const BreathingSuccessDialog(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                    'تنفس بعمق...',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C7A7B),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for centering
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Breathing Circle Animation
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer decorative dashed rings could be add here if assets exist
                        Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE6FFFA), width: 2),
                          ),
                        ),
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFB2F5EA).withValues(alpha: 0.5), width: 2),
                          ),
                        ),
                        // The animated central circle
                        AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFB2F5EA),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          },
                        ),
                        // Text inside the circle
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isInhaling ? 'شهيق' : 'زفير',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF285E61),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isInhaling ? 'املأ صدرك بالهواء' : 'أخرج الهواء ببطء',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF2C7A7B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 64),
                    // Cycle Counter
                    Text(
                      'الدورة $_currentCycle من $_totalCycles',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2C7A7B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Progress dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_totalCycles, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index < _currentCycle ? const Color(0xFF319795) : const Color(0xFFE2E8F0),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 48),
                    const Text(
                      'تابع الدائرة وهي تكبر وتصغر',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
