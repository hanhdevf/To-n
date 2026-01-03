import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';

/// Seat Selection States
abstract class SeatState extends Equatable {
  const SeatState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SeatInitial extends SeatState {
  const SeatInitial();
}

/// Loading seat layout
class SeatLoading extends SeatState {
  const SeatLoading();
}

/// Seat layout loaded
class SeatLayoutLoaded extends SeatState {
  final List<List<Seat>> seatLayout;
  final List<Seat> selectedSeats;
  final double totalPrice;

  const SeatLayoutLoaded({
    required this.seatLayout,
    required this.selectedSeats,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [seatLayout, selectedSeats, totalPrice];

  int get selectedCount => selectedSeats.length;

  SeatLayoutLoaded copyWith({
    List<List<Seat>>? seatLayout,
    List<Seat>? selectedSeats,
    double? totalPrice,
  }) {
    return SeatLayoutLoaded(
      seatLayout: seatLayout ?? this.seatLayout,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

/// Error state
class SeatError extends SeatState {
  final String message;

  const SeatError(this.message);

  @override
  List<Object?> get props => [message];
}
