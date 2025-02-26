import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SocialButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(22.5),
        ),
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          iconPath,
          color: Colors.white,
        ),
      ),
    );
  }
}