import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:galaxymob/core/network/api_client.dart';
import 'package:galaxymob/core/network/network_info.dart';
import 'package:galaxymob/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:galaxymob/features/auth/data/datasources/mock_auth_remote_data_source.dart';
import 'package:galaxymob/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:galaxymob/features/auth/domain/repositories/auth_repository.dart';
import 'package:galaxymob/features/auth/domain/usecases/get_current_user.dart';
import 'package:galaxymob/features/auth/domain/usecases/login_with_email.dart';
import 'package:galaxymob/features/auth/domain/usecases/logout.dart';
import 'package:galaxymob/features/auth/domain/usecases/register_with_email.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:galaxymob/features/movies/data/datasources/movie_remote_data_source.dart';
import 'package:galaxymob/features/movies/data/datasources/tmdb_api_service.dart';
import 'package:galaxymob/features/movies/data/repositories/movie_repository_impl.dart';
import 'package:galaxymob/features/movies/domain/repositories/movie_repository.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_movie_details.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_upcoming_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_trending_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/search_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_movie_credits.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_movie_reviews.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/data/repositories/genre_repository_impl.dart';
import 'package:galaxymob/features/movies/domain/repositories/genre_repository.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_genres.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_bloc.dart';
import 'package:galaxymob/features/cinema/data/datasources/mock_cinema_data_source.dart';
import 'package:galaxymob/features/cinema/data/repositories/cinema_repository_impl.dart';
import 'package:galaxymob/features/cinema/domain/repositories/cinema_repository.dart';
import 'package:galaxymob/features/cinema/domain/usecases/get_nearby_cinemas.dart';
import 'package:galaxymob/features/cinema/domain/usecases/get_showtimes.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_bloc.dart';
import 'package:galaxymob/features/booking/data/datasources/mock_seat_data_source.dart';
import 'package:galaxymob/features/booking/data/datasources/mock_booking_data_source.dart';
import 'package:galaxymob/features/booking/data/repositories/mock_payment_service.dart';
import 'package:galaxymob/features/booking/data/repositories/ticket_service_impl.dart';
import 'package:galaxymob/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:galaxymob/features/booking/data/repositories/seat_repository_impl.dart';
import 'package:galaxymob/features/booking/domain/repositories/payment_service.dart';
import 'package:galaxymob/features/booking/domain/repositories/ticket_service.dart';
import 'package:galaxymob/features/booking/domain/repositories/booking_repository.dart';
import 'package:galaxymob/features/booking/domain/repositories/seat_repository.dart';
import 'package:galaxymob/features/booking/domain/usecases/get_user_bookings.dart';
import 'package:galaxymob/features/booking/domain/usecases/cancel_booking.dart';
import 'package:galaxymob/features/booking/domain/usecases/get_user_tickets.dart';
import 'package:galaxymob/features/booking/domain/usecases/generate_ticket.dart';
import 'package:galaxymob/features/booking/domain/usecases/save_ticket.dart';
import 'package:galaxymob/features/booking/domain/usecases/delete_ticket.dart';
import 'package:galaxymob/features/booking/domain/usecases/get_seat_layout.dart';
import 'package:galaxymob/features/booking/domain/usecases/initiate_payment.dart';
import 'package:galaxymob/features/booking/domain/usecases/verify_payment.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Core dependencies
  final dio = ApiClient().dio;
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );

  // SharedPreferences (async)
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Auth data sources
  getIt.registerLazySingleton<MockAuthRemoteDataSource>(
    () => MockAuthRemoteDataSource(),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSource(getIt<SharedPreferences>()),
  );

  // Auth repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<MockAuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // Auth use cases
  getIt.registerLazySingleton(() => LoginWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => Logout(getIt<AuthRepository>()));

  // Auth BLoC
  getIt.registerFactory(
    () => AuthBloc(
      loginWithEmail: getIt<LoginWithEmail>(),
      registerWithEmail: getIt<RegisterWithEmail>(),
      getCurrentUser: getIt<GetCurrentUser>(),
      logout: getIt<Logout>(),
    ),
  );

  // Movie data sources
  getIt.registerLazySingleton<TmdbApiService>(
    () => TmdbApiService(dio),
  );
  getIt.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSource(
      getIt<TmdbApiService>(),
      getIt<NetworkInfo>(),
    ),
  );

  // Movie repository
  getIt.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: getIt<MovieRemoteDataSource>(),
    ),
  );

  // Genre repository
  getIt.registerLazySingleton<GenreRepository>(
    () => GenreRepositoryImpl(
      getIt<TmdbApiService>(),
    ),
  );

  // Movie use cases
  getIt.registerLazySingleton(
      () => GetNowPlayingMovies(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => GetPopularMovies(getIt<MovieRepository>()));
  getIt
      .registerLazySingleton(() => GetUpcomingMovies(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => GetMovieDetails(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => SearchMovies(getIt<MovieRepository>()));
  getIt
      .registerLazySingleton(() => GetTrendingMovies(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => GetMovieCredits(getIt<MovieRepository>()));
  getIt.registerLazySingleton(() => GetMovieReviews(getIt<MovieRepository>()));

  // Genre use cases
  getIt.registerLazySingleton(() => GetGenres(getIt<GenreRepository>()));

  // Movie BLoC
  getIt.registerFactory(
    () => MovieBloc(
      getNowPlayingMovies: getIt<GetNowPlayingMovies>(),
      getPopularMovies: getIt<GetPopularMovies>(),
      getUpcomingMovies: getIt<GetUpcomingMovies>(),
      getTrendingMovies: getIt<GetTrendingMovies>(),
      getMovieDetails: getIt<GetMovieDetails>(),
      searchMovies: getIt<SearchMovies>(),
      getMovieCredits: getIt<GetMovieCredits>(),
      getMovieReviews: getIt<GetMovieReviews>(),
    ),
  );

  // Genre BLoC
  getIt.registerFactory(
    () => GenreBloc(
      getGenres: getIt<GetGenres>(),
    ),
  );

  // Cinema data sources
  getIt.registerLazySingleton<MockCinemaDataSource>(
    () => MockCinemaDataSource(),
  );

  // Cinema repository
  getIt.registerLazySingleton<CinemaRepository>(
    () => CinemaRepositoryImpl(
      dataSource: getIt<MockCinemaDataSource>(),
    ),
  );

  // Cinema use cases
  getIt
      .registerLazySingleton(() => GetNearbyCinemas(getIt<CinemaRepository>()));
  getIt.registerLazySingleton(() => GetShowtimes(getIt<CinemaRepository>()));

  // Cinema BLoC
  getIt.registerFactory(
    () => CinemaBloc(
      getNearbyCinemas: getIt<GetNearbyCinemas>(),
      getShowtimes: getIt<GetShowtimes>(),
    ),
  );

  // Booking data sources
  getIt.registerLazySingleton<MockSeatDataSource>(
    () => MockSeatDataSource(),
  );

  getIt.registerLazySingleton<MockBookingDataSource>(
    () => MockBookingDataSource(),
  );

  // Payment service
  getIt.registerLazySingleton<PaymentService>(
    () => MockPaymentService(),
  );

  // Ticket service
  getIt.registerLazySingleton<TicketService>(
    () => TicketServiceImpl(),
  );

  // Booking repositories
  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(
      dataSource: getIt<MockBookingDataSource>(),
    ),
  );

  getIt.registerLazySingleton<SeatRepository>(
    () => SeatRepositoryImpl(
      dataSource: getIt<MockSeatDataSource>(),
    ),
  );

  // Booking UseCases
  getIt
      .registerLazySingleton(() => GetUserBookings(getIt<BookingRepository>()));
  getIt.registerLazySingleton(() => CancelBooking(getIt<BookingRepository>()));
  getIt.registerLazySingleton(() => GetUserTickets(getIt<TicketService>()));
  getIt.registerLazySingleton(() => GenerateTicket(getIt<TicketService>()));
  getIt.registerLazySingleton(() => SaveTicket(getIt<TicketService>()));
  getIt.registerLazySingleton(() => DeleteTicket(getIt<TicketService>()));
  getIt.registerLazySingleton(() => GetSeatLayout(getIt<SeatRepository>()));
  getIt.registerLazySingleton(() => InitiatePayment(getIt<PaymentService>()));
  getIt.registerLazySingleton(() => VerifyPayment(getIt<PaymentService>()));

  // Booking BLoCs
  getIt.registerFactory(
    () => SeatBloc(
      getSeatLayout: getIt<GetSeatLayout>(),
    ),
  );

  getIt.registerFactory(
    () => PaymentBloc(
      initiatePayment: getIt<InitiatePayment>(),
      verifyPayment: getIt<VerifyPayment>(),
    ),
  );

  getIt.registerFactory(
    () => TicketBloc(
      getUserTickets: getIt<GetUserTickets>(),
      generateTicket: getIt<GenerateTicket>(),
      saveTicket: getIt<SaveTicket>(),
      deleteTicket: getIt<DeleteTicket>(),
    ),
  );

  getIt.registerFactory(
    () => BookingBloc(
      getUserBookings: getIt<GetUserBookings>(),
      cancelBooking: getIt<CancelBooking>(),
    ),
  );
}
