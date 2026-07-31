import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.surfaceElevated)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('OU CONTINUER AVEC',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11, letterSpacing: 0.5)),
        ),
        Expanded(child: Divider(color: AppColors.surfaceElevated)),
      ],
    );
  }
}