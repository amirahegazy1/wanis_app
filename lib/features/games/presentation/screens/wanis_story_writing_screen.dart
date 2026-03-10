import 'package:flutter/material.dart';

class WanisStoryWritingScreen extends StatelessWidget {
  const WanisStoryWritingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('ونيس يكتب...'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text(
              'ونيس يقوم بتأليف قصة خصيصاً لك...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
