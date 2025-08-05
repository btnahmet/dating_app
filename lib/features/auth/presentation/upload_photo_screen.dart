import 'dart:io';

import 'package:dating_app/core/services/logger_service.dart';
import 'package:dating_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:dating_app/l10n/app_localizations.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  XFile? _selectedImage;

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final picked = await picker.pickImage(source: ImageSource.gallery);
  //   if (picked != null) {
  //     setState(() => _selectedImage = picked);
  //   }
  // }
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
                text: l10n.continueButton,
                // onTap: () => context.go('/home'),
                 onTap: () {
                  LoggerService.log('Continue tapped, navigating to /home');
                  context.go('/home');
                },
              ),
              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
