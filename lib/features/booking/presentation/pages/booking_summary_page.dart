import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_state.dart';
import 'package:galaxymob/features/booking/presentation/widgets/summary/booking_payment_method_dropdown.dart';
import 'package:galaxymob/features/booking/presentation/widgets/summary/booking_summary_bottom_bar.dart';
import 'package:galaxymob/features/booking/presentation/widgets/summary/booking_summary_details.dart';
import 'package:galaxymob/features/booking/presentation/widgets/summary/booking_summary_movie_card.dart';
import 'package:galaxymob/features/booking/presentation/widgets/summary/booking_summary_voucher.dart';

class BookingSummaryPage extends StatefulWidget {
  final String movieTitle;
  final String cinemaName;
  final String showtime;
  final List<String> selectedSeats;
  final double totalPrice;
  final String? movieId;
  final String? cinemaId;
  final String? showtimeId;

  const BookingSummaryPage({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
    this.movieId,
    this.cinemaId,
    this.showtimeId,
  });

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.creditCard;
  final TextEditingController _voucherController = TextEditingController();

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Summary', style: AppTextStyles.h3),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentSuccess) {
            _onPaymentSuccess(context, state.transactionId);
          } else if (state is PaymentFailed) {
            _showErrorDialog(context, state.message);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimens.spacing16),
          child: Column(
            children: [
              BookingSummaryMovieCard(movieTitle: widget.movieTitle),
              SizedBox(height: AppDimens.spacing16),
              BookingSummaryDetails(
                cinemaName: widget.cinemaName,
                showtime: widget.showtime,
                selectedSeats: widget.selectedSeats,
                totalPrice: widget.totalPrice,
              ),
              SizedBox(height: AppDimens.spacing16),
              BookingSummaryVoucher(controller: _voucherController),
              SizedBox(height: AppDimens.spacing16),
              BookingPaymentMethodDropdown(
                selected: _selectedPaymentMethod,
                onChanged: (PaymentMethod? newValue) {
                  if (newValue != null) {
                    setState(() => _selectedPaymentMethod = newValue);
                  }
                },
              ),
              SizedBox(height: AppDimens.spacing24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          final isProcessing = state is PaymentProcessing;
          return BookingSummaryBottomBar(
            isProcessing: isProcessing,
            onConfirm: isProcessing ? () {} : () => _handlePayment(context),
          );
        },
      ),
    );
  }

  void _handlePayment(BuildContext context) {
    final bookingFee = widget.totalPrice * 0.05;
    final finalTotal = widget.totalPrice + bookingFee;

    final booking = Booking(
      id: 'BOOK-${const Uuid().v4().substring(0, 8).toUpperCase()}',
      movieId: widget.movieId ?? 'unknown',
      movieTitle: widget.movieTitle,
      cinemaId: widget.cinemaId ?? 'unknown',
      cinemaName: widget.cinemaName,
      showtimeId: widget.showtimeId ?? 'unknown',
      showtime: _parseShowtime(widget.showtime),
      selectedSeats: widget.selectedSeats
          .map((s) => Seat(
                id: s,
                row: s.substring(0, 1),
                number: int.tryParse(s.substring(1)) ?? 0,
                type: SeatType.regular,
                status: SeatStatus.selected,
                price: widget.totalPrice / widget.selectedSeats.length,
              ))
          .toList(),
      totalPrice: finalTotal,
      userName: 'Guest User',
      userEmail: 'guest@galaxymov.com',
      userPhone: '0000000000',
      status: BookingStatus.pending,
      paymentMethod: _selectedPaymentMethod,
      createdAt: DateTime.now(),
    );

    context.read<PaymentBloc>().add(
          InitiatePaymentEvent(
            booking: booking,
            method: _selectedPaymentMethod,
          ),
        );
  }

  DateTime _parseShowtime(String showtimeString) {
    try {
      final now = DateTime.now();
      return now.add(const Duration(days: 1));
    } catch (e) {
      return DateTime.now().add(const Duration(days: 1));
    }
  }

  void _onPaymentSuccess(BuildContext context, String transactionId) {
    context.pushReplacementNamed(
      'ticketView',
      extra: {
        'movieTitle': widget.movieTitle,
        'cinemaName': widget.cinemaName,
        'showtime': widget.showtime,
        'selectedSeats': widget.selectedSeats,
        'totalPrice': widget.totalPrice + (widget.totalPrice * 0.05),
        'userName': 'Guest User',
        'userEmail': 'guest@galaxymov.com',
        'userPhone': '0000000000',
        'transactionId': transactionId,
        'paymentMethod': _selectedPaymentMethod,
      },
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error, size: 32),
            SizedBox(width: AppDimens.spacing12),
            Text('Payment Failed', style: AppTextStyles.h3),
          ],
        ),
        content: Text(message, style: AppTextStyles.body1),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Try Again', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}
