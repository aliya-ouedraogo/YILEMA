import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SocialAuthRow extends StatelessWidget {
  const SocialAuthRow({super.key, this.onGoogleTap, this.onFacebookTap});

  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _SocialButton(label: 'Google', icon: Icons.g_mobiledata, onTap: onGoogleTap)),
        const SizedBox(width: 12),
        Expanded(
            child:
                _SocialButton(label: 'Facebook', icon: Icons.facebook, onTap: onFacebookTap)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label, required this.icon, this.onTap});

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: AppColors.textPrimary, size: 20),
      label: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}