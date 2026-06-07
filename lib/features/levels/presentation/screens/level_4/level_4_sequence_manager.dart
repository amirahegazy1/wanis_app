import 'package:flutter/material.dart';
import '../../../domain/models/level4_task.dart';
import 'social_situation_screen.dart';

class Level4SequenceManager extends StatefulWidget {
  const Level4SequenceManager({super.key});

  @override
  State<Level4SequenceManager> createState() => _Level4SequenceManagerState();
}

class _Level4SequenceManagerState extends State<Level4SequenceManager> {
  int _currentTaskIndex = 0;

  final List<Level4Task> _tasks = [
    // Activity 1: Emotional Support
    const Level4Task(
      id: 'emotional_support',
      title: 'نشاط التفاعل الاجتماعي',
      question: 'اختر التصرف الصحيح',
      scenarioImagePath: 'assets/images/level4/child_crying.png',
      scenarioPlaceholderColor: Color(0xFFE2E8F0),
      scenarioPlaceholderEmoji: '😢',
      options: [
        Level4Option(id: 'opt1_hug', title: 'احتضان الطفل', subtitle: 'التعاطف مع صديقنا ومواساته', imagePath: 'assets/images/level4/action_hug.png', isCorrect: true, placeholderColor: Color(0xFFE8F5E9), placeholderEmoji: '🤗'),
        Level4Option(id: 'opt1_toy', title: 'إعطاء لعبة', subtitle: 'نلعب معه لكي لا يشعر بالحزن', imagePath: 'assets/images/level4/action_toy.png', isCorrect: false, placeholderColor: Color(0xFFFFF3E0), placeholderEmoji: '🧸'),
        Level4Option(id: 'opt1_scream', title: 'الصراخ بصوت عالي', subtitle: 'الابتعاد عنه وتركه وحيداً', imagePath: 'assets/images/level4/action_scream.png', isCorrect: false, placeholderColor: Color(0xFFFFEBEE), placeholderEmoji: '📢'),
      ],
    ),
    // Activity 2: Understanding Needs
    const Level4Task(
      id: 'understanding_needs',
      title: 'نشاط المشاعر - طفل جائع',
      question: 'صديقنا يشعر بالجوع، ماذا يحتاج؟',
      scenarioImagePath: 'assets/images/level4/child_hungry.png',
      scenarioPlaceholderColor: Color(0xFFFFF3E0),
      scenarioPlaceholderEmoji: '🤤',
      options: [
        Level4Option(id: 'opt2_food', title: 'طعام شهى', subtitle: 'الطعام يمد الجسم بالطاقة', imagePath: 'assets/images/level4/item_food.png', isCorrect: true, placeholderColor: Color(0xFFE8F5E9), placeholderEmoji: '🍲'),
        Level4Option(id: 'opt2_brush', title: 'فرشاة أسنان', subtitle: 'تنظيف الأسنان مهم بعد الأكل', imagePath: 'assets/images/level4/item_toothbrush.png', isCorrect: false, placeholderColor: Color(0xFFE3F2FD), placeholderEmoji: '🪥'),
        Level4Option(id: 'opt2_ball', title: 'كرة اللعب', subtitle: 'اللعب ممتع ولكن ليس وقت الجوع', imagePath: 'assets/images/level4/item_ball.png', isCorrect: false, placeholderColor: Color(0xFFFCE4EC), placeholderEmoji: '⚽'),
      ],
    ),
    // Activity 3: Contextual Awareness
    const Level4Task(
      id: 'where_does_it_belong',
      title: 'نشاط أين يوجد؟',
      question: 'أين يوجد هذا الشيء؟',
      scenarioImagePath: 'assets/images/level4/object_bed.png',
      scenarioPlaceholderColor: Color(0xFFE3F2FD),
      scenarioPlaceholderEmoji: '🛏️',
      options: [
        Level4Option(id: 'opt3_bedroom', title: 'غرفة النوم', subtitle: 'المكان المخصص للنوم والراحة', imagePath: 'assets/images/level4/room_bedroom.png', isCorrect: true, placeholderColor: Color(0xFFE8F5E9), placeholderEmoji: '🚪'),
        Level4Option(id: 'opt3_kitchen', title: 'المطبخ', subtitle: 'المكان المخصص لإعداد الطعام', imagePath: 'assets/images/level4/room_kitchen.png', isCorrect: false, placeholderColor: Color(0xFFFFF3E0), placeholderEmoji: '🍳'),
        Level4Option(id: 'opt3_bathroom', title: 'الحمام', subtitle: 'المكان المخصص للنظافة الشخصية', imagePath: 'assets/images/level4/room_bathroom.png', isCorrect: false, placeholderColor: Color(0xFFE3F2FD), placeholderEmoji: '🛁'),
      ],
    ),
  ];

  void _onTaskCompleted() {
    if (_currentTaskIndex < _tasks.length - 1) {
      setState(() {
        _currentTaskIndex++;
      });
    } else {
      // Completed all tasks, return to main menu
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SocialSituationScreen(
      key: ValueKey(_currentTaskIndex),
      task: _tasks[_currentTaskIndex],
      onTaskCompleted: _onTaskCompleted,
    );
  }
}
