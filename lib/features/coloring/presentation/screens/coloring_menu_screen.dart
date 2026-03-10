import 'package:flutter/material.dart';

import 'coloring_canvas_screen.dart';

class ColoringMenuScreen extends StatelessWidget {
  const ColoringMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0), // Creamy background
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 32),
            Expanded(
              child: _buildGrid(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back Button
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
              child: const Icon(Icons.arrow_back, color: Color(0xFF2D3748)),
            ),
          ),
          // Title
          const Row(
            children: [
              Text(
                'معرض التلوين',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(width: 8),
              Text('🖌️', style: TextStyle(fontSize: 24)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85, // Adjusted to match Figma design
        children: [
          _buildItemCard(
            context,
            title: 'السمكة',
            emoji: '🐠',
            playButtonColor: const Color(0xFF5D9CEC), // Blue
            onTap: () => _navigateToCanvas(context, 'السمكة', '🐠'),
          ),
          _buildItemCard(
            context,
            title: 'الزهرة',
            emoji: '🌸',
            playButtonColor: const Color(0xFF48BB78), // Green
            onTap: () => _navigateToCanvas(context, 'الزهرة', '🌸'),
          ),
          _buildItemCard(
            context,
            title: 'الفراشة',
            emoji: '🦋',
            playButtonColor: const Color(0xFFFC8181), // Red/Pink
            onTap: () => _navigateToCanvas(context, 'الفراشة', '🦋'),
          ),
          _buildLockedCard(),
        ],
      ),
    );
  }

  Widget _buildItemCard(
    BuildContext context, {
    required String title,
    required String emoji,
    required Color playButtonColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF5EB), // Light orange/peach behind icon
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 8),
            Icon(
              Icons.play_circle_fill,
              color: playButtonColor,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockedCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC), // Light gray background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
          style: BorderStyle.none,
        ),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(color: const Color(0xFFE2E8F0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '🔒',
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 16),
            Text(
              'قريباً...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFA0AEC0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCanvas(BuildContext context, String shapeName, String emoji) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ColoringCanvasScreen(
          shapeName: shapeName,
          shapeEmoji: emoji,
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;

  DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 8;
    const double dashSpace = 6;
    double startX = 0;
    
    // Top border
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    double startY = 0;
    // Right border
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width, startY),
        Offset(size.width, startY + dashWidth),
        paint,
      );
      startY += dashWidth + dashSpace;
    }

    startX = size.width;
    // Bottom border
    while (startX > 0) {
      canvas.drawLine(
        Offset(startX, size.height),
        Offset(startX - dashWidth, size.height),
        paint,
      );
      startX -= dashWidth + dashSpace;
    }

    startY = size.height;
    // Left border
    while (startY > 0) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY - dashWidth),
        paint,
      );
      startY -= dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
