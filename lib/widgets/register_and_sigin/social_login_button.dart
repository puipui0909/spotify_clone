import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {

  const SocialLoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent
            ),
            onPressed: (){},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/images/google_icon.png',
                height: 40,
                width: 40,
                fit: BoxFit.cover,),
            )
        ),
        SizedBox(width: 15,),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent
            ),
            onPressed: (){},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/images/apple_icon.jpg',
                height: 40,
                width: 40,
                fit: BoxFit.cover,),
            )
        )
      ],
    );
  }
}
