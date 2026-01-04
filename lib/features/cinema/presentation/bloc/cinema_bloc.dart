import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/features/cinema/domain/usecases/get_nearby_cinemas.dart';
import 'package:galaxymob/features/cinema/domain/usecases/get_showtimes.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_event.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_state.dart';

/// BLoC for handling cinema logic
class CinemaBloc extends Bloc<CinemaEvent, CinemaState> {
  final GetNearbyCinemas getNearbyCinemas;
  final GetShowtimes getShowtimes;

  CinemaBloc({
    required this.getNearbyCinemas,
    required this.getShowtimes,
  }) : super(const CinemaInitial()) {
    on<LoadNearbyCinemasEvent>(_onLoadNearbyCinemas);
    on<LoadShowtimesEvent>(_onLoadShowtimes);
    on<LoadScheduleEvent>(_onLoadSchedule);
  }

  Future<void> _onLoadNearbyCinemas(
    LoadNearbyCinemasEvent event,
    Emitter<CinemaState> emit,
  ) async {
    emit(const CinemaLoading());

    final result = await getNearbyCinemas(
      LocationParams(
        latitude: event.latitude,
        longitude: event.longitude,
      ),
    );

    result.fold(
      (failure) => emit(CinemaError(failure.message)),
      (cinemas) => emit(CinemasLoaded(cinemas)),
    );
  }

  Future<void> _onLoadShowtimes(
    LoadShowtimesEvent event,
    Emitter<CinemaState> emit,
  ) async {
    emit(const CinemaLoading());

    // First get cinemas
    final cinemasResult = await getNearbyCinemas(const LocationParams());

    await cinemasResult.fold(
      (failure) async => emit(CinemaError(failure.message)),
      (cinemas) async {
        // Then get showtimes
        final showtimesResult = await getShowtimes(
          ShowtimeParams(movieId: event.movieId, date: event.date),
        );

        showtimesResult.fold(
          (failure) => emit(CinemaError(failure.message)),
          (showtimes) => emit(ShowtimesLoaded(
            showtimesByCinema: showtimes,
            cinemas: cinemas,
          )),
        );
      },
    );
  }

  Future<void> _onLoadSchedule(
    LoadScheduleEvent event,
    Emitter<CinemaState> emit,
  ) async {
    emit(const CinemaLoading());

    // TODO: Implement proper repository method to get all showtimes by date
    // For now, emit empty schedule as MVP
    // In production, this would call a new use case: GetAllShowtimesByDate
    emit(ScheduleLoaded(
      showtimesByMovie: const {},
      date: event.date,
    ));
  }
}
