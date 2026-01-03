import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/features/booking/data/datasources/mock_seat_data_source.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_state.dart';

/// BLoC for handling seat selection logic
class SeatBloc extends Bloc<SeatEvent, SeatState> {
  final MockSeatDataSource dataSource;

  SeatBloc({required this.dataSource}) : super(const SeatInitial()) {
    on<LoadSeatLayoutEvent>(_onLoadSeatLayout);
    on<ToggleSeatEvent>(_onToggleSeat);
    on<ClearSelectionEvent>(_onClearSelection);
  }

  Future<void> _onLoadSeatLayout(
    LoadSeatLayoutEvent event,
    Emitter<SeatState> emit,
  ) async {
    emit(const SeatLoading());

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final seatLayout = dataSource.generateSeatLayout(
        showtimeId: event.showtimeId,
        basePrice: event.basePrice,
      );

      emit(SeatLayoutLoaded(
        seatLayout: seatLayout,
        selectedSeats: const [],
        totalPrice: 0,
      ));
    } catch (e) {
      emit(SeatError(e.toString()));
    }
  }

  void _onToggleSeat(
    ToggleSeatEvent event,
    Emitter<SeatState> emit,
  ) {
    if (state is! SeatLayoutLoaded) return;

    final currentState = state as SeatLayoutLoaded;
    final seat = event.seat;

    // Can't select booked seats
    if (seat.status == SeatStatus.booked) return;

    // Check if seat is currently selected by ID (not by object equality)
    // This is crucial because Seat extends Equatable with status in props
    final isCurrentlySelected =
        currentState.selectedSeats.any((s) => s.id == seat.id);
    final updatedSelectedSeats = List<Seat>.from(currentState.selectedSeats);

    if (isCurrentlySelected) {
      // Deselect
      updatedSelectedSeats.removeWhere((s) => s.id == seat.id);
    } else {
      // Select (max 10 seats)
      if (updatedSelectedSeats.length < 10) {
        updatedSelectedSeats.add(seat.copyWith(status: SeatStatus.selected));
      } else {
        return; // Don't allow more than 10 seats
      }
    }

    // Update the seat layout with new status
    final updatedLayout = _updateSeatInLayout(
      currentState.seatLayout,
      seat,
    );

    final totalPrice = updatedSelectedSeats.fold<double>(
      0,
      (sum, seat) => sum + seat.price,
    );

    emit(currentState.copyWith(
      seatLayout: updatedLayout,
      selectedSeats: updatedSelectedSeats,
      totalPrice: totalPrice,
    ));
  }

  void _onClearSelection(
    ClearSelectionEvent event,
    Emitter<SeatState> emit,
  ) {
    if (state is! SeatLayoutLoaded) return;

    final currentState = state as SeatLayoutLoaded;

    // Reset all selected seats to available
    final updatedLayout = currentState.seatLayout.map((row) {
      return row.map((seat) {
        if (seat.status == SeatStatus.selected) {
          return seat.copyWith(status: SeatStatus.available);
        }
        return seat;
      }).toList();
    }).toList();

    emit(currentState.copyWith(
      seatLayout: updatedLayout,
      selectedSeats: const [],
      totalPrice: 0,
    ));
  }

  List<List<Seat>> _updateSeatInLayout(
    List<List<Seat>> layout,
    Seat targetSeat,
  ) {
    return layout.map((row) {
      return row.map((seat) {
        if (seat.id == targetSeat.id) {
          final newStatus = seat.status == SeatStatus.selected
              ? SeatStatus.available
              : SeatStatus.selected;
          return seat.copyWith(status: newStatus);
        }
        return seat;
      }).toList();
    }).toList();
  }
}
