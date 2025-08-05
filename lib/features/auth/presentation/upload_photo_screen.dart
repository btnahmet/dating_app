import 'dart:io';

import 'package:dating_app/core/services/logger_service.dart';
import 'package:dating_app/core/services/api_service.dart';
import 'package:dating_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dating_app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  XFile? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      LoggerService.log('Picking image from gallery...');
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() => _selectedImage = picked);
        LoggerService.log('Image picked: ${picked.path}');
      } else {
        LoggerService.log('No image selected.');
      }
    } catch (e, s) {
      LoggerService.error('Image picking failed.', e, s);
    }
  }

  Future<void> _uploadPhoto() async {
    setState(() {
      _isUploading = true;
    });

    try {
      if (_selectedImage != null) {
        LoggerService.log('Uploading photo to API...');
        
        // Doğrudan API service kullanarak fotoğraf yükle
        final apiService = ApiService();
        await apiService.uploadPhoto(File(_selectedImage!.path));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.photoUploadSuccess)),
          );
        }
      } else {
        LoggerService.log('Fotoğraf seçilmedi, profil sayfasına yönlendiriliyor...');
      }
      
      if (mounted) {
        // Ana sayfaya git (fotoğraf yüklensin veya yüklenmesin)
        context.go('/home');
      }
    } catch (e) {
      LoggerService.error('Photo upload failed', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppLocalizations.of(context)!.photoUploadFailed}: $e')),
        );
        // Hata olsa bile ana sayfaya git
        context.go('/home');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
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
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.03),
              Row(
                children: [
                  CircleAvatar(
                    radius: width * 0.06,
                    backgroundColor: const Color(0xFF1F1F1F),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: width * 0.06),
                      onPressed: () {
                        LoggerService.log('Back button pressed.');
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  SizedBox(width: width * 0.03),
                  Transform.translate(
                    offset: Offset(width * 0.14, 0),
                    child: Text(
                      l10n.profileDetails,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.04),
              Text(
                l10n.uploadPhotos,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                "Resources out incentivize relaxation.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: height * 0.04),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: width * 0.3,
                  height: width * 0.3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                  child: _selectedImage == null
                      ? Icon(Icons.add, size: width * 0.1, color: Colors.white)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(width * 0.03),
                          child: Image.file(
                            File(_selectedImage!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const Spacer(),
                             CustomButton(
                 text: _isUploading ? 'Yükleniyor...' : 'Devam Et',
                 onTap: _isUploading ? null : _uploadPhoto,
               ),
              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
