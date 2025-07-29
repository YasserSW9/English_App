import 'package:flutter/material.dart';

class LevelControlPanel extends StatelessWidget {
  const LevelControlPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A1B9A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A1B9A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Level control panel',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(child: Text("")),
    );
  }
}
