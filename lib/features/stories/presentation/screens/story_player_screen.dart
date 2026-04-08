import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

import '../../data/story_data.dart';

class StoryPlayerScreen extends StatefulWidget {
  final StoryItem story;

  const StoryPlayerScreen({super.key, required this.story});

  @override
  State<StoryPlayerScreen> createState() => _StoryPlayerScreenState();
}

class _StoryPlayerScreenState extends State<StoryPlayerScreen> {
  late final AudioPlayer _player;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _player = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _player.setAsset(widget.story.audioAsset);
      _player.durationStream.listen((d) {
        if (d != null && mounted) setState(() => _duration = d);
      });
      _player.positionStream.listen((p) {
        if (mounted) setState(() => _position = p);
      });
      _player.playerStateStream.listen((state) {
        if (!mounted) return;
        setState(() => _isPlaying = state.playing);
        if (state.processingState == ProcessingState.completed) {
          _player.seek(Duration.zero);
          _player.pause();
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _togglePlayPause() {
    _isPlaying ? _player.pause() : _player.play();
  }

  void _seekRelative(int seconds) {
    final target = _position + Duration(seconds: seconds);
    _player.seek(
      target < Duration.zero
          ? Duration.zero
          : target > _duration
              ? _duration
              : target,
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        _duration.inMilliseconds > 0
            ? _position.inMilliseconds / _duration.inMilliseconds
            : 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          children: [
            _buildTopBar(context, progress),
            const SizedBox(height: 8),
            Expanded(child: _buildScrollableText()),
            _buildSeekBar(progress),
            _buildPlaybackControls(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Color(0xFF2D3748),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF5D9CEC),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            widget.story.emoji,
            style: const TextStyle(fontSize: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableText() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.story.title,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.story.text,
              style: const TextStyle(
                fontSize: 22,
                color: Color(0xFF4A5568),
                height: 2.0,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSeekBar(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: const Color(0xFF5D9CEC),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: const Color(0xFF5D9CEC),
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: (v) {
                final target = Duration(
                  milliseconds: (v * _duration.inMilliseconds).round(),
                );
                _player.seek(target);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(_position),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFA0AEC0),
                  ),
                ),
                Text(
                  _formatDuration(_duration),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFA0AEC0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => _seekRelative(-10),
            icon: const Icon(Icons.replay_10_rounded),
            color: const Color(0xFFA0AEC0),
            iconSize: 32,
          ),
          const SizedBox(width: 24),
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: Color(0xFF5D9CEC),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x335D9CEC),
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: IconButton(
              onPressed: _togglePlayPause,
              icon: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
              color: Colors.white,
              iconSize: 32,
            ),
          ),
          const SizedBox(width: 24),
          IconButton(
            onPressed: () => _seekRelative(10),
            icon: const Icon(Icons.forward_10_rounded),
            color: const Color(0xFFA0AEC0),
            iconSize: 32,
          ),
        ],
      ),
    );
  }
}
