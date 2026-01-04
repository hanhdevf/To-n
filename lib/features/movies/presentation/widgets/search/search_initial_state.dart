import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/movies/domain/entities/genre.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_state.dart';
import 'package:galaxymob/features/movies/presentation/widgets/genre_chip_list.dart';

class SearchInitialState extends StatelessWidget {
  final Genre? selectedGenre;
  final ValueChanged<Genre> onGenreTap;

  const SearchInitialState({
    super.key,
    required this.selectedGenre,
    required this.onGenreTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: AppDimens.spacing48),
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
            SizedBox(height: AppDimens.spacing32),
            BlocBuilder<GenreBloc, GenreState>(
              builder: (context, state) {
                if (state is GenreLoaded) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spacing16,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Browse by Genre',
                            style: AppTextStyles.h3,
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimens.spacing16),
                      GenreChipList(
                        genres: state.genres,
                        selectedGenre: selectedGenre,
                        onGenreTap: onGenreTap,
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
