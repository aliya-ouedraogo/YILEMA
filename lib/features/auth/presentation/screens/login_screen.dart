import 'package:flutter/foundation.dart';
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
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final auth = context.read<AuthProvider>();
    await auth.login(_emailController.text.trim(), _passwordController.text);
    // Pas besoin de naviguer manuellement : la redirection dans app_router.dart
    // s'en charge automatiquement dès que le statut passe à "authenticated".
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
              const SizedBox(height: 24),
              const Text("S'IDENTIFIER",
                  style: TextStyle(
                      color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 26)),
              const SizedBox(height: 8),
              const Text('Heureux de vous revoir ! Accédez à vos films préférés.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const SizedBox(height: 28),
              CustomTextField(
                label: 'Email ou numéro de téléphone',
                hint: 'nom@exemple.bf',
                icon: Icons.person_outline,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              PasswordField(
                label: 'Mot de passe',
                controller: _passwordController,
                trailingLabel: TextButton(
                  onPressed: () {
                    // TODO: écran mot de passe oublié
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                  child: const Text('Mot de passe oublié ?',
                      style: TextStyle(color: AppColors.accent, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: AppColors.accent,
                    onChanged: (v) => setState(() => _rememberMe = v ?? false),
                  ),
                  const Text('Se souvenir de moi',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                ],
              ),
              if (auth.errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(auth.errorMessage!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
              ],
              const SizedBox(height: 16),
              PrimaryButton(label: 'Se connecter', onPressed: _handleLogin, isLoading: auth.isLoading),
              if (kDebugMode) ...[
                const SizedBox(height: 12),
                Center(
                  child: TextButton(
                    onPressed: () => context.read<AuthProvider>().debugSkipLogin(),
                    child: const Text('🛠 Mode démo (sans backend)',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const AuthDivider(),
              const SizedBox(height: 20),
              const SocialAuthRow(),
              const SizedBox(height: 28),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    children: [
                      const TextSpan(text: 'Nouveau sur Yilema ? '),
                      TextSpan(
                        text: "S'inscrire maintenant.",
                        style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()..onTap = () => context.go('/register'),
                      ),
                    ],
                  ),
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
