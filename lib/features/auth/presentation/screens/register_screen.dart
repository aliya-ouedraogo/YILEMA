import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/auth_divider.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/password_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/social_auth_row.dart';
import '../../../../core/widgets/step_indicator.dart';
import '../../providers/auth_provider.dart';

/// Étape 1 ("Info") du tunnel d'inscription en 3 étapes : Info -> Plan -> Pay.
/// Les étapes Plan et Pay seront branchées par l'équipe subscription-profile
/// (Fadila) une fois son écran d'abonnement prêt -- elle peut réutiliser
/// StepIndicator tel quel avec currentStep: 1 puis 2.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleContinue() async {
    // TODO: une fois l'étape "Plan" prête, ce bouton doit y naviguer
    // (context.go('/register/plan')) au lieu de créer le compte directement.
    final auth = context.read<AuthProvider>();
    await auth.register(
      nom: _nameController.text.trim(),
      email: _emailController.text.trim(),
      motDePasse: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const StepIndicator(steps: ['Info', 'Plan', 'Pay'], currentStep: 0),
              const SizedBox(height: 24),
              const Text('CRÉER VOTRE COMPTE',
                  style: TextStyle(
                      color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 8),
              const Text('Commencez votre voyage cinématographique burkinabè aujourd\'hui.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 28),
              CustomTextField(
                label: 'Nom Complet',
                hint: 'Fatimata Traoré',
                icon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Email',
                hint: 'nom@exemple.bf',
                icon: Icons.mail_outline,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const Text('Téléphone',
                  style: TextStyle(
                      color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    decoration:
                        BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10)),
                    child: const Text('🇧🇫 +226', style: TextStyle(color: AppColors.textPrimary)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: '00 00 00 00',
                        suffixIcon: Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              PasswordField(label: 'Mot de passe', controller: _passwordController, showStrength: true),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(auth.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
              ],
              const SizedBox(height: 24),
              const AuthDivider(),
              const SizedBox(height: 20),
              const SocialAuthRow(),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Continuer',
                onPressed: _handleContinue,
                isLoading: auth.isLoading,
                trailingIcon: Icons.arrow_forward,
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    children: [
                      const TextSpan(text: 'Vous avez déjà un compte ? '),
                      TextSpan(
                        text: 'Se connecter.',
                        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () => context.go('/login'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text.rich(
                  TextSpan(
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    children: [
                      const TextSpan(text: 'En continuant, vous acceptez nos '),
                      TextSpan(
                          text: "Conditions d'Utilisation",
                          style: TextStyle(
                              color: AppColors.textPrimary, decoration: TextDecoration.underline)),
                      const TextSpan(text: ' et notre '),
                      TextSpan(
                          text: 'Politique de Confidentialité.',
                          style: TextStyle(
                              color: AppColors.textPrimary, decoration: TextDecoration.underline)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
