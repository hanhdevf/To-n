import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/movies/domain/entities/genre.dart';

class GenreChipList extends StatelessWidget {
  final List<Genre> genres;
  final Genre? selectedGenre;
  final Function(Genre) onGenreTap;

  const GenreChipList({
    super.key,
    required this.genres,
    required this.onGenreTap,
    this.selectedGenre,
  });

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
        itemCount: genres.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: AppDimens.spacing8),
        itemBuilder: (context, index) {
          final genre = genres[index];
          final isSelected = selectedGenre?.id == genre.id;

          return _buildChip(genre, isSelected);
        },
      ),
    );
  }

  Widget _buildChip(Genre genre, bool isSelected) {
    return InkWell(
      onTap: () => onGenreTap(genre),
      borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spacing16,
          vertical: AppDimens.spacing8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.background.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.white.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          genre.name,
          style: AppTextStyles.body2Medium.copyWith(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
