import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/features/home/presentation/widgets/grid_movie_card.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';

/// Reusable grid widget for displaying movies in a 2-column grid
class MovieListGrid extends StatelessWidget {
  final List<Movie> movies;

  const MovieListGrid({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(AppDimens.spacing16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppDimens.spacing16,
        mainAxisSpacing: AppDimens.spacing16,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GridMovieCard(
          movie: movie,
          onTap: () => context.push('/movie/${movie.id}'),
        );
      },
    );
  }
}
