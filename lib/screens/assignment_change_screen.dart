import 'package:flutter/material.dart';

class AssignmentChangeScreen extends StatefulWidget{

  final Function(int, int, int, int) onPress;
  final int id;
  final bool visibility;


  const AssignmentChangeScreen({super.key, required this.onPress, required this.id, required this.visibility});

  @override
  State<AssignmentChangeScreen> createState() => AssignmentChangeScreenState();
}

class AssignmentChangeScreenState extends State<AssignmentChangeScreen> {

  double difficulty = 0.0;
  double priority = 0.0;
  int completionTime = 0;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool visibility = widget.visibility;

    return Visibility (
      visible: visibility,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text('Please input your preticted time of completion'),
            TextFormField(
              controller: textController,
              validator:(value) {
                if ( value != null && value.isNotEmpty && int.tryParse(value) == null) {
                  return "The value entered is not a number";
                }
                return null;
              },
            ),
            Text('Difficulty: ${difficulty.round()}'),
            Slider(
              value: difficulty,
              min: 0.0,
              max: 5.0,
              onChanged: (value) {
                setState(() {
                  difficulty = value;
                });
              },
            ),
            Text('Priority: ${priority.round()}'),
            Slider(
              value: priority,
              min: 0.0,
              max: 5.0,
              onChanged: (value) {
                setState(() {
                  priority = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: (() {
                if (_formKey.currentState!.validate()) {
                  widget.onPress(widget.id, difficulty.round(), priority.round(),textController.text.isEmpty ? 0: int.tryParse(textController.text)!);
                }
                _formKey.currentState?.reset();
                difficulty = 0.0;
                priority = 0.0;
                }
              ),
              child: Text('submit')
            )
          ],
        )
      )
    );
  }
}