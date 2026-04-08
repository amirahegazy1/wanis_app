import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class FidgetGamingScreen extends StatefulWidget {
  const FidgetGamingScreen({super.key});

  @override
  State<FidgetGamingScreen> createState() => _FidgetGamingScreenState();
}

class _FidgetGamingScreenState extends State<FidgetGamingScreen> {
  final int rows = 5;
  final int cols = 4;
  late List<bool> _poppedBubbles;

  final AudioPlayer _popPlayer = AudioPlayer();
  final AudioPlayer _resetPlayer = AudioPlayer();
  bool _audioReady = false;

  @override
  void initState() {
    super.initState();
    _poppedBubbles = List.filled(rows * cols, false);
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await Future.wait([
        _popPlayer.setAsset('assets/sounds/pop.wav'),
        _resetPlayer.setAsset('assets/sounds/reset.wav'),
      ]);
      _audioReady = true;
    } catch (_) {
      // Audio is optional — gracefully degrade
    }
  }

  Future<void> _playPop() async {
    if (!_audioReady) return;
    try {
      await _popPlayer.seek(Duration.zero);
      _popPlayer.play();
    } catch (_) {}
  }

  Future<void> _playReset() async {
    if (!_audioReady) return;
    try {
      await _resetPlayer.seek(Duration.zero);
      _resetPlayer.play();
    } catch (_) {}
  }

  void _popBubble(int index) {
    if (!_poppedBubbles[index]) {
      setState(() {
        _poppedBubbles[index] = true;
      });
      HapticFeedback.lightImpact();
      _playPop();
    }
  }

  void _resetBubbles() {
    setState(() {
      _poppedBubbles = List.filled(rows * cols, false);
    });
    HapticFeedback.mediumImpact();
    _playReset();
  }

  bool get _allPopped => _poppedBubbles.every((b) => b);

  @override
  void dispose() {
    _popPlayer.dispose();
    _resetPlayer.dispose();
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
                  const SizedBox(width: 48),
                ],
              ),
              const SizedBox(height: 24),

              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: cols / rows,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFED7E2).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: rows * cols,
                        itemBuilder: (context, index) {
                          final isPopped = _poppedBubbles[index];
                          return GestureDetector(
                            onTap: () => _popBubble(index),
                            child: AnimatedScale(
                              scale: isPopped ? 0.85 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isPopped ? const Color(0xFFFCC2D7) : const Color(0xFFF687B3),
                                  boxShadow: isPopped
                                      ? []
                                      : [
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
                                    ? null
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                _allPopped ? 'أحسنت! فقعت كل الفقاعات 🎉' : 'اضغط على الفقاعات لتسمع "بوب"!',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF718096),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (_allPopped)
                Center(
                  child: GestureDetector(
                    onTap: _resetBubbles,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFED7E2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        'إعادة 🔄',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB83280),
                        ),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: _allPopped ? 24 : 48),
            ],
          ),
        ),
      ),
    );
  }
}
