import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.surfaceElevated)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('OU CONTINUER AVEC',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11, letterSpacing: 0.5)),
        ),
        const Expanded(child: Divider(color: AppColors.surfaceElevated)),
      ],
    );
  }
}