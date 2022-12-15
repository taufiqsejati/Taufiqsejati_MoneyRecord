import 'package:flutter/material.dart';

class IncomeOutcomePage extends StatelessWidget {
  const IncomeOutcomePage({super.key, required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text(type)],
        ),
      ),
    );
  }
}
