import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/level3_task.dart';

class StepOrderingActivityScreen extends StatefulWidget {
  final Level3Task task;
  final VoidCallback onTaskCompleted;

  const StepOrderingActivityScreen({
    super.key,
    required this.task,
    required this.onTaskCompleted,
  });

  @override
  State<StepOrderingActivityScreen> createState() => _StepOrderingActivityScreenState();
}

class _StepOrderingActivityScreenState extends State<StepOrderingActivityScreen> {
  // map index (0 to 3) to dropped step
  final Map<int, Level3Step> _droppedSteps = {};
  late List<Level3Step> _availableSteps;

  @override
  void initState() {
    super.initState();
    // Shuffle the steps for the bottom draggable area
    _availableSteps = List.from(widget.task.steps)..shuffle();
  }

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
    if (_droppedSteps.length == 4) {
      bool isCorrect = true;
      for (int i = 0; i < 4; i++) {
        if (_droppedSteps[i]!.correctIndex != i) {
          isCorrect = false;
          break;
        }
      }

      if (isCorrect) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('أحسنت!', style: _cairo(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF4CAF50)), textAlign: TextAlign.center),
            content: Text('لقد قمت بترتيب الخطوات بشكل صحيح!', style: _cairo(fontSize: 16), textAlign: TextAlign.center),
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
                    widget.onTaskCompleted(); // move to next
                  },
                  child: Text('التالي', style: _cairo(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              )
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('الترتيب غير صحيح، حاول مرة أخرى!', style: _cairo(color: Colors.white)),
            backgroundColor: Colors.redAccent,
          ),
        );
        setState(() {
          _droppedSteps.clear();
          _availableSteps = List.from(widget.task.steps)..shuffle();
        });
      }
    }
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
                      const SizedBox(height: 24),
                      Text('رتب الخطوات', style: _cairo(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF005DA7))),
                      const SizedBox(height: 4),
                      Text('المستوى الثالث', style: _cairo(fontSize: 14, color: const Color(0xFF777777))),
                      const SizedBox(height: 24),
                      
                      // Target Drop Zones (2x2 grid)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1,
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return _buildDropZone(index);
                          },
                        ),
                      ),
                      
                      // Divider
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(child: Container(height: 2, color: const Color(0xFF005DA7))),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.swap_vert, color: Color(0xFF005DA7)),
                            ),
                            Expanded(child: Container(height: 2, color: const Color(0xFF005DA7))),
                          ],
                        ),
                      ),
                      
                      // Draggable Items Area
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.5,
                            ),
                            itemCount: _availableSteps.length,
                            itemBuilder: (context, index) {
                              final step = _availableSteps[index];
                              return Draggable<Level3Step>(
                                data: step,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Transform.scale(
                                    scale: 1.05,
                                    child: SizedBox(width: 150, child: _buildDraggableCard(step)),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.3,
                                  child: _buildDraggableCard(step),
                                ),
                                child: _buildDraggableCard(step),
                              );
                            },
                          ),
                        ),
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

  Widget _buildDropZone(int index) {
    final step = _droppedSteps[index];
    
    return DragTarget<Level3Step>(
      onAcceptWithDetails: (details) {
        setState(() {
          _droppedSteps[index] = details.data;
          _availableSteps.removeWhere((s) => s.id == details.data.id);
        });
        _checkCompletion();
      },
      builder: (context, candidateData, rejectedData) {
        if (step != null) {
          // Show the dropped image
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFFECEDF5),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF4CAF50), width: 3),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned.fill(child: Image.asset(step.image, fit: BoxFit.cover)),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(color: Color(0xFF005DA7), shape: BoxShape.circle),
                    child: Center(child: Text('${index + 1}', style: _cairo(color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F3FB),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: candidateData.isNotEmpty ? const Color(0xFF4CAF50) : const Color(0xFF005DA7),
              width: candidateData.isNotEmpty ? 4 : 3,
            ),
          ),
          child: Center(
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF005DA7),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: _cairo(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDraggableCard(Level3Step step) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6E8EF), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFECEDF5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(step.image, fit: BoxFit.cover),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Text(
              step.title,
              style: _cairo(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF333333)),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
