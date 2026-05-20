import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'matching_activity_screen.dart';

class ToolUsageActivityScreen extends StatefulWidget {
  const ToolUsageActivityScreen({super.key});

  @override
  State<ToolUsageActivityScreen> createState() => _ToolUsageActivityScreenState();
}

class _ToolUsageActivityScreenState extends State<ToolUsageActivityScreen> {
  // Items available to drag
  final List<Map<String, dynamic>> _items = [
    {'id': 'teddy_bear', 'image': 'assets/images/level2/teddy_bear.png', 'name': 'دب لعبة', 'color': const Color(0xFFFFDDB4)},
    {'id': 'apple', 'image': 'assets/images/level2/apple.png', 'name': 'تفاحة', 'color': const Color(0xFFFEF2F2)},
    {'id': 'toothbrush', 'image': 'assets/images/level2/toothbrush.png', 'name': 'فرشاة أسنان', 'color': const Color(0xFFEFF6FF)},
  ];

  String? _droppedItemId;
  bool _isSuccess = false;

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

  void _onDropComplete() {
    setState(() {
      _isSuccess = true;
    });
    // Show success dialog and navigate to next
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('أحسنت!', style: _cairo(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF4CAF50)), textAlign: TextAlign.center),
        content: Text('لقد اخترت الأداة الصحيحة!', style: _cairo(fontSize: 16), textAlign: TextAlign.center),
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MatchingActivityScreen()),
                );
              },
              child: Text('التالي', style: _cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF717783),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Header
              Container(
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
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
              // Main Canvas
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      Text('اسحب الأداة الصحيحة', style: _cairo(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF005DA7))),
                      const SizedBox(height: 8),
                      Text('المستوى الثاني', style: _cairo(fontSize: 14, color: const Color(0xFF777777))),
                      const SizedBox(height: 24),
                      
                      // Target Area
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFF2976C7), width: 2, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                              ],
                            ),
                            child: DragTarget<String>(
                              onWillAcceptWithDetails: (details) => details.data == 'toothbrush',
                              onAcceptWithDetails: (details) {
                                setState(() {
                                  _droppedItemId = details.data;
                                });
                                _onDropComplete();
                              },
                              builder: (context, candidateData, rejectedData) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: candidateData.isNotEmpty ? const Color(0xFF4CAF50) : const Color(0xFF2976C7).withOpacity(0.5),
                                      width: candidateData.isNotEmpty ? 4 : 2,
                                    ),
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // The teeth image as the target
                                      Opacity(
                                        opacity: _droppedItemId != null ? 0.5 : 1.0,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(38),
                                          child: Image.asset('assets/images/level2/teeth.png', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                                        ),
                                      ),
                                      if (_droppedItemId != null)
                                        Image.asset(_items.firstWhere((e) => e['id'] == _droppedItemId)['image'], height: 160)
                                      else ...[
                                        Positioned(
                                          bottom: 16,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.9),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text('ضعها هنا', style: _cairo(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF005DA7))),
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      // Draggable Area
                      Container(
                        height: 160,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _items.map((item) {
                            final isDropped = _droppedItemId == item['id'];
                            if (isDropped) {
                              return const SizedBox(width: 96);
                            }
                            return Draggable<String>(
                              data: item['id'],
                              feedback: Material(
                                color: Colors.transparent,
                                child: Transform.scale(
                                  scale: 1.1,
                                  child: _buildItemCard(item),
                                ),
                              ),
                              childWhenDragging: Opacity(
                                opacity: 0.3,
                                child: _buildItemCard(item),
                              ),
                              child: _buildItemCard(item),
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

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Container(
      width: 96,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE6E8EF), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Image.asset(item['image'], width: 80, height: 80, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
