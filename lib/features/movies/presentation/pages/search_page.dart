import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/widgets/widgets.dart';
import 'package:galaxymob/features/movies/domain/entities/genre.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_bloc.dart';
import 'package:galaxymob/features/movies/presentation/widgets/search/search_filter_bottom_sheet.dart';
import 'package:galaxymob/features/movies/presentation/widgets/search/search_initial_state.dart';
import 'package:galaxymob/features/movies/presentation/widgets/search/search_results_grid.dart';

/// Search page for finding movies
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  Genre? _selectedGenre;
  int? _selectedYear;
  String _selectedSortBy = 'popularity.desc';

  final List<int> _years =
      List.generate(20, (index) => DateTime.now().year + 1 - index);

  final Map<String, String> _sortOptions = {
    'Most Popular': 'popularity.desc',
    'Least Popular': 'popularity.asc',
    'Newest First': 'primary_release_date.desc',
    'Oldest First': 'primary_release_date.asc',
    'Highest Rated': 'vote_average.desc',
    'Lowest Rated': 'vote_average.asc',
  };

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
    context.read<MovieBloc>().add(SearchMoviesEvent(
          query: query.trim(),
          genreId: _selectedGenre?.id,
          year: _selectedYear,
          sortBy: _selectedSortBy,
        ));
  }

  void _applyFilters() {
    _performSearch(_searchController.text);
    Navigator.pop(context);
  }

  void _showFilterBottomSheet() {
    // Capture the existing GenreBloc from the context to pass it to the bottom sheet
    // because showModalBottomSheet puts the widget in a different overlay context
    final genreBloc = context.read<GenreBloc>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => BlocProvider.value(
          value: genreBloc,
          child: StatefulBuilder(
            builder: (context, setSheetState) => SingleChildScrollView(
              controller: scrollController,
              child: SearchFilterBottomSheet(
                selectedGenre: _selectedGenre,
                selectedYear: _selectedYear,
                selectedSortBy: _selectedSortBy,
                years: _years,
                sortOptions: _sortOptions,
                onGenreChanged: (genre) {
                  setState(() {
                    _selectedGenre = genre;
                  });
                  setSheetState(() {});
                },
                onYearChanged: (year) {
                  setState(() {
                    _selectedYear = year;
                  });
                  setSheetState(() {});
                },
                onSortChanged: (sort) {
                  setState(() {
                    _selectedSortBy = sort;
                  });
                  setSheetState(() {});
                },
                onReset: () {
                  setState(() {
                    _selectedGenre = null;
                    _selectedYear = null;
                    _selectedSortBy = 'popularity.desc';
                  });
                  _performSearch(_searchController.text);
                },
                onApply: _applyFilters,
                setSheetState: setSheetState,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: _selectedGenre != null ||
                  _selectedYear != null ||
                  _selectedSortBy != 'popularity.desc',
              child: const Icon(Icons.tune),
            ),
            onPressed: _showFilterBottomSheet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          final hasQueryOrFilters = _searchController.text.isNotEmpty ||
              _selectedGenre != null ||
              _selectedYear != null ||
              _selectedSortBy != 'popularity.desc';

          if (!hasQueryOrFilters &&
              state.search.status == LoadStatus.idle &&
              state.search.results.isEmpty) {
            return _buildInitialState();
          }

          if (state.search.status == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.search.status == LoadStatus.success) {
            if (state.search.results.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.search_off,
                title: 'No Results',
                message: 'No movies found for "${state.search.query}"',
              );
            }
            return _buildSearchResults(state.search.results);
          }

          if (state.search.status == LoadStatus.failure) {
            return ErrorStateWidget(
              title: 'Search Failed',
              message: state.search.error ?? 'Unable to load results',
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
    );
  }

  Widget _buildInitialState() {
    return SearchInitialState(
      selectedGenre: _selectedGenre,
      onGenreTap: (genre) {
        setState(() {
          _selectedGenre = genre;
          _performSearch(_searchController.text);
        });
      },
    );
  }

  Widget _buildSearchResults(List<Movie> movies) {
    return SearchResultsGrid(movies: movies);
  }
}
