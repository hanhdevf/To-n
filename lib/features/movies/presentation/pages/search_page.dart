import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/core/widgets/widgets.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';

/// Search page for finding movies
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus on search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      context.read<MovieBloc>().add(SearchMoviesEvent(query: query.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MovieBloc>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            style: AppTextStyles.body1,
            decoration: InputDecoration(
              hintText: 'Search movies...',
              hintStyle: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              border: InputBorder.none,
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (value) {
              setState(() {});
            },
            onSubmitted: _performSearch,
            textInputAction: TextInputAction.search,
          ),
        ),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieInitial || _searchController.text.isEmpty) {
              return _buildInitialState();
            } else if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SearchResultsLoaded) {
              if (state.movies.isEmpty) {
                return EmptyStateWidget(
                  icon: Icons.search_off,
                  title: 'No Results',
                  message: 'No movies found for "${state.query}"',
                );
              }
              return _buildSearchResults(state.movies);
            } else if (state is MovieError) {
              return ErrorStateWidget(
                title: 'Search Failed',
                message: state.message,
                onRetry: () {
                  if (_searchController.text.isNotEmpty) {
                    _performSearch(_searchController.text);
                  }
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          SizedBox(height: AppDimens.spacing16),
          Text(
            'Search for movies',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDimens.spacing8),
          Text(
            'Enter a movie title to search',
            style: AppTextStyles.body2,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List movies) {
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
