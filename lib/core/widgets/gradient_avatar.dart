import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';

/// Avatar widget with gradient border
class GradientAvatar extends StatelessWidget {
  final String? photoUrl;
  final double size;
  final VoidCallback? onTap;

  const GradientAvatar({
    super.key,
    this.photoUrl,
    this.size = 40,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.secondary,
              Color(0xFFE91E63), // Pink
            ],
          ),
        ),
        padding: const EdgeInsets.all(2), // Border thickness
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
            image: photoUrl != null
                ? DecorationImage(
                    image: NetworkImage(photoUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: photoUrl == null
              ? Icon(
                  Icons.person_outline,
                  color: AppColors.white,
                  size: size * 0.5,
                )
              : null,
        ),
      ),
    );
  }
}
