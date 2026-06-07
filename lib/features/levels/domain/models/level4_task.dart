import 'package:flutter/material.dart';

class Level4Option {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isCorrect;
  final Color placeholderColor;
  final String placeholderEmoji;

  const Level4Option({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isCorrect,
    this.placeholderColor = const Color(0xFFF2F3FB),
    this.placeholderEmoji = '',
  });
}

class Level4Task {
  final String id;
  final String title;
  final String question;
  final String scenarioImagePath;
  final Color scenarioPlaceholderColor;
  final String scenarioPlaceholderEmoji;
  final List<Level4Option> options;

  const Level4Task({
    required this.id,
    required this.title,
    required this.question,
    required this.scenarioImagePath,
    required this.options,
    this.scenarioPlaceholderColor = const Color(0xFFE2E8F0),
    this.scenarioPlaceholderEmoji = '',
  });
}
