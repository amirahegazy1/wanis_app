import 'package:flutter/material.dart';

import 'games_dialogs.dart';

class SortingGameScreen extends StatefulWidget {
  const SortingGameScreen({super.key});

  @override
  State<SortingGameScreen> createState() => _SortingGameScreenState();
}

class _SortingGameScreenState extends State<SortingGameScreen> {
  // Simple game state: true when a shape is correctly dropped in its bin
  bool _isRedSorted = false;
  bool _isBlueSorted = false;

  void _checkWinCondition() {
    if (_isRedSorted && _isBlueSorted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SortingGameWinDialog(
          onNextGame: () {
            // Placeholder: could go to next game, for now just pop twice
            Navigator.pop(context); // close dialog
            Navigator.pop(context); // exit game
          },
          onReturnToMenu: () {
            Navigator.pop(context); // close dialog
            Navigator.pop(context); // exit game
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF2D3748)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'اسحب الشكل للصندوق المناسب',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            // The Jars (DragTargets)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildJarTarget(
                  color: const Color(0xFFFC8181),
                  bgColor: const Color(0xFFFFF5F5),
                  isSorted: _isRedSorted,
                  acceptedData: 'red',
                  onAccept: (data) {
                    setState(() {
                      _isRedSorted = true;
                    });
                    _checkWinCondition();
                  },
                ),
                _buildJarTarget(
                  color: const Color(0xFF63B3ED),
                  bgColor: const Color(0xFFEBF8FF),
                  isSorted: _isBlueSorted,
                  acceptedData: 'blue',
                  onAccept: (data) {
                    setState(() {
                      _isBlueSorted = true;
                    });
                    _checkWinCondition();
                  },
                ),
              ],
            ),
            const Spacer(),
            // The Draggable items container
            Container(
              width: double.infinity,
              height: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  if (!_isBlueSorted)
                    Positioned(
                      left: 40,
                      top: 40,
                      child: _buildDraggableShape('blue', const Color(0xFF63B3ED), isCircle: false),
                    ),
                  if (!_isRedSorted)
                    Positioned(
                      left: 140,
                      top: 40,
                      child: _buildDraggableShape('red', const Color(0xFFFC8181), isCircle: true),
                    ),
                  if (!_isBlueSorted)
                    Positioned(
                      right: 40,
                      top: 70,
                      child: _buildDraggableShape('blue', const Color(0xFF63B3ED), isCircle: false), // duplicate just for visual richness as in design
                    ),
                  if (!_isRedSorted)
                    Positioned(
                      left: 60,
                      bottom: 60,
                      child: _buildDraggableShape('red', const Color(0xFFFC8181), isCircle: true), // duplicate just for visual richness as in design
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJarTarget({
    required Color color,
    required Color bgColor,
    required bool isSorted,
    required String acceptedData,
    required void Function(String) onAccept,
  }) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return Container(
          width: 140,
          height: 160,
          decoration: BoxDecoration(
            color: isHovering ? bgColor.withOpacity(0.5) : bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isHovering ? color : color.withOpacity(0.5),
              width: 3,
            ),
          ),
          child: Column(
            children: [
              // Jar Lid mock
              Container(
                height: 12,
                width: 120,
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              Expanded(
                child: Center(
                  child: isSorted
                      ? Icon(Icons.check_circle, size: 64, color: color)
                      : Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.2),
                            shape: acceptedData == 'red' ? BoxShape.circle : BoxShape.rectangle,
                            borderRadius: acceptedData == 'blue' ? BorderRadius.circular(12) : null,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
      onWillAcceptWithDetails: (details) => details.data == acceptedData,
      onAcceptWithDetails: (details) => onAccept(details.data),
    );
  }

  Widget _buildDraggableShape(String data, Color color, {required bool isCircle}) {
    final shapeWidget = Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: color,
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
    );

    return Draggable<String>(
      data: data,
      feedback: Transform.scale(
        scale: 1.1,
        child: shapeWidget,
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: shapeWidget,
      ),
      child: shapeWidget,
    );
  }
}
