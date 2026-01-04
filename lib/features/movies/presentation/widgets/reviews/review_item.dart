import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/movies/domain/entities/review.dart';

class ReviewItem extends StatefulWidget {
  final Review review;
  final bool isLiked;
  final bool isDisliked;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const ReviewItem({
    super.key,
    required this.review,
    required this.isLiked,
    required this.isDisliked,
    required this.onLike,
    required this.onDislike,
  });

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {
  bool isExpanded = false;
  static const int characterLimit = 150;

  @override
  Widget build(BuildContext context) {
    final showReadMore = widget.review.content.length > characterLimit;
    final displayContent = (showReadMore && !isExpanded)
        ? '${widget.review.content.substring(0, characterLimit)}...'
        : widget.review.content;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(AppDimens.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                backgroundImage: widget.review.fullAvatarPath != null
                    ? CachedNetworkImageProvider(widget.review.fullAvatarPath!)
                    : null,
                child: widget.review.fullAvatarPath == null
                    ? Text(
                        widget.review.author.isNotEmpty
                            ? widget.review.author[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                            color: AppColors.primary, fontSize: 16),
                      )
                    : null,
              ),
              SizedBox(width: AppDimens.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.review.author,
                      style: AppTextStyles.body1Medium,
                    ),
                    SizedBox(height: 2),
                    if (widget.review.rating != null)
                      Row(
                        children: List.generate(5, (starIndex) {
                          return Icon(
                            starIndex < (widget.review.rating! / 2).round()
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColors.warning,
                            size: 12,
                          );
                        }),
                      ),
                  ],
                ),
              ),
              Text(
                _formatDate(widget.review.createdAt),
                style: AppTextStyles.caption,
              ),
            ],
          ),
          SizedBox(height: AppDimens.spacing12),
          Text(
            displayContent,
            style: AppTextStyles.body2,
          ),
          if (showReadMore)
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  isExpanded ? 'Read Less' : 'Read More',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          SizedBox(height: AppDimens.spacing16),
          Row(
            children: [
              _buildActionButton(
                icon: widget.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                label: 'Helpful',
                color:
                    widget.isLiked ? AppColors.primary : AppColors.textSecondary,
                onTap: widget.onLike,
              ),
              SizedBox(width: AppDimens.spacing16),
              _buildActionButton(
                icon: widget.isDisliked
                    ? Icons.thumb_down
                    : Icons.thumb_down_outlined,
                label: 'Not Helpful',
                color:
                    widget.isDisliked ? AppColors.error : AppColors.textSecondary,
                onTap: widget.onDislike,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }
}
