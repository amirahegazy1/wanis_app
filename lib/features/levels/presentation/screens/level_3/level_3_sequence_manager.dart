import 'package:flutter/material.dart';
import '../../../domain/models/level3_task.dart';
import 'video_instruction_screen.dart';

class Level3SequenceManager extends StatefulWidget {
  const Level3SequenceManager({super.key});

  @override
  State<Level3SequenceManager> createState() => _Level3SequenceManagerState();
}

class _Level3SequenceManagerState extends State<Level3SequenceManager> {
  int _currentTaskIndex = 0;

  final List<Level3Task> _tasks = [
    const Level3Task(
      id: 'hand_washing',
      title: 'غسل اليدين',
      instructionTitle: 'شاهد خطوات غسل اليدين',
      instructionSubtitle: 'شاهد الفيديو ثم رتب الخطوات',
      videoPath: 'assets/videos/hand_wash.mp4',
      steps: [
        Level3Step(id: 'hw_1', title: 'فتح الماء 🚿', subtitle: '', image: 'assets/images/level3/hands_step1_water.png', correctIndex: 0),
        Level3Step(id: 'hw_2', title: 'وضع الصابون 🧼', subtitle: '', image: 'assets/images/level3/hands_step2_soap.png', correctIndex: 1),
        Level3Step(id: 'hw_3', title: 'فرك اليد 👋', subtitle: '', image: 'assets/images/level3/hands_step3_rubbing.png', correctIndex: 2),
        Level3Step(id: 'hw_4', title: 'شطف اليد 💧', subtitle: '', image: 'assets/images/level3/hands_step4_rinsing.png', correctIndex: 3),
      ],
    ),
    const Level3Task(
      id: 'brushing_teeth',
      title: 'تنظيف الأسنان',
      instructionTitle: 'شاهد خطوات تنظيف الأسنان',
      instructionSubtitle: 'شاهد الفيديو ثم رتب الخطوات',
      videoPath: 'assets/videos/brush_teeth.mp4',
      steps: [
        Level3Step(id: 'bt_1', title: 'وضع المعجون', subtitle: '', image: 'assets/images/level3/teeth_step1_paste.png', correctIndex: 0),
        Level3Step(id: 'bt_2', title: 'تفريش الأسنان', subtitle: '', image: 'assets/images/level3/teeth_step2_brushing.png', correctIndex: 1),
        Level3Step(id: 'bt_3', title: 'مضمضة', subtitle: '', image: 'assets/images/level3/teeth_step3_rinsing.png', correctIndex: 2),
        Level3Step(id: 'bt_4', title: 'غسل الفرشاة', subtitle: '', image: 'assets/images/level3/teeth_step4_washbrush.png', correctIndex: 3),
      ],
    ),
    const Level3Task(
      id: 'putting_on_shoes',
      title: 'لبس الحذاء',
      instructionTitle: 'شاهد خطوات لبس الحذاء',
      instructionSubtitle: 'شاهد الفيديو ثم رتب الخطوات',
      videoPath: 'assets/videos/wear_shoes.mp4',
      steps: [
        Level3Step(id: 'sh_1', title: 'إحضار الحذاء', subtitle: '', image: 'assets/images/level3/shoes_step1_get.png', correctIndex: 0),
        Level3Step(id: 'sh_2', title: 'لبس الجوارب', subtitle: '', image: 'assets/images/level3/shoes_step2_socks.png', correctIndex: 1),
        Level3Step(id: 'sh_3', title: 'إدخال القدم', subtitle: '', image: 'assets/images/level3/shoes_step3_insert.png', correctIndex: 2),
        Level3Step(id: 'sh_4', title: 'ربط الحذاء', subtitle: '', image: 'assets/images/level3/shoes_step4_tie.png', correctIndex: 3),
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
    // Show current task video instruction screen
    return VideoInstructionScreen(
      key: ValueKey(_currentTaskIndex),
      task: _tasks[_currentTaskIndex],
      onTaskCompleted: _onTaskCompleted,
    );
  }
}
