import 'package:flutter/material.dart';

import '../../../../core/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPressed;
  const AuthGradientButton({super.key, required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Pallete.gradient1,
          Pallete.gradient2,
        ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(

        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(450, 60),
          backgroundColor: Pallete.transparentColor,
          shadowColor: Pallete.transparentColor,
        ),
        child:  Text(buttonText.toString(),style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),),
      ),
    );
  }
}
