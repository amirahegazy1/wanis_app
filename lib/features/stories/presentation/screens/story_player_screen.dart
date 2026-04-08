import 'package:flutter/material.dart';

class StoryPlayerScreen extends StatelessWidget {
  const StoryPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const SizedBox(height: 16),
            Flexible(
              flex: 5,
              child: _buildStoryIllustration(),
            ),
            const SizedBox(height: 24),
            _buildStoryText(),
            const Spacer(),
            _buildPlaybackControls(),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nav Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Progress Bar
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  value: 0.3, // Example progress
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D9CEC)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryIllustration() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              '🧸 🛋️ 🚪',
              style: TextStyle(fontSize: 60),
            ),
            Positioned(
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'غرفة عمر',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: const [
          Text(
            'عمر يبحث عن لعبته...',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'لقد بحث في كل مكان، لكنه لم يجدها.',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFFA0AEC0),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Replay/Previous Button
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.replay_10_rounded),
          color: const Color(0xFFA0AEC0),
          iconSize: 32,
        ),
        
        const SizedBox(width: 24),
        
        // Play/Pause Main Button
        Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: Color(0xFF5D9CEC),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x335D9CEC),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.pause_rounded),
            color: Colors.white,
            iconSize: 32,
          ),
        ),
        
        const SizedBox(width: 24),
        
        // Forward Button
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.forward_10_rounded),
          color: const Color(0xFFA0AEC0),
          iconSize: 32,
        ),
      ],
    );
  }
}
