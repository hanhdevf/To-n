import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/core/widgets/movie_card.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';

class SearchResultsGrid extends StatelessWidget {
  final List<Movie> movies;

  const SearchResultsGrid({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(AppDimens.spacing16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppDimens.spacing16,
        crossAxisSpacing: AppDimens.spacing16,
        childAspectRatio: 0.65,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieCard(
          title: movie.title,
          posterPath: movie.fullPosterPath,
          rating: movie.voteAverage,
          onTap: () {
            context.push('/movie/${movie.id}');
          },
        );
      },
    );
  }
}
