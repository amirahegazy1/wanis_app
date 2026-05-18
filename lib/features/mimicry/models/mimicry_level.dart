/// Supported pose activity types for the AI detection engine.
enum ActivityType {
  waving,
  clapping,
  handOnHead,
  stirring,
  hair,
  throwingBall,
  straightenHands,
  cupStacking,
}

/// Represents a single mimicry session within Level 1.
class MimicryLevel {
  final int id;
  final String title;
  final String emoji;
  final String videoAsset;
  final ActivityType activityType;
  final String instruction;
  final int durationSeconds;
  final double requiredScore;

  const MimicryLevel({
    required this.id,
    required this.title,
    required this.emoji,
    required this.videoAsset,
    required this.activityType,
    required this.instruction,
    this.durationSeconds = 5,
    this.requiredScore = 60,
  });
}

/// All mimicry sessions — they form the sub-levels of Level 1 "التقليد".
class MimicryLevels {
  static const List<MimicryLevel> all = [
    MimicryLevel(
      id: 1,
      title: 'تلويح أهلاً',
      emoji: '👋',
      videoAsset: 'assets/videos/waving_hello.mp4',
      activityType: ActivityType.waving,
      instruction: 'لوّح بإيدك وقول أهلاً!',
    ),
    MimicryLevel(
      id: 2,
      title: 'تصفيق',
      emoji: '👏',
      videoAsset: 'assets/videos/clapping.mp4',
      activityType: ActivityType.clapping,
      instruction: 'صفّق بإيديك مع بعض!',
    ),
    MimicryLevel(
      id: 3,
      title: 'إيد على الرأس',
      emoji: '🙆',
      videoAsset: 'assets/videos/hand_on_head.mp4',
      activityType: ActivityType.handOnHead,
      instruction: 'حط إيدك على رأسك!',
    ),
    MimicryLevel(
      id: 4,
      title: 'تقليب بمعلقة',
      emoji: '🥄',
      videoAsset: 'assets/videos/stirring.mp4',
      activityType: ActivityType.stirring,
      instruction: 'قلّب زي ما بتطبخ!',
    ),
    MimicryLevel(
      id: 5,
      title: 'تمشيط الشعر',
      emoji: '💇',
      videoAsset: 'assets/videos/hair.mp4',
      activityType: ActivityType.hair,
      instruction: 'تمشيط شعرك!',
    ),
    MimicryLevel(
      id: 6,
      title: 'رمي الكرة',
      emoji: '🏀',
      videoAsset: 'assets/videos/thowing_ball.mp4',
      activityType: ActivityType.throwingBall,
      instruction: 'أرمي الكرة!',
    ),
    MimicryLevel(
      id: 7,
      title: 'فرد الزراعين',
      emoji: '👐',
      videoAsset: 'assets/videos/Straighten_hands.mp4',
      activityType: ActivityType.straightenHands,
      instruction: 'فرد زراعيك للجانب!',
    ),
    MimicryLevel(
      id: 8,
      title: 'تركيب مكعب فوق مكعب',
      emoji: '🧱',
      videoAsset: 'assets/videos/cup_stacking.mp4',
      activityType: ActivityType.cupStacking,
      instruction: 'ضع مكعب فوق مكعب آخر!',
    ),
  ];
}
