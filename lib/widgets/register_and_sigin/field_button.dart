import 'package:flutter/material.dart';

class FieldButton extends StatelessWidget{
  final String type;
  final Future<void> Function()? action;

  const FieldButton({
    super.key,
    required this.type,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: action,
        style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: Size(332, 80),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25)
            )
        ),
        child: Text(
          type == 'sign in' ? 'Sign In' : 'Create Account',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),));
  }

}