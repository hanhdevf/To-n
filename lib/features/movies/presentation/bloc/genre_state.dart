import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/movies/domain/entities/genre.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object> get props => [];
}

class GenreInitial extends GenreState {
  const GenreInitial();
}

class GenreLoading extends GenreState {
  const GenreLoading();
}

class GenreLoaded extends GenreState {
  final List<Genre> genres;

  const GenreLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

class GenreError extends GenreState {
  final String message;

  const GenreError(this.message);

  @override
  List<Object> get props => [message];
}
