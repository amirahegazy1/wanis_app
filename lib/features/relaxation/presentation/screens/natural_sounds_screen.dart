import 'package:flutter/material.dart';

class NaturalSoundsScreen extends StatefulWidget {
  const NaturalSoundsScreen({super.key});

  @override
  State<NaturalSoundsScreen> createState() => _NaturalSoundsScreenState();
}

class _NaturalSoundsScreenState extends State<NaturalSoundsScreen> {
  String? _playingSoundId;

  void _togglePlay(String id) {
    setState(() {
      if (_playingSoundId == id) {
        _playingSoundId = null;
      } else {
        _playingSoundId = id;
      }
    });
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
                    'أصوات الطبيعة 🎧',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF22543D),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildSoundCard(
                id: 'rain',
                title: 'صوت المطر',
                subtitle: 'للاسترخاء والنوم',
                emoji: '🌧️',
                iconBgColor: const Color(0xFFE6FFFA),
              ),
              const SizedBox(height: 16),
              _buildSoundCard(
                id: 'forest',
                title: 'غابة هادئة',
                subtitle: 'زقزقة عصافير',
                emoji: '🌲',
                iconBgColor: const Color(0xFFF0FFF4),
              ),
              const SizedBox(height: 16),
              _buildSoundCard(
                id: 'sea',
                title: 'أمواج البحر',
                subtitle: 'صوت الأمواج',
                emoji: '🌊',
                iconBgColor: const Color(0xFFEBF8FF),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoundCard({
    required String id,
    required String title,
    required String subtitle,
    required String emoji,
    required Color iconBgColor,
  }) {
    final isPlaying = _playingSoundId == id;

    return GestureDetector(
      onTap: () => _togglePlay(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPlaying ? const Color(0xFF319795) : const Color(0xFFE2E8F0),
            width: isPlaying ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isPlaying ? const Color(0xFF319795) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isPlaying ? Colors.transparent : const Color(0xFFE2E8F0),
                ),
              ),
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: isPlaying ? Colors.white : const Color(0xFF2D3748),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFA0AEC0),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
