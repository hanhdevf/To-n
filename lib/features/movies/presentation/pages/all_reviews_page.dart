import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/movies/domain/entities/review.dart';
import 'package:galaxymob/features/movies/presentation/widgets/reviews/review_item.dart';
import 'package:galaxymob/features/movies/presentation/widgets/reviews/review_summary.dart';
import 'package:galaxymob/features/movies/presentation/widgets/write_review_bottom_sheet.dart';

class AllReviewsPage extends StatefulWidget {
  final List<Review> reviews;
  final String movieTitle;

  const AllReviewsPage({
    super.key,
    required this.reviews,
    required this.movieTitle,
  });

  @override
  State<AllReviewsPage> createState() => _AllReviewsPageState();
}

class _AllReviewsPageState extends State<AllReviewsPage> {
  final Set<String> _likedReviews = {};
  final Set<String> _dislikedReviews = {};

  @override
  Widget build(BuildContext context) {
    double averageRating = 0;
    int ratedCount = 0;
    final Map<int, int> ratingCounts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var review in widget.reviews) {
      if (review.rating != null) {
        averageRating += review.rating!;
        ratedCount++;
        int star = (review.rating! / 2).round();
        if (star < 1) star = 1;
        if (star > 5) star = 5;
        ratingCounts[star] = (ratingCounts[star] ?? 0) + 1;
      }
    }
    if (ratedCount > 0) {
      averageRating = averageRating / ratedCount;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Reviews', style: AppTextStyles.h2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => WriteReviewBottomSheet(
              movieTitle: widget.movieTitle,
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit, color: Colors.white),
        label:
            const Text('Write Review', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          ReviewSummary(
            averageRating: averageRating,
            totalReviews: widget.reviews.length,
            ratedCount: ratedCount,
            ratingCounts: ratingCounts,
          ),
          SizedBox(height: AppDimens.spacing16),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
              itemCount: widget.reviews.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: AppDimens.spacing16),
              itemBuilder: (context, index) {
                final review = widget.reviews[index];
                return ReviewItem(
                  review: review,
                  isLiked: _likedReviews.contains(review.id),
                  isDisliked: _dislikedReviews.contains(review.id),
                  onLike: () {
                    setState(() {
                      if (_likedReviews.contains(review.id)) {
                        _likedReviews.remove(review.id);
                      } else {
                        _likedReviews.add(review.id);
                        _dislikedReviews.remove(review.id);
                      }
                    });
                  },
                  onDislike: () {
                    setState(() {
                      if (_dislikedReviews.contains(review.id)) {
                        _dislikedReviews.remove(review.id);
                      } else {
                        _dislikedReviews.add(review.id);
                        _likedReviews.remove(review.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
