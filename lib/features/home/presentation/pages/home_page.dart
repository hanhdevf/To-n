import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';

import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/core/widgets/section_header.dart';
import 'package:galaxymob/features/home/presentation/widgets/home_sliver_app_bar.dart';
import 'package:galaxymob/features/home/presentation/widgets/promo_banner.dart';
import 'package:galaxymob/features/home/presentation/widgets/sections/coming_soon_section.dart';
import 'package:galaxymob/features/home/presentation/widgets/sections/featured_section.dart';
import 'package:galaxymob/features/home/presentation/widgets/sections/now_playing_section.dart';
import 'package:galaxymob/features/home/presentation/widgets/sections/trending_section.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_state.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';

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
            ..add(const LoadUpcomingEvent())
            ..add(const LoadPopularEvent()),
        ),
        BlocProvider(
          create: (_) => getIt<GenreBloc>()..add(const LoadGenresEvent()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<GenreBloc, GenreState>(
        builder: (context, genreState) {
          final genreMap = genreState is GenreLoaded
              ? {for (var g in genreState.genres) g.id: g.name}
              : const <int, String>{};

          return BlocBuilder<MovieBloc, MovieState>(
            builder: (context, movieState) {
              return RefreshIndicator(
                onRefresh: () async {
                  final movieBloc = context.read<MovieBloc>();
                  final genreBloc = context.read<GenreBloc>();

                  movieBloc.add(const LoadNowPlayingEvent());
                  movieBloc.add(const LoadTrendingEvent());
                  movieBloc.add(const LoadUpcomingEvent());
                  movieBloc.add(const LoadPopularEvent());
                  genreBloc.add(const LoadGenresEvent());
                },
                edgeOffset: HomeSliverAppBar.expandedHeight - 100,
                child: CustomScrollView(
                  slivers: [
                    // New Collapsing SliverAppBar with Hero Banner
                    HomeSliverAppBar(
                      trending: movieState.trending,
                      onRetry: () => context
                          .read<MovieBloc>()
                          .add(const LoadTrendingEvent()),
                      onMovieTap: (movie) => context.push('/movie/${movie.id}'),
                      onNotificationTap: () {},
                      onProfileTap: () => context.go('/profile'),
                    ),
                    SliverToBoxAdapter(
                      child: HomeFeaturedSection(
                        popular: movieState.popular,
                        genreMap: genreMap,
                        onRetry: () => context
                            .read<MovieBloc>()
                            .add(const LoadPopularEvent()),
                        onTap: (movie) => context.push('/movie/${movie.id}'),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: HomeTrendingSection(
                        trending: movieState.trending,
                        genreMap: genreMap,
                        onRetry: () => context
                            .read<MovieBloc>()
                            .add(const LoadTrendingEvent()),
                        onTap: (movie) => context.push('/movie/${movie.id}'),
                        onViewAll: () => context.push(
                            '/movies/trending?title=${Uri.encodeComponent('Trending Now')}'),
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: AppDimens.spacing24)),
                    const SliverToBoxAdapter(
                      child: PromoBanner(),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: AppDimens.spacing24)),
                    SliverToBoxAdapter(
                      child: HomeNowPlayingSection(
                        nowPlaying: movieState.nowPlaying,
                        genreMap: genreMap,
                        onRetry: () => context
                            .read<MovieBloc>()
                            .add(const LoadNowPlayingEvent()),
                        onViewSchedule: () => context.push('/schedule'),
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: AppDimens.spacing8)),
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Coming Soon',
                        actionText: 'View All',
                        onActionTap: () => context.push(
                            '/movies/upcoming?title=${Uri.encodeComponent('Coming Soon')}'),
                        padding: const EdgeInsets.only(
                          left: AppDimens.spacing16,
                          right: AppDimens.spacing16,
                          bottom: AppDimens.spacing8,
                          top: 0,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(AppDimens.spacing16),
                      sliver: HomeComingSoonSection(
                        upcoming: movieState.upcoming,
                        onRetry: () => context
                            .read<MovieBloc>()
                            .add(const LoadUpcomingEvent()),
                        onTap: (id) => context.push('/movie/$id'),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
