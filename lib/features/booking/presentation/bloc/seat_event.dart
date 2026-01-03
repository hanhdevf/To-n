import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';

/// Seat Selection Events
abstract class SeatEvent extends Equatable {
  const SeatEvent();

  @override
  List<Object?> get props => [];
}

/// Load seat layout for a showtime
class LoadSeatLayoutEvent extends SeatEvent {
  final String showtimeId;
  final double basePrice;

  const LoadSeatLayoutEvent({
    required this.showtimeId,
    required this.basePrice,
  });

  @override
  List<Object?> get props => [showtimeId, basePrice];
}

/// Toggle seat selection
class ToggleSeatEvent extends SeatEvent {
  final Seat seat;

  const ToggleSeatEvent(this.seat);

  @override
  List<Object?> get props => [seat];
}

/// Clear all selections
class ClearSelectionEvent extends SeatEvent {
  const ClearSelectionEvent();
}
