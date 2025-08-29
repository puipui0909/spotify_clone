import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AuthRedirectText extends StatelessWidget {
  final String type;
  final String? text;
  final String? actionText;
  final VoidCallback? onTap;

  const AuthRedirectText({
    super.key,
    required this.type,
    this.text,
    this.actionText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
        children: [
          if(type == 'register')...[
            TextSpan(text: 'Do You Have An Account? '),
            TextSpan(
              text: 'Login',
              style: const TextStyle(color: Colors.green),
              recognizer: TapGestureRecognizer()
                ..onTap = (){
                  Navigator.pushNamed(context, '/signin');
                },
            ),
          ]
          else ...[
            TextSpan(text: 'Not A Member? '),
            TextSpan(
              text: 'Register Now',
              style: const TextStyle(color: Colors.green),
              recognizer: TapGestureRecognizer()
                ..onTap = (){
                  Navigator.pushNamed(context, '/register');
                },
            ),
          ]
        ],
      ),
    );
  }
}
