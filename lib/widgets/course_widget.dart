import 'package:flutter/material.dart';

class CourseWidget extends StatelessWidget {
  final int id;
  final String name;
  final VoidCallback _onPressed;
  const CourseWidget({super.key, required this.id, required this.name, required this._onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (_onPressed),
       child: Container(
        child: Text(name)
       )
    );
  }
}
