import 'package:flutter/material.dart';

import '../widgets/coloring_success_dialog.dart';

class _Stroke {
  final Color color;
  final double width;
  final List<Offset> points = [];

  _Stroke({required this.color, required this.width});
}

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
  final List<Color> _paletteColors = [
    const Color(0xFFFF8A8A),
    const Color(0xFF5D9CEC),
    const Color(0xFF48BB78),
    const Color(0xFFF4A261),
    const Color(0xFFB83280),
  ];

  int _selectedColorIndex = 0;

  final List<double> _brushSizes = [3.0, 6.0, 12.0];
  int _selectedBrushIndex = 1;

  final List<_Stroke> _strokes = [];
  _Stroke? _currentStroke;

  final ValueNotifier<int> _paintGeneration = ValueNotifier(0);

  void _onPanStart(DragStartDetails details) {
    final stroke = _Stroke(
      color: _paletteColors[_selectedColorIndex],
      width: _brushSizes[_selectedBrushIndex],
    );
    stroke.points.add(details.localPosition);
    _currentStroke = stroke;
    _strokes.add(stroke);
    _paintGeneration.value++;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final stroke = _currentStroke;
    if (stroke == null) return;
    stroke.points.add(details.localPosition);
    _paintGeneration.value++;
  }

  void _onPanEnd(DragEndDetails details) {
    _currentStroke = null;
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    _strokes.removeLast();
    _paintGeneration.value++;
  }

  void _clear() {
    if (_strokes.isEmpty) return;
    _strokes.clear();
    _paintGeneration.value++;
  }

  void _goBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _paintGeneration.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFFFECCC), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Center(
                        child: Opacity(
                          opacity: 0.15,
                          child: Text(
                            widget.shapeEmoji,
                            style: const TextStyle(fontSize: 160),
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: GestureDetector(
                          onPanStart: _onPanStart,
                          onPanUpdate: _onPanUpdate,
                          onPanEnd: _onPanEnd,
                          child: RepaintBoundary(
                            child: CustomPaint(
                              painter: _DrawingPainter(
                                strokes: _strokes,
                                repaintNotifier: _paintGeneration,
                              ),
                              size: Size.infinite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildColorPalette(bottomPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildCircleButton(
            onTap: _goBack,
            child: const Icon(Icons.arrow_back, color: Color(0xFF2D3748), size: 20),
          ),
          const Spacer(),
          const Text(
            'وقت التلوين 🎨',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const Spacer(),
          _buildCircleButton(
            onTap: _clear,
            child: const Icon(Icons.delete_outline, color: Color(0xFF2D3748), size: 20),
          ),
          const SizedBox(width: 8),
          _buildCircleButton(
            onTap: _undo,
            child: const Icon(Icons.undo, color: Color(0xFF2D3748), size: 20),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _showSuccessDialog(context),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF48BB78),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildColorPalette(double bottomPadding) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 16, bottom: bottomPadding + 16, left: 24, right: 24),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_brushSizes.length, (index) {
              final isSelected = _selectedBrushIndex == index;
              final dotDiameter = _brushSizes[index] + 6;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedBrushIndex = index;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: dotDiameter,
                      height: dotDiameter,
                      decoration: BoxDecoration(
                        color: _paletteColors[_selectedColorIndex],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: const Color(0xFF2D3748), width: 3)
              : null,
          boxShadow: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 22)
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

class _DrawingPainter extends CustomPainter {
  final List<_Stroke> strokes;

  _DrawingPainter({
    required this.strokes,
    required ValueNotifier<int> repaintNotifier,
  }) : super(repaint: repaintNotifier);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Offset.zero & size);

    for (final stroke in strokes) {
      final points = stroke.points;
      if (points.isEmpty) continue;

      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..isAntiAlias = true;

      if (points.length == 1) {
        canvas.drawCircle(
          points.first,
          stroke.width / 2,
          paint..style = PaintingStyle.fill,
        );
        continue;
      }

      final path = Path()..moveTo(points[0].dx, points[0].dy);

      if (points.length == 2) {
        path.lineTo(points[1].dx, points[1].dy);
      } else {
        for (int i = 1; i < points.length - 1; i++) {
          final mid = Offset(
            (points[i].dx + points[i + 1].dx) / 2,
            (points[i].dy + points[i + 1].dy) / 2,
          );
          path.quadraticBezierTo(points[i].dx, points[i].dy, mid.dx, mid.dy);
        }
        path.lineTo(points.last.dx, points.last.dy);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_DrawingPainter oldDelegate) => false;
}
