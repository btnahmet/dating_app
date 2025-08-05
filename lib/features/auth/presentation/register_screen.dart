import 'package:dating_app/core/services/api_service.dart';
import 'package:dating_app/core/services/logger_service.dart';
import 'package:dating_app/core/services/analytics_service.dart';
import 'package:dating_app/widgets/custom_button.dart';
import 'package:dating_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dating_app/l10n/app_localizations.dart';

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
      await _apiService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      LoggerService.log('Kayıt başarılı!');
      
      // Analytics event'i gönder
      await AnalyticsService.logRegister();
      await AnalyticsService.setUserProperties(
        userEmail: _emailController.text,
      );
      
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.06,
            vertical: height * 0.02,
          ),
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
              SizedBox(height: height * 0.01),
              Text(
                // l10n.description,
                'Tempus varius a vitae interdum id tortor elementum tristique eleifend at.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: height * 0.04),
              CustomTextField(
                hintText: l10n.nameSurname,
                prefixIcon: Icons.person_outline,
                controller: _nameController,
              ),
              SizedBox(height: height * 0.02),
              CustomTextField(
                hintText: l10n.email,
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: height * 0.02),
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
              SizedBox(height: height * 0.02),
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
              SizedBox(height: height * 0.03),
              CustomButton(
                text: _isLoading ? l10n.registering : l10n.register,
                onTap: _isLoading ? null : () => _register(),
              ),
              SizedBox(height: height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialIcon(icon: Icons.g_mobiledata),
                  SizedBox(width: width * 0.04),
                  SocialIcon(icon: Icons.apple),
                  SizedBox(width: width * 0.04),
                  SocialIcon(icon: Icons.facebook),
                ],
              ),
              SizedBox(height: height * 0.03),
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
    final width = MediaQuery.of(context).size.width;
    return CircleAvatar(
      radius: width * 0.055,
      backgroundColor: const Color(0xFF1F1F1F),
      child: Icon(icon, color: Colors.white, size: width * 0.06),
    );
  }
}
