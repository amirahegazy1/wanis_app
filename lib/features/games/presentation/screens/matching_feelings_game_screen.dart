import 'package:flutter/material.dart';

import 'games_dialogs.dart';

class MatchingFeelingsGameScreen extends StatefulWidget {
  const MatchingFeelingsGameScreen({super.key});

  @override
  State<MatchingFeelingsGameScreen> createState() => _MatchingFeelingsGameScreenState();
}

class _MatchingFeelingsGameScreenState extends State<MatchingFeelingsGameScreen> {
  // Mapping face IDs to emotion IDs (0: Anger, 1: Happy, 2: Sad)
  final Map<int, int> correctMatches = {
    0: 1, // Happy girl -> 😄
    1: 0, // Angry girl -> 😡
    2: 2, // Sad girl -> 😭
  };

  final Map<int, int?> currentMatches = {};

  final List<String> faces = [
    'https://via.placeholder.com/100/CCCCCC/FFFFFF?text=Happy', // Happy
    'https://via.placeholder.com/100/CCCCCC/FFFFFF?text=Angry', // Angry
    'https://via.placeholder.com/100/CCCCCC/FFFFFF?text=Sad',   // Sad
  ];

  final List<String> emojis = [
    '😡',
    '😄',
    '😭',
  ];

  bool _checkStatus() {
    if (currentMatches.length != 3) return false;
    for (var entry in currentMatches.entries) {
      if (correctMatches[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  void _onMatchAttempt(int faceIndex, int emojiIndex) {
    if (correctMatches[faceIndex] != emojiIndex) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MatchingFeelingsTryAgainDialog(
          onRetry: () => Navigator.pop(context),
        ),
      );
    } else {
      setState(() {
        currentMatches[faceIndex] = emojiIndex;
      });
      if (_checkStatus()) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => MatchingFeelingsWinDialog(
            onNextGame: () {
              Navigator.pop(context);
              Navigator.pop(context); // simple pop for now
            },
            onReturnToMenu: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        );
      }
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
          'وصل الوجه بالشعور المناسب',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Column of Faces (Draggable)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        faces.length,
                        (index) => _buildFaceItem(index),
                      ),
                    ),
                    // Column of Emojis (DragTargets)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        emojis.length,
                        (index) => _buildEmojiTarget(index),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Progress Bar
              const Text(
                '1 من 3',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA0AEC0),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 66,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5D9CEC),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 134,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaceItem(int index) {
    final isMatched = currentMatches.containsKey(index);

    return Draggable<int>(
      data: index,
      maxSimultaneousDrags: isMatched ? 0 : 1,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: _buildFaceCard(index, true),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildFaceCard(index, false),
      ),
      child: _buildFaceCard(index, isMatched),
    );
  }

  Widget _buildFaceCard(int index, bool isMatched) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
        image: DecorationImage(
          image: NetworkImage(faces[index]), // Using placeholder
          fit: BoxFit.cover,
        ),
      ),
      child: isMatched
          ? Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 40),
            )
          : null,
    );
  }

  Widget _buildEmojiTarget(int index) {
    final isMatched = currentMatches.containsValue(index);

    return DragTarget<int>(
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: index == 0
                ? const Color(0xFFFFF5F5)
                : index == 1
                    ? const Color(0xFFFFF5EB)
                    : const Color(0xFFEBF8FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovering
                  ? Colors.blue
                  : index == 0
                      ? const Color(0xFFFC8181)
                      : index == 1
                          ? const Color(0xFFF4A261)
                          : const Color(0xFF5D9CEC),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: isMatched
              ? Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white70,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.check, color: Colors.green, size: 40),
                  ),
                )
              : Text(
                  emojis[index],
                  style: const TextStyle(fontSize: 48),
                ),
        );
      },
      onWillAcceptWithDetails: (details) => !isMatched, // prevent accepting if already matched
      onAcceptWithDetails: (details) {
        _onMatchAttempt(details.data, index);
      },
    );
  }
}
