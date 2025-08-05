import 'package:dating_app/core/services/api_service.dart';
import 'package:dating_app/core/services/token_storage_service.dart';
import 'package:dating_app/core/services/analytics_service.dart';
import 'package:dating_app/widgets/custom_button.dart';
import 'package:dating_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dating_app/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final _apiService = ApiService();
  final _tokenStorage = TokenStorageService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.fillAllFields)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );

      Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);

      if (data['token'] != null) {
        final token = data['token'];
        await _tokenStorage.saveToken(token);

        // Analytics event'i gönder
        await AnalyticsService.logLogin();
        await AnalyticsService.setUserProperties(
          userId: data['id']?.toString(),
          userEmail: _emailController.text,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.loginSuccess)),
          );
          context.go('/home');
        }
      } else {
        throw Exception('Token not found');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.loginFailed}: $e')),
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
            vertical: height * 0.04,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.15),
              Text(
                l10n.helloTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                l10n.loginSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: height * 0.04),
              CustomTextField(
                hintText: l10n.email,
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
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

              SizedBox(height: height * 0.015),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: Text(l10n.forgotPassword),
                ),
              ),
              SizedBox(height: height * 0.015),
              CustomButton(
                text: _isLoading ? l10n.loggingIn : l10n.login,
                onTap: _isLoading ? null : () => _login(),
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
                  Text(l10n.noAccount),
                  GestureDetector(
                    onTap: () => context.push('/register'),
                    child: Text(
                      l10n.registerNow,
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
