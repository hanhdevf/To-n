import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/core/widgets/glass_header.dart';
import 'package:galaxymob/core/widgets/section_header.dart';
import 'package:galaxymob/core/widgets/shimmer_loading.dart';
import 'package:galaxymob/core/widgets/movie_card.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/domain/entities/genre.dart';
import 'package:galaxymob/features/home/presentation/widgets/promo_banner.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_state.dart';
import 'package:galaxymob/features/movies/presentation/widgets/hero_banner.dart';
import 'package:galaxymob/features/movies/presentation/widgets/genre_chip_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<MovieBloc>()
            ..add(const LoadNowPlayingEvent())
            ..add(const LoadTrendingEvent())
            ..add(const LoadUpcomingEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<GenreBloc>()..add(const LoadGenresEvent()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  // Local state for UI
  Genre? _selectedGenre;

  // Movie Lists
  List<Movie> _nowPlaying = [];
  List<Movie> _trending = [];
  List<Movie> _upcoming = [];

  // Loading States
  bool _loadingNowPlaying = true;
  bool _loadingTrending = true;
  bool _loadingUpcoming = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is NowPlayingLoaded) {
            setState(() {
              _nowPlaying = state.movies;
              _loadingNowPlaying = false;
            });
          } else if (state is TrendingLoaded) {
            setState(() {
              _trending = state.movies;
              _loadingTrending = false;
            });
          } else if (state is UpcomingLoaded) {
            setState(() {
              _upcoming = state.movies;
              _loadingUpcoming = false;
            });
          } else if (state is MovieError) {
            // Stop all loaders on error to avoid infinite shimmer
            setState(() {
              _loadingNowPlaying = false;
              _loadingTrending = false;
              _loadingUpcoming = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Stack(
          children: [
            // Main Content
            RefreshIndicator(
              onRefresh: () async {
                final movieBloc = context.read<MovieBloc>();
                final genreBloc = context.read<GenreBloc>();

                movieBloc.add(const LoadNowPlayingEvent());
                movieBloc.add(const LoadTrendingEvent());
                movieBloc.add(const LoadUpcomingEvent());
                genreBloc.add(const LoadGenresEvent());
              },
              child: CustomScrollView(
                slivers: [
                  // 1. Hero Banner (Immersive)
                  SliverToBoxAdapter(
                    child: _buildHeroSection(),
                  ),

                  // 2. Genre List
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.spacing24),
                      child: BlocBuilder<GenreBloc, GenreState>(
                        builder: (context, state) {
                          if (state is GenreLoaded) {
                            return GenreChipList(
                              genres: state.genres,
                              selectedGenre: _selectedGenre,
                              onGenreTap: (genre) {
                                setState(() {
                                  _selectedGenre = genre;
                                });
                                // Navigation to genre specific page or filter logic here
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),

                  // 3. Trending Movies (Large Cards)
                  SliverToBoxAdapter(
                    child: _buildSection(
                      title: 'Trending This Week',
                      movies: _trending,
                      isLoading: _loadingTrending,
                      isLarge: true,
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppDimens.spacing24),
                  ),

                  // 4. Now Playing
                  SliverToBoxAdapter(
                    child: _buildSection(
                      title: 'Now Playing',
                      movies: _nowPlaying,
                      isLoading: _loadingNowPlaying,
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppDimens.spacing24),
                  ),

                  // 5. Promo Banner
                  const SliverToBoxAdapter(
                    child: PromoBanner(),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppDimens.spacing24),
                  ),

                  // 6. Coming Soon
                  SliverToBoxAdapter(
                    child: _buildSection(
                      title: 'Coming Soon',
                      movies: _upcoming,
                      isLoading: _loadingUpcoming,
                    ),
                  ),

                  // 8. Bottom Padding
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
            ),

            // Floating Glass Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: GlassHeader(
                onNotificationTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications coming soon!')),
                  );
                },
                onProfileTap: () => debugPrint('Profile Tapped'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    if (_loadingNowPlaying && _nowPlaying.isEmpty) {
      return ShimmerLoading(
        child: ShimmerBox(
          width: double.infinity,
          height: AppDimens.heroBannerHeight + 50, // Account for header offset
          borderRadius: BorderRadius.zero,
        ),
      );
    }

    // Use top 5 now playing movies for Hero
    final heroMovies = _nowPlaying.take(5).toList();

    return HeroBanner(
      movies: heroMovies,
      onMovieTap: (movie) => context.push('/movie/${movie.id}'),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Movie> movies,
    required bool isLoading,
    bool isLarge = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          actionText: 'See All',
          onActionTap: () {}, // Implementation pending
        ),
        SizedBox(height: AppDimens.spacing12),
        if (isLoading)
          _buildShimmerList(isLarge)
        else if (movies.isEmpty)
          const Padding(
            padding: EdgeInsets.all(AppDimens.spacing16),
            child: Text('No movies available'),
          )
        else
          SizedBox(
            height: isLarge ? 280 : 250, // Height check
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
              itemCount: movies.length,
              separatorBuilder: (context, index) =>
                  SizedBox(width: AppDimens.spacing12),
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(
                  title: movie.title,
                  posterPath: movie.fullPosterPath,
                  rating: movie.voteAverage,
                  onTap: () => context.push('/movie/${movie.id}'),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildShimmerList(bool isLarge) {
    return SizedBox(
      height: isLarge ? 280 : 250,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: AppDimens.spacing12),
        itemBuilder: (_, __) => ShimmerLoading(
          child: ShimmerBox(
            width: AppDimens.movieCardWidth,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
