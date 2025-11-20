import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "홈 페이지 - 간단한 메시지",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
