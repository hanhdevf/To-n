import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/core/widgets/section_header.dart';
import 'package:galaxymob/core/widgets/shimmer_loading.dart';
import 'package:galaxymob/core/widgets/state_widgets.dart';
import 'package:galaxymob/features/home/presentation/widgets/timeline_movie_card.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';

class HomeNowPlayingSection extends StatelessWidget {
  final MovieSectionState nowPlaying;
  final Map<int, String> genreMap;
  final VoidCallback onRetry;
  final VoidCallback? onViewSchedule;

  const HomeNowPlayingSection({
    super.key,
    required this.nowPlaying,
    required this.genreMap,
    required this.onRetry,
    this.onViewSchedule,
  });

  bool _isLoading() =>
      (nowPlaying.status == LoadStatus.loading ||
          nowPlaying.status == LoadStatus.idle) &&
      nowPlaying.movies.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Now in Cinemas',
          actionText: 'View Schedule',
          onActionTap: onViewSchedule,
        ),
        SizedBox(height: AppDimens.spacing12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
          child: _isLoading()
              ? _buildShimmerSection(height: 140, count: 3)
              : nowPlaying.status == LoadStatus.failure &&
                      nowPlaying.movies.isEmpty
                  ? ErrorStateWidget(
                      title: 'Now playing unavailable',
                      message: nowPlaying.error ?? 'Could not load movies',
                      onRetry: onRetry,
                    )
                  : Column(
                      children: nowPlaying.movies.take(2).map((movie) {
                        return TimelineMovieCard(
                          movie: movie,
                          genresLabel: _getGenreString(movie.genreIds),
                          onTap: () => context.push('/movie/${movie.id}'),
                        );
                      }).toList(),
                    ),
        ),
      ],
    );
  }

  Widget _buildShimmerSection({double height = 200, int count = 1}) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spacing16),
          child: ShimmerLoading(
            child: ShimmerBox(
              width: double.infinity,
              height: height,
            ),
          ),
        ),
      ),
    );
  }

  String _getGenreString(List<int> ids) {
    if (ids.isEmpty || genreMap.isEmpty) return '';
    return ids
        .map((id) => genreMap[id])
        .where((name) => name != null)
        .take(2)
        .join(', ');
  }
}
