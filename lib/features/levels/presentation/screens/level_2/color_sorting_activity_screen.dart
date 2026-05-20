import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorSortingActivityScreen extends StatefulWidget {
  const ColorSortingActivityScreen({super.key});

  @override
  State<ColorSortingActivityScreen> createState() => _ColorSortingActivityScreenState();
}

class _ColorSortingActivityScreenState extends State<ColorSortingActivityScreen> {
  final List<Map<String, dynamic>> _draggables = [
    {'id': 'apple', 'image': 'assets/images/level2/apple.png', 'color': 'red'},
    {'id': 'banana', 'image': 'assets/images/level2/banana.png', 'color': 'yellow'},
    {'id': 'ball', 'image': 'assets/images/level2/ball.png', 'color': 'yellow'},
    {'id': 'car', 'image': 'assets/images/level2/car.png', 'color': 'red'},
  ];

  final Map<String, List<String>> _sorted = {
    'red': [],
    'yellow': [],
  };

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

  void _checkCompletion() {
    int totalSorted = _sorted['red']!.length + _sorted['yellow']!.length;
    if (totalSorted == _draggables.length) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('رائع جداً!', style: _cairo(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF4CAF50)), textAlign: TextAlign.center),
          content: Text('لقد أكملت جميع أنشطة المستوى الثاني بنجاح.', style: _cairo(fontSize: 16), textAlign: TextAlign.center),
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
                  Navigator.pop(context); // close ColorSortingActivityScreen
                  // It will return to wherever it came from, maybe we should popUntil the LevelsScreen.
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('العودة للقائمة', style: _cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                height: 64,
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
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
                      onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(Icons.close, color: Color(0xFF475569)),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    children: [
                      Text('ضع كل عنصر في اللون الصحيح', style: _cairo(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF191C21))),
                      const SizedBox(height: 24),
                      
                      // Target Zones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildTargetZone('red', 'أحمر', const Color(0xFFFF6B6B)),
                          _buildTargetZone('yellow', 'أصفر', const Color(0xFFFFD54F)),
                        ],
                      ),
                      
                      const Spacer(),
                      
                      // Draggables Grid
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FF),
                          border: Border.all(color: const Color(0xFFC1C7D3)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: _draggables.map((item) {
                            bool isSorted = _sorted['red']!.contains(item['id']) || _sorted['yellow']!.contains(item['id']);
                            if (isSorted) {
                              return const SizedBox(width: 80, height: 80);
                            }
                            return Draggable<Map<String, dynamic>>(
                              data: item,
                              feedback: Material(
                                color: Colors.transparent,
                                child: _buildDraggableItem(item),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: _buildDraggableItem(item),
                              ),
                              child: _buildDraggableItem(item),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTargetZone(String expectedColor, String label, Color color) {
    return DragTarget<Map<String, dynamic>>(
      onWillAcceptWithDetails: (details) => details.data['color'] == expectedColor,
      onAcceptWithDetails: (details) {
        setState(() {
          _sorted[expectedColor]!.add(details.data['id']);
        });
        _checkCompletion();
      },
      builder: (context, candidateData, rejectedData) {
        bool hasCandidate = candidateData.isNotEmpty;
        return Container(
          width: 140,
          height: 160,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F3FB),
            border: Border.all(
              color: hasCandidate ? const Color(0xFF4CAF50) : color,
              width: hasCandidate ? 6 : 4,
              style: BorderStyle.solid, // Figma had dashed but Flutter standard is solid unless custom painter
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                top: -16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Text(label, style: _cairo(fontSize: 16, fontWeight: FontWeight.bold, color: expectedColor == 'yellow' ? const Color(0xFF291800) : Colors.white)),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(Icons.shopping_basket_outlined, size: 40, color: color),
                ),
              ),
              if (_sorted[expectedColor]!.isNotEmpty)
                Positioned(
                  bottom: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: _sorted[expectedColor]!.map((id) {
                      var item = _draggables.firstWhere((e) => e['id'] == id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Image.asset(item['image'], width: 30, height: 30, fit: BoxFit.contain),
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableItem(Map<String, dynamic> item) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6E8EF), width: 2),
      ),
      padding: const EdgeInsets.all(4),
      child: Image.asset(item['image'], fit: BoxFit.contain),
    );
  }
}
