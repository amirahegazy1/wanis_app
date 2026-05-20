import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_sorting_activity_screen.dart';

class MatchingActivityScreen extends StatefulWidget {
  const MatchingActivityScreen({super.key});

  @override
  State<MatchingActivityScreen> createState() => _MatchingActivityScreenState();
}

class _MatchingActivityScreenState extends State<MatchingActivityScreen> {
  final List<Map<String, dynamic>> _targets = [
    {'id': 'apple', 'image': 'assets/images/level2/apple.png', 'color': const Color(0xFFE1E2E9)},
    {'id': 'banana', 'image': 'assets/images/level2/banana.png', 'color': const Color(0xFF4CAF50)},
    {'id': 'grapes', 'image': 'assets/images/level2/grapes.png', 'color': const Color(0xFFE1E2E9)},
  ];

  final List<Map<String, dynamic>> _draggables = [
    {'id': 'banana', 'image': 'assets/images/level2/banana.png'},
    {'id': 'grapes', 'image': 'assets/images/level2/grapes.png'},
    {'id': 'apple', 'image': 'assets/images/level2/apple.png'},
  ];

  final Map<String, bool> _matched = {
    'apple': false,
    'banana': false,
    'grapes': false,
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
    if (_matched.values.every((v) => v)) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('عمل رائع!', style: _cairo(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF4CAF50)), textAlign: TextAlign.center),
          content: Text('لقد قمت بمطابقة جميع العناصر بنجاح.', style: _cairo(fontSize: 16), textAlign: TextAlign.center),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ColorSortingActivityScreen()),
                  );
                },
                child: Text('التالي', style: _cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
                      onTap: () => Navigator.pop(context),
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
                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2976C7),
                          borderRadius: BorderRadius.circular(9999),
                        ),
                        child: Text('المستوى 2', style: _cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      const SizedBox(height: 24),
                      Text('طابق العناصر المتشابهة', style: _cairo(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF333333))),
                      const SizedBox(height: 8),
                      Text('اسحب الصورة إلى مكانها الصحيح', style: _cairo(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF005DA7))),
                      const SizedBox(height: 32),
                      
                      // Targets
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _targets.map((target) {
                          bool isMatched = _matched[target['id']] ?? false;
                          return DragTarget<String>(
                            onWillAcceptWithDetails: (details) => details.data == target['id'] && !isMatched,
                            onAcceptWithDetails: (details) {
                              setState(() {
                                _matched[target['id']] = true;
                              });
                              _checkCompletion();
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: isMatched || candidateData.isNotEmpty ? const Color(0xFF4CAF50) : const Color(0xFFE1E2E9),
                                    width: 4,
                                  ),
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))
                                  ],
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    Opacity(
                                      opacity: isMatched ? 1.0 : 0.3,
                                      child: Image.asset(target['image'], fit: BoxFit.contain),
                                    ),
                                    if (isMatched)
                                      Positioned(
                                        top: -8,
                                        right: -8,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            color: Color(0xFF4CAF50),
                                            shape: BoxShape.circle,
                                          ),
                                          padding: const EdgeInsets.all(4),
                                          child: const Icon(Icons.check, color: Colors.white, size: 16),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      // Draggables
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _draggables.map((item) {
                          bool isMatched = _matched[item['id']] ?? false;
                          if (isMatched) {
                            return const SizedBox(width: 100, height: 100);
                          }
                          return Draggable<String>(
                            data: item['id'],
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

  Widget _buildDraggableItem(Map<String, dynamic> item) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(color: Color(0xFFD4E3FF), blurRadius: 0, offset: Offset(0, 8))
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Image.asset(item['image'], fit: BoxFit.contain),
    );
  }
}
