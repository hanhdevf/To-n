import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/movies/domain/entities/genre.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_state.dart';

class SearchFilterBottomSheet extends StatelessWidget {
  final Genre? selectedGenre;
  final int? selectedYear;
  final String selectedSortBy;
  final List<int> years;
  final Map<String, String> sortOptions;
  final ValueChanged<Genre?> onGenreChanged;
  final ValueChanged<int?> onYearChanged;
  final ValueChanged<String> onSortChanged;
  final VoidCallback onReset;
  final VoidCallback onApply;
  final StateSetter setSheetState;

  const SearchFilterBottomSheet({
    super.key,
    required this.selectedGenre,
    required this.selectedYear,
    required this.selectedSortBy,
    required this.years,
    required this.sortOptions,
    required this.onGenreChanged,
    required this.onYearChanged,
    required this.onSortChanged,
    required this.onReset,
    required this.onApply,
    required this.setSheetState,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: AppTextStyles.h2),
              TextButton(
                onPressed: () {
                  onReset();
                  setSheetState(() {});
                  Navigator.pop(context);
                },
                child: const Text('Reset',
                    style: TextStyle(color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacing24),
          Text('Genres', style: AppTextStyles.h3),
          const SizedBox(height: AppDimens.spacing16),
          BlocBuilder<GenreBloc, GenreState>(
            builder: (context, state) {
              if (state is GenreLoaded) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: state.genres.map((genre) {
                    final isSelected = selectedGenre?.id == genre.id;
                    return FilterChip(
                      label: Text(genre.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        onGenreChanged(selected ? genre : null);
                        setSheetState(() {});
                      },
                      backgroundColor: AppColors.background,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                    );
                  }).toList(),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          const SizedBox(height: AppDimens.spacing24),
          Text('Release Year', style: AppTextStyles.h3),
          const SizedBox(height: AppDimens.spacing16),
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: years.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final year = years[index];
                final isSelected = selectedYear == year;
                return ChoiceChip(
                  label: Text(year.toString()),
                  selected: isSelected,
                  onSelected: (selected) {
                    onYearChanged(selected ? year : null);
                    setSheetState(() {});
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.background,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimens.spacing24),
          Text('Sort By', style: AppTextStyles.h3),
          const SizedBox(height: AppDimens.spacing16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sortOptions.entries.map((entry) {
              final isSelected = selectedSortBy == entry.value;
              return ChoiceChip(
                label: Text(entry.key),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onSortChanged(entry.value);
                    setSheetState(() {});
                  }
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.background,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimens.spacing32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onApply,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text('Apply Filters', style: AppTextStyles.button),
            ),
          ),
          const SizedBox(height: AppDimens.spacing24),
        ],
      ),
    );
  }
}
