import 'package:flutter/material.dart';

/// Draws detected skeleton keypoints onto the camera preview.
class PosePainter extends CustomPainter {
  final List<List<double>> keypoints;
  final Size imageSize;
  final bool isFrontCamera;

  PosePainter({
    required this.keypoints,
    required this.imageSize,
    this.isFrontCamera = true,
  });

  static const List<List<int>> skeleton = [
    [0, 1], [0, 2],   // nose → eyes
    [1, 3], [2, 4],   // eyes → ears
    [5, 6],           // shoulders
    [5, 7], [7, 9],   // left arm
    [6, 8], [8, 10],  // right arm
    [5, 11], [6, 12], // torso
    [11, 12],         // hips
    [11, 13], [13, 15], // left leg
    [12, 14], [14, 16], // right leg
  ];

  static const Map<int, Color> keypointColors = {
    0: Color(0xFF4A90E2),   // nose
    1: Color(0xFF4A90E2),   // left eye
    2: Color(0xFF4A90E2),   // right eye
    3: Color(0xFF4A90E2),   // left ear
    4: Color(0xFF4A90E2),   // right ear
    5: Color(0xFF22C55E),   // left shoulder
    6: Color(0xFF22C55E),   // right shoulder
    7: Color(0xFFF59E0B),   // left elbow
    8: Color(0xFFF59E0B),   // right elbow
    9: Color(0xFFEF4444),   // left wrist
    10: Color(0xFFEF4444),  // right wrist
    11: Color(0xFF22C55E),  // left hip
    12: Color(0xFF22C55E),  // right hip
    13: Color(0xFFF59E0B),  // left knee
    14: Color(0xFFF59E0B),  // right knee
    15: Color(0xFFEF4444),  // left ankle
    16: Color(0xFFEF4444),  // right ankle
  };

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw skeleton lines
    for (final connection in skeleton) {
      final kp1 = keypoints[connection[0]];
      final kp2 = keypoints[connection[1]];

      if (kp1[2] > 0.2 && kp2[2] > 0.2) {
        final x1 = isFrontCamera
            ? (1 - kp1[1]) * size.width
            : kp1[1] * size.width;
        final y1 = kp1[0] * size.height;
        final x2 = isFrontCamera
            ? (1 - kp2[1]) * size.width
            : kp2[1] * size.width;
        final y2 = kp2[0] * size.height;

        linePaint.color = _getLineColor(connection[0], connection[1]);
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), linePaint);
      }
    }

    // Draw keypoints
    for (int i = 0; i < keypoints.length; i++) {
      final kp = keypoints[i];
      if (kp[2] > 0.2) {
        final x = isFrontCamera
            ? (1 - kp[1]) * size.width
            : kp[1] * size.width;
        final y = kp[0] * size.height;

        final color = keypointColors[i] ?? Colors.white;

        // Shadow
        canvas.drawCircle(
          Offset(x + 1, y + 1),
          6,
          Paint()
            ..color = Colors.black38
            ..style = PaintingStyle.fill,
        );

        // Filled circle
        canvas.drawCircle(
          Offset(x, y),
          6,
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );

        // Border
        canvas.drawCircle(
          Offset(x, y),
          6,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5,
        );
      }
    }
  }

  Color _getLineColor(int idx1, int idx2) {
    if (idx1 <= 4 && idx2 <= 4) {
      return const Color(0xFF4A90E2).withValues(alpha: 0.8);
    }
    if (idx1 == 7 || idx1 == 9 || idx2 == 7 || idx2 == 9) {
      return const Color(0xFFF59E0B).withValues(alpha: 0.8);
    }
    if (idx1 == 8 || idx1 == 10 || idx2 == 8 || idx2 == 10) {
      return const Color(0xFFEF4444).withValues(alpha: 0.8);
    }
    return const Color(0xFF22C55E).withValues(alpha: 0.8);
  }

  @override
  bool shouldRepaint(PosePainter oldDelegate) =>
    oldDelegate.keypoints != keypoints;
}
