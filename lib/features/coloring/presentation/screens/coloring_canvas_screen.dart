import 'package:flutter/material.dart';

import '../widgets/coloring_success_dialog.dart';

class ColoringCanvasScreen extends StatefulWidget {
  final String shapeName;
  final String shapeEmoji;

  const ColoringCanvasScreen({
    super.key,
    required this.shapeName,
    required this.shapeEmoji,
  });

  @override
  State<ColoringCanvasScreen> createState() => _ColoringCanvasScreenState();
}

class _ColoringCanvasScreenState extends State<ColoringCanvasScreen> {
  // Mock colors for palette
  final List<Color> _paletteColors = [
    const Color(0xFFFF8A8A), // Red/Pink
    const Color(0xFF5D9CEC), // Blue
    const Color(0xFF48BB78), // Green
    const Color(0xFFF4A261), // Orange
    const Color(0xFFB83280), // Purple/Magenta
  ];

  int _selectedColorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0), // Creamy background
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            Expanded(
              child: _buildCanvas(),
            ),
            _buildColorPalette(),
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
                'وقت التلوين',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(width: 8),
              Text('🎨', style: TextStyle(fontSize: 24)),
            ],
          ),
          // Actions: Undo & Check
          Row(
            children: [
              // Undo Button
              GestureDetector(
                onTap: () {
                  // Mock Undo Action
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Icon(Icons.undo, color: Color(0xFF2D3748), size: 20),
                ),
              ),
              const SizedBox(width: 8),
              // Check/Save Button
              GestureDetector(
                onTap: () {
                  _showSuccessDialog(context);
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF48BB78), // Green
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCanvas() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFFFECCC), width: 2), // Light orange outer border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          // For now, we simulate the shape to color using an emoji layout 
          // (As actual SVG/Image canvas coloring involves custom painters or SVG manipulation library)
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.shapeEmoji,
                style: const TextStyle(fontSize: 160),
              ),
              const SizedBox(height: 16),
              Text(
                widget.shapeName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE2E8F0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColorPalette() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 40, left: 24, right: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'اختر لوناً',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              SizedBox(width: 8),
              Text('🎨', style: TextStyle(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _paletteColors.length,
              (index) => _buildColorItem(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorItem(int index) {
    final isSelected = _selectedColorIndex == index;
    final color = _paletteColors[index];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColorIndex = index;
        });
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: const Color(0xFF2D3748), width: 4)
              : null,
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: isSelected
            ? const Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xFF2D3748),
                    child: Icon(Icons.check, color: Colors.white, size: 14),
                  ),
                ),
              )
            : null,
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const ColoringSuccessDialog();
      },
    );
  }
}
