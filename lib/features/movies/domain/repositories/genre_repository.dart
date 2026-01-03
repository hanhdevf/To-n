import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/movies/domain/entities/genre.dart';

abstract class GenreRepository {
  Future<Either<Failure, List<Genre>>> getGenres();
}
