import 'package:flutter/material.dart';

class QuizButton extends StatelessWidget {
  final int index;
  final int length;
  final Function onPressed;
  final Function onSubmission;
  QuizButton({this.index, this.length, this.onPressed, this.onSubmission});

  @override
  Widget build(BuildContext context) {
    if (index + 1 < length) {
      return ElevatedButton(
        onPressed: onPressed,
        child: Text('Next'),
      );
    }
    return ElevatedButton(
      onPressed: onSubmission,
      child: Text('Submit'),
    );
  }
}
