import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import '../../../domain/models/level3_task.dart';
import 'step_ordering_activity_screen.dart';

class VideoInstructionScreen extends StatefulWidget {
  final Level3Task task;
  final VoidCallback onTaskCompleted;

  const VideoInstructionScreen({
    super.key,
    required this.task,
    required this.onTaskCompleted,
  });

  @override
  State<VideoInstructionScreen> createState() => _VideoInstructionScreenState();
}

class _VideoInstructionScreenState extends State<VideoInstructionScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.task.videoPath)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Color(0xFFE6E8EF))),
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

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          widget.task.instructionTitle,
                          style: _cairo(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF191C21)),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Video Player Card
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: AspectRatio(
                            aspectRatio: _isInitialized ? _controller.value.aspectRatio : 16 / 9,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (_isInitialized) VideoPlayer(_controller) else const Center(child: CircularProgressIndicator()),
                                if (_isInitialized)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
                                      });
                                    },
                                    child: Container(
                                      color: Colors.black.withOpacity(_controller.value.isPlaying ? 0.0 : 0.2),
                                      child: Center(
                                        child: _controller.value.isPlaying
                                            ? const SizedBox.shrink()
                                            : Container(
                                                padding: const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF005DA7),
                                                  shape: BoxShape.circle,
                                                  boxShadow: [
                                                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))
                                                  ],
                                                ),
                                                child: const Icon(Icons.play_arrow, color: Colors.white, size: 48),
                                              ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        Text(
                          widget.task.instructionSubtitle,
                          style: _cairo(fontSize: 16, color: const Color(0xFF414751)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2976C7),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    _controller.pause();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StepOrderingActivityScreen(
                          task: widget.task,
                          onTaskCompleted: widget.onTaskCompleted,
                        ),
                      ),
                    );
                  },
                  child: Text('ابدأ النشاط', style: _cairo(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
