import 'package:dating_app/core/services/api_service.dart';
import 'package:dating_app/core/services/logger_service.dart';
import 'package:dating_app/core/services/token_storage_service.dart';
import 'package:dating_app/widgets/custom_button.dart';
import 'package:dating_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureText = true;
  final _apiService = ApiService();
  final _tokenStorage = TokenStorageService();
  bool _isLoading = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final l10n = AppLocalizations.of(context)!;
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      LoggerService.log('Tüm alanlar doldurulmadı');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fillAllFields)),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      LoggerService.log('Şifreler uyuşmuyor');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.passwordsDoNotMatch)),
      );
      return;
    }

    if (!_acceptedTerms) {
      LoggerService.log('Kullanıcı sözleşmesi kabul edilmemiş');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.termsNotAccepted)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      LoggerService.log('Kayıt işlemi başlatılıyor...');
      final response = await _apiService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      LoggerService.log('Kayıt başarılı!');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.registrationSuccess)),
        );
        context.go('/upload-photo');
      }
    } catch (e, stackTrace) {
      LoggerService.error('Kayıt başarısız..', e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.registrationFailed}: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.08),
              Text(
                l10n.welcomeTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                // l10n.description,
                'Tempus varius a vitae interdum id tortor elementum tristique eleifend at.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                hintText: l10n.nameSurname,
                prefixIcon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: l10n.email,
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // CustomTextField(
              //   hintText: l10n.password,
              //   prefixIcon: Icons.lock_outline,
              //   isPassword: true,
              //   controller: _passwordController,
              // ),
               StatefulBuilder(
                builder: (context, setState) {

                  return CustomTextField(
                    hintText: l10n.password,
                    prefixIcon: Icons.lock_outline,
                    isPassword: _obscureText,
                    controller: _passwordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              // CustomTextField(
              //   hintText: l10n.confirmPassword,
              //   prefixIcon: Icons.lock_outline,
              //   isPassword: true,
              //   controller: _confirmPasswordController,
              // ),
               StatefulBuilder(
                builder: (context, setState) {

                  return CustomTextField(
                    hintText: l10n.confirmPassword,
                    prefixIcon: Icons.lock_outline,
                    isPassword: _obscureText,
                    controller: _confirmPasswordController,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _acceptedTerms = !_acceptedTerms;
                  });
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: _acceptedTerms,
                      onChanged: (value) {
                        setState(() {
                          _acceptedTerms = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        l10n.termsAgreementBold,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: _isLoading ? l10n.registering : l10n.register,
                onTap: _isLoading ? null : () => _register(),
              ),
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialIcon(icon: Icons.g_mobiledata),
                  SizedBox(width: 16),
                  SocialIcon(icon: Icons.apple),
                  SizedBox(width: 16),
                  SocialIcon(icon: Icons.facebook),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.alreadyHaveAccount),
                  GestureDetector(
                    onTap: () => context.push('/login'),
                    child: Text(
                      l10n.goLogin,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialIcon extends StatelessWidget {
  final IconData icon;
  const SocialIcon({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22,
      backgroundColor: const Color(0xFF1F1F1F),
      child: Icon(icon, color: Colors.white),
    );
  }
}
