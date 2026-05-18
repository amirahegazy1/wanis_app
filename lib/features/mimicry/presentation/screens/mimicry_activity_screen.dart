import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/camera_service.dart';
import '../../services/pose_service.dart';
import '../../services/progress_service.dart';
import '../../widgets/pose_painter.dart';
import '../../models/mimicry_level.dart';
import 'mimicry_result_screen.dart';

enum _Phase { watchingVideo, ready, analyzing, done }

/// Full activity flow: watch video → ready → camera AI analysis → result.
/// Design reference: Figma node `111:1811` (3 screens).
class MimicryActivityScreen extends StatefulWidget {
  final MimicryLevel level;
  const MimicryActivityScreen({super.key, required this.level});

  @override
  State<MimicryActivityScreen> createState() => _MimicryActivityScreenState();
}

class _MimicryActivityScreenState extends State<MimicryActivityScreen> {
  static const _blue = Color(0xFF4A90E2);
  static const _darkBlue = Color(0xFF005DA7);

  late VideoPlayerController _video;
  bool _videoReady = false;
  final CameraService _cam = CameraService();
  final PoseService _pose = PoseService();
  bool _processing = false;
  bool _isDisposed = false;
  List<List<double>> _kps = [];
  _Phase _phase = _Phase.watchingVideo;
  int _successFrames = 0, _totalFrames = 0;
  double _score = 0;

  static TextStyle _cairo({double sz = 16, FontWeight fw = FontWeight.w400, Color c = Colors.white}) =>
      GoogleFonts.cairo(fontSize: sz, fontWeight: fw, color: c);

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _video = VideoPlayerController.asset(widget.level.videoAsset);
    await _video.initialize();
    _video.setLooping(false);
    _video.play();
    _video.addListener(() {
      if (_video.value.position >= _video.value.duration && _phase == _Phase.watchingVideo) {
        setState(() => _phase = _Phase.ready);
      }
    });
    setState(() => _videoReady = true);
  }

  Future<void> _startAnalysis() async {
    setState(() { _phase = _Phase.analyzing; _successFrames = 0; _totalFrames = 0; _kps = []; });
    await _pose.initialize();
    if (_isDisposed) return;
    await _cam.initialize();
    if (_isDisposed || _cam.controller == null) return;
    int fc = 0;
    _cam.controller!.startImageStream((img) async {
      fc++;
      if (fc % 4 != 0 || _processing || _phase != _Phase.analyzing) return;
      _processing = true;
      final kps = await _pose.detectPose(img);
      if (kps != null && mounted) {
        _totalFrames++;
        if (_isDoingActivity(kps)) _successFrames++;
        setState(() => _kps = kps);
      }
      _processing = false;
    });
    await Future.delayed(Duration(seconds: widget.level.durationSeconds));
    if (!_isDisposed) {
      await _finish();
    }
  }

  Future<void> _finish() async {
    if (_isDisposed) return;
    try { await _cam.controller?.stopImageStream(); } catch (_) {}
    _cam.dispose();
    _pose.dispose();
    _score = _totalFrames > 0 ? (_successFrames / _totalFrames * 100).clamp(0, 100) : 0;
    await MimicryProgressService.saveScore(widget.level.id, _score);
    if (!mounted || _isDisposed) return;
    setState(() => _phase = _Phase.done);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => MimicryResultScreen(
        score: _score, activityName: widget.level.title,
        levelId: widget.level.id, requiredScore: widget.level.requiredScore,
      ),
    ));
  }

  @override
  void dispose() {
    _isDisposed = true;
    _video.dispose();
    try { _cam.controller?.stopImageStream(); } catch (_) {}
    _cam.dispose();
    _pose.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: _phase == _Phase.analyzing ? Colors.black : Colors.white,
        body: SafeArea(child: switch (_phase) {
          _Phase.watchingVideo => _buildVideoPhase(),
          _Phase.ready => _buildReadyPhase(),
          _Phase.analyzing => _buildAnalyzingPhase(),
          _Phase.done => const Center(child: CircularProgressIndicator()),
        }),
      ),
    );
  }

  // ── Phase 1: Video (Figma: شاشه الفيديو) ──────────────────────

  Widget _buildVideoPhase() {
    return Column(children: [
      _header(),
      Expanded(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const SizedBox(height: 16),
          _videoCard(),
          const SizedBox(height: 32),
          Text('حان وقت اللعب!', style: _cairo(sz: 22, fw: FontWeight.w700, c: _darkBlue)),
          const SizedBox(height: 4),
          Text('شاهد الفيديو لنبدأ الرحلة', style: _cairo(sz: 16, c: const Color(0xFF777777))),
        ]),
      )),
      _bottomButton('استنى الفيديو يخلص...', null, enabled: false),
    ]);
  }

  // ── Phase 2: Ready (Figma: شاشه التعليمات) ────────────────────

  Widget _buildReadyPhase() {
    return Column(children: [
      _header(),
      Expanded(child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const SizedBox(height: 16),
          _videoCard(showReplay: true),
          const SizedBox(height: 32),
          Text('حاول تقلد الحركة', style: _cairo(sz: 22, fw: FontWeight.w700, c: const Color(0xFF333333))),
          const SizedBox(height: 8),
          Text(widget.level.instruction, style: _cairo(sz: 16, c: const Color(0xFF777777))),
          const SizedBox(height: 4),
          Text('عندك ${widget.level.durationSeconds} ثواني', style: _cairo(sz: 14, c: const Color(0xFF999999))),
        ]),
      )),
      _bottomButton('التالي ›', _startAnalysis),
    ]);
  }

  // ── Phase 3: Camera AI (Figma: شاشه الكاميرا) ─────────────────

  Widget _buildAnalyzingPhase() {
    final active = _kps.isNotEmpty && _isDoingActivity(_kps);
    return Stack(fit: StackFit.expand, children: [
      if (_cam.controller != null && _cam.controller!.value.isInitialized)
        CameraPreview(_cam.controller!),
      // Vignette
      Container(decoration: BoxDecoration(
        gradient: RadialGradient(colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)], radius: 0.9),
      )),
      // Skeleton overlay
      if (_kps.isNotEmpty)
        RepaintBoundary(child: CustomPaint(painter: PosePainter(
          keypoints: _kps, imageSize: MediaQuery.of(context).size, isFrontCamera: true,
        ))),
      // Guide ring
      Center(child: Container(
        width: 260, height: 260,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 9999, spreadRadius: 9999)],
        ),
        child: Center(child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Text('قف هنا', style: _cairo(sz: 14, fw: FontWeight.w600, c: Colors.white.withValues(alpha: 0.8))),
        )),
      )),
      // Close button
      Positioned(top: 8, left: 8, child: GestureDetector(
        onTap: () { Navigator.pop(context); },
        child: Container(width: 48, height: 48, decoration: const BoxDecoration(shape: BoxShape.circle),
          child: const Icon(Icons.close, color: Colors.white, size: 22)),
      )),
      // Bottom status
      Positioned(left: 0, right: 0, bottom: 0, child: Container(
        padding: const EdgeInsets.fromLTRB(20, 32, 20, 48),
        decoration: BoxDecoration(gradient: LinearGradient(
          begin: Alignment.bottomCenter, end: Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
        )),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('قلّد الحركة', style: _cairo(sz: 28, fw: FontWeight.w400)),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(active ? '🎉 ممتاز!' : 'جاري التحقق...', style: _cairo(sz: 16, c: Colors.white.withValues(alpha: 0.9))),
            const SizedBox(width: 12),
            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(
              strokeWidth: 2, valueColor: const AlwaysStoppedAnimation(Colors.white),
              backgroundColor: Colors.white.withValues(alpha: 0.3),
            )),
          ]),
        ]),
      )),
    ]);
  }

  // ── Shared Widgets ────────────────────────────────────────────

  Widget _header() {
    return Container(
      height: 64, padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(color: Colors.white,
        border: Border(bottom: BorderSide(color: const Color(0xFFF3F4F6), width: 1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 1)],
      ),
      child: Row(children: [
        Text('ونيس', style: _cairo(sz: 22, fw: FontWeight.w700, c: _blue)),
        const Spacer(),
        GestureDetector(onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_forward_rounded, size: 20, color: Color(0xFF475569))),
      ]),
    );
  }

  Widget _videoCard({bool showReplay = false}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FB), borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 2)],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(28), child: Stack(children: [
        if (_videoReady) AspectRatio(aspectRatio: _video.value.aspectRatio, child: VideoPlayer(_video))
        else const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
        // Play overlay
        Positioned.fill(child: Center(child: GestureDetector(
          onTap: () {
            if (showReplay && _videoReady) {
              _video.seekTo(Duration.zero);
              _video.play();
            }
          },
          child: Container(
            width: 80, height: 80,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.9),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 25, spreadRadius: -6)]),
            child: Icon(showReplay ? Icons.replay : Icons.play_arrow_rounded, size: 35, color: _blue),
          ),
        ))),
        // Progress bar
        if (_videoReady) Positioned(left: 24, right: 24, bottom: 24, child: ClipRRect(
          borderRadius: BorderRadius.circular(9999),
          child: VideoProgressIndicator(_video, allowScrubbing: false,
            colors: VideoProgressColors(
              playedColor: const Color(0xFFFFD54F),
              bufferedColor: Colors.white.withValues(alpha: 0.3),
              backgroundColor: Colors.white.withValues(alpha: 0.3),
            )),
        )),
      ])),
    );
  }

  Widget _bottomButton(String label, VoidCallback? onTap, {bool enabled = true}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8)),
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: Container(
          height: 56, width: double.infinity,
          decoration: BoxDecoration(
            color: enabled ? _blue : const Color(0xFFE1E2E9),
            borderRadius: BorderRadius.circular(16),
            boxShadow: enabled ? [BoxShadow(color: _darkBlue.withValues(alpha: 0.2), offset: const Offset(0, 10), blurRadius: 15)] : [],
          ),
          child: Center(child: Text(label, style: _cairo(sz: 18, fw: FontWeight.w700, c: enabled ? Colors.white : const Color(0xFF94A3B8)))),
        ),
      ),
    );
  }

  // ── Pose Detection Logic (from AI project) ────────────────────

  bool _isDoingActivity(List<List<double>> kps) => switch (widget.level.activityType) {
    ActivityType.waving => _isWaving(kps),
    ActivityType.clapping => _isClapping(kps),
    ActivityType.handOnHead => _isHandOnHead(kps),
    ActivityType.stirring => _isStirring(kps),
    ActivityType.hair => _isCombingHair(kps),
    ActivityType.throwingBall => _isThrowingBall(kps),
    ActivityType.straightenHands => _isStraighteningHands(kps),
    ActivityType.cupStacking => _isCupStacking(kps),
  };

  bool _isWaving(List<List<double>> kps) {
    final nose = kps[0], lW = kps[9], rW = kps[10], lS = kps[5], rS = kps[6];
    if (nose[2] < 0.3 || (lS[2] < 0.3 && rS[2] < 0.3)) return false;
    final sY = (lS[0] + rS[0]) / 2;
    return (lW[2] > 0.2 && lW[0] < sY - 0.05) || (rW[2] > 0.2 && rW[0] < sY - 0.05);
  }

  bool _isClapping(List<List<double>> kps) {
    final lW = kps[9], rW = kps[10];
    if (lW[2] < 0.2 || rW[2] < 0.2) return false;
    return (lW[1] - rW[1]).abs() < 0.15;
  }

  bool _isHandOnHead(List<List<double>> kps) {
    final nose = kps[0], lW = kps[9], rW = kps[10];
    if (nose[2] < 0.3) return false;
    return (lW[2] > 0.2 && lW[0] < nose[0]) || (rW[2] > 0.2 && rW[0] < nose[0]);
  }

  bool _isStirring(List<List<double>> kps) {
    final lW = kps[9], rW = kps[10], lS = kps[5], rS = kps[6];
    if (lS[2] < 0.3 || rS[2] < 0.3) return false;
    final sY = (lS[0] + rS[0]) / 2;
    bool lM = lW[2] > 0.2 && lW[0] > sY - 0.1 && lW[0] < sY + 0.3;
    bool rM = rW[2] > 0.2 && rW[0] > sY - 0.1 && rW[0] < sY + 0.3;
    return lM || rM;
  }

  bool _isCombingHair(List<List<double>> kps) {
    final nose = kps[0], lE = kps[3], rE = kps[4], lW = kps[9], rW = kps[10], lS = kps[5], rS = kps[6];
    if (nose[2] < 0.3 || (lS[2] < 0.3 && rS[2] < 0.3)) return false;
    final headY = lE[2] > 0.2 ? lE[0] : rE[2] > 0.2 ? rE[0] : nose[0];
    final sY = (lS[0] + rS[0]) / 2;
    final headX = nose[1];
    bool lC = lW[2] > 0.2 && lW[0] < sY && lW[0] < headY + 0.1 && (lW[1] - headX).abs() < 0.25;
    bool rC = rW[2] > 0.2 && rW[0] < sY && rW[0] < headY + 0.1 && (rW[1] - headX).abs() < 0.25;
    return lC || rC;
  }

  bool _isThrowingBall(List<List<double>> kps) {
    final lW = kps[9], rW = kps[10], lS = kps[5], rS = kps[6], lEl = kps[7], rEl = kps[8];
    if (lS[2] < 0.3 && rS[2] < 0.3) return false;
    final sY = (lS[0] + rS[0]) / 2;
    bool lT = lW[2] > 0.2 && lEl[2] > 0.2 && lW[0] < sY && lW[0] < lEl[0] && lEl[0] < sY + 0.1;
    bool rT = rW[2] > 0.2 && rEl[2] > 0.2 && rW[0] < sY && rW[0] < rEl[0] && rEl[0] < sY + 0.1;
    return lT || rT;
  }

  bool _isStraighteningHands(List<List<double>> kps) {
    final lW = kps[9], rW = kps[10], lEl = kps[7], rEl = kps[8], lS = kps[5], rS = kps[6];
    if (lS[2] < 0.3 || rS[2] < 0.3 || lW[2] < 0.2 || rW[2] < 0.2 || lEl[2] < 0.2 || rEl[2] < 0.2) return false;
    final sY = (lS[0] + rS[0]) / 2;
    return (lW[0] - sY).abs() < 0.15 && (rW[0] - sY).abs() < 0.15 &&
        (lW[1] - rW[1]).abs() > 0.4 && (lEl[0] - sY).abs() < 0.15 && (rEl[0] - sY).abs() < 0.15;
  }

  bool _isCupStacking(List<List<double>> kps) {
    final lW = kps[9], rW = kps[10], lS = kps[5], rS = kps[6], lH = kps[11], rH = kps[12];
    if (lS[2] < 0.3 && rS[2] < 0.3) return false;
    final sY = (lS[0] + rS[0]) / 2;
    final hY = (lH[2] > 0.2 && rH[2] > 0.2) ? (lH[0] + rH[0]) / 2 : sY + 0.3;
    final bC = (lS[1] + rS[1]) / 2;
    bool lSt = lW[2] > 0.2 && lW[0] > sY && lW[0] < hY && (lW[1] - bC).abs() < 0.3;
    bool rSt = rW[2] > 0.2 && rW[0] > sY && rW[0] < hY && (rW[1] - bC).abs() < 0.3;
    bool both = lSt && rSt && (lW[1] - rW[1]).abs() < 0.3;
    return both || (lSt && lW[2] > 0.4) || (rSt && rW[2] > 0.4);
  }
}
