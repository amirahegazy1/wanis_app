import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'games_dialogs.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  // Simple Memory Game logic
  final List<String> _items = [
    '🐱', '🐱',
    '🐶', '🐶',
    '🐰', '🐰',
  ];

  late List<bool> _isFlipped;
  late List<bool> _isMatched;
  
  int _score = 0;
  int? _firstFlippedIndex;
  
  // Prevent tapping while animating
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _items.shuffle();
    _isFlipped = List.generate(_items.length, (index) => false);
    _isMatched = List.generate(_items.length, (index) => false);
    _score = 0;
    _firstFlippedIndex = null;
    _isProcessing = false;
    setState(() {});
  }

  Future<void> _onCardTap(int index) async {
    if (_isProcessing || _isFlipped[index] || _isMatched[index]) {
      return;
    }

    setState(() {
      _isFlipped[index] = true;
    });

    if (_firstFlippedIndex == null) {
      _firstFlippedIndex = index;
    } else {
      _isProcessing = true;
      final int firstIndex = _firstFlippedIndex!;
      final int secondIndex = index;

      if (_items[firstIndex] == _items[secondIndex]) {
        // Match found
        _isMatched[firstIndex] = true;
        _isMatched[secondIndex] = true;
        _score++;
        _isProcessing = false;
        _firstFlippedIndex = null;
        
        if (_score == _items.length ~/ 2) {
          _showWinDialog();
        }
      } else {
        // No match, wait and hide
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          setState(() {
            _isFlipped[firstIndex] = false;
            _isFlipped[secondIndex] = false;
            _firstFlippedIndex = null;
            _isProcessing = false;
          });
        }
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MemoryGameWinDialog(
        onNextGame: () {
          Navigator.pop(context);
          Navigator.pop(context); // Go back for now
        },
        onReturnToMenu: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
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
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE6FFFA),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '${_items.length ~/ 2} أزواج 🐾',
              style: const TextStyle(
                color: Color(0xFF38B2AC),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'تذكر أماكن الصور',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 48),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return _buildMemoryCard(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemoryCard(int index) {
    final isFlipped = _isFlipped[index];
    final isMatched = _isMatched[index];

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _onCardTap(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isFlipped ? Colors.white : const Color(0xFF5D9CEC),
          borderRadius: BorderRadius.circular(16),
          border: isFlipped
              ? Border.all(
                  color: isMatched
                      ? const Color(0xFF48C774)
                      : const Color(0xFF5D9CEC),
                  width: 4,
                )
              : null,
        ),
        child: Center(
          child: isFlipped
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      _items[index],
                      style: const TextStyle(fontSize: 48),
                    ),
                    if (isMatched)
                      Positioned(
                        right: -8,
                        bottom: -8,
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.check_circle,
                            color: Color(0xFF48C774),
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                )
              : const Text(
                  '?',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
