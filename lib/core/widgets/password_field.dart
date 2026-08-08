import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    required this.label,
    this.controller,
    this.showStrength = false,
    this.trailingLabel,
  });

  final String label;
  final TextEditingController? controller;
  final bool showStrength;
  final Widget? trailingLabel;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;
  int _strength = 0;

  void _computeStrength(String value) {
    int score = 0;
    if (value.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(value)) score++;
    if (RegExp(r'[0-9]').hasMatch(value)) score++;
    if (RegExp(r'[!@#\$&*~%]').hasMatch(value)) score++;
    setState(() => _strength = score);
  }

  Color get _strengthColor {
    if (_strength <= 1) return AppColors.danger;
    if (_strength <= 2) return AppColors.accent;
    return AppColors.success;
  }

  String get _strengthLabel {
    if (_strength == 0) return 'Entrez un mot de passe sécurisé';
    if (_strength <= 1) return 'Faible';
    if (_strength <= 2) return 'Moyen';
    if (_strength <= 3) return 'Bon';
    return 'Excellent';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.label,
                style: const TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
            if (widget.trailingLabel != null) widget.trailingLabel!,
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          onChanged: widget.showStrength ? _computeStrength : null,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.textSecondary, size: 20),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        if (widget.showStrength) ...[
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              4,
              (i) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                  height: 4,
                  decoration: BoxDecoration(
                    color: i < _strength ? _strengthColor : AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(_strengthLabel, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ],
      ],
    );
  }
}