import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

class WriteReviewBottomSheet extends StatefulWidget {
  final String movieTitle;

  const WriteReviewBottomSheet({
    super.key,
    required this.movieTitle,
  });

  @override
  State<WriteReviewBottomSheet> createState() => _WriteReviewBottomSheetState();
}

class _WriteReviewBottomSheetState extends State<WriteReviewBottomSheet> {
  double _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine bottom padding (keyboard awareness is handled by showModalBottomSheet automatically usually,
    // but padding ensures content isn't flush with edge if keyboard isn't up)
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppDimens.spacing24,
        AppDimens.spacing24,
        AppDimens.spacing24,
        AppDimens.spacing24 + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimens.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Write a Review', style: AppTextStyles.h3),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: AppDimens.spacing16),

          // Rating Bar
          Center(
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: AppColors.warning,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
          ),
          SizedBox(height: AppDimens.spacing8),
          Center(
            child: Text(
              _rating > 0 ? '$_rating / 5.0' : 'Tap a star to rate',
              style: AppTextStyles.body2.copyWith(
                color:
                    _rating > 0 ? AppColors.warning : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: AppDimens.spacing24),

          // Review Text Field
          TextField(
            controller: _reviewController,
            maxLines: 5,
            style: AppTextStyles.body1.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Share your thoughts on ${widget.movieTitle}...',
              hintStyle:
                  AppTextStyles.body1.copyWith(color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(AppDimens.spacing16),
            ),
          ),
          SizedBox(height: AppDimens.spacing24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: AppDimens.buttonHeight,
            child: ElevatedButton(
              onPressed: (_rating > 0 && _reviewController.text.isNotEmpty)
                  ? () {
                      // Logic to submit review will go here (mock for now)
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Review submitted successfully!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  : null, // Disable if invalid
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                ),
                disabledBackgroundColor:
                    AppColors.primary.withValues(alpha: 0.3),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.5),
              ),
              child: Text('Submit Review', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }
}
