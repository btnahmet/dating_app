import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    
    return SizedBox(
      width: double.infinity,
      height: height * 0.06,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.03),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: width * 0.04,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
