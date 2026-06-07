class Level3Step {
  final String id;
  final String title;
  final String subtitle;
  final String image;
  final int correctIndex;

  const Level3Step({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.correctIndex,
  });
}

class Level3Task {
  final String id;
  final String title;
  final String instructionTitle;
  final String instructionSubtitle;
  final String videoPath;
  final List<Level3Step> steps;

  const Level3Task({
    required this.id,
    required this.title,
    required this.instructionTitle,
    required this.instructionSubtitle,
    required this.videoPath,
    required this.steps,
  });
}
