import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/cinema/domain/entities/showtime.dart';
import 'package:galaxymob/features/cinema/domain/repositories/cinema_repository.dart';

/// Use case for getting showtimes
class GetShowtimes
    implements UseCase<Map<String, List<Showtime>>, ShowtimeParams> {
  final CinemaRepository repository;

  GetShowtimes(this.repository);

  @override
  Future<Either<Failure, Map<String, List<Showtime>>>> call(
      ShowtimeParams params) async {
    return await repository.getShowtimes(
      movieId: params.movieId,
      date: params.date,
    );
  }
}

/// Parameters for showtime queries
class ShowtimeParams extends Equatable {
  final int movieId;
  final DateTime date;

  const ShowtimeParams({
    required this.movieId,
    required this.date,
  });

  @override
  List<Object?> get props => [movieId, date];
}
