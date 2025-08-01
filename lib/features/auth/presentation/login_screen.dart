import 'package:dating_app/core/services/api_service.dart';
import 'package:dating_app/core/services/token_storage_service.dart';
import 'package:dating_app/widgets/custom_button.dart';
import 'package:dating_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('E-posta ve şifre gerekli')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('Login işlemi başlatılıyor...');
      final response = await _apiService.login(
        _emailController.text,
        _passwordController.text,
      );
      
      print('Login başarılı, token alınıyor...');
      print('Response yapısı: $response');
      Map<String, dynamic> data;
      try {
        data = Map<String, dynamic>.from(response['data']);
      } catch (e) {
        print('Data cast hatası: $e');
        throw Exception('Response data map cast edilemedi: $e');
      }
      print('Response data: $data');
      print('Response data token: ${data['token']}');
      
      // Token'ı al ve kaydet
      if (data['token'] != null) {
        final token = data['token'];
        await _tokenStorage.saveToken(token);
        print('Token kaydedildi: $token');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Giriş başarılı!')),
          );
          context.go('/home');
        }
      } else {
        print('Token bulunamadı - Data: $data');
        throw Exception('Token alınamadı - Response: $response');
      }
    } catch (e) {
      print('Login hatası: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş başarısız: $e')),
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.15),
              Text(
                'Merhabalar',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tempus varius a vitae interdum id tortor elementum tristique eleifend at.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              CustomTextField(
                hintText: 'E-Posta',
                prefixIcon: Icons.email_outlined,
                controller: _emailController,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: 'Şifre',
                prefixIcon: Icons.lock_outline,
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Şifremi unuttum'),
                ),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: _isLoading ? 'Giriş Yapılıyor...' : 'Giriş Yap',
                onTap: _isLoading ? null : () => _login(),
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
                  const Text('Bir hesabın yok mu? '),
                  GestureDetector(
                    onTap: () => context.push('/register'),
                    child: const Text(
                      'Kayıt Ol!',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
