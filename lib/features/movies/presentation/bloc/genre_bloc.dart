import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_genres.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_state.dart';
import 'package:galaxymob/core/usecase/usecase.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  final GetGenres getGenres;

  GenreBloc({required this.getGenres}) : super(const GenreInitial()) {
    on<LoadGenresEvent>(_onLoadGenres);
  }

  Future<void> _onLoadGenres(
    LoadGenresEvent event,
    Emitter<GenreState> emit,
  ) async {
    emit(const GenreLoading());

    final result = await getGenres(NoParams());

    result.fold(
      (failure) => emit(GenreError(failure.message)),
      (genres) => emit(GenreLoaded(genres)),
    );
  }
}
