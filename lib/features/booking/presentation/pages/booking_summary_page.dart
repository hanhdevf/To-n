import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/widgets/buttons.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_state.dart';

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
              _buildMovieCard(),
              SizedBox(height: AppDimens.spacing16),
              _buildBookingDetails(),
              SizedBox(height: AppDimens.spacing16),
              _buildPaymentMethods(),
              SizedBox(height: AppDimens.spacing24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildMovieCard() {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: Icon(
              Icons.movie,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          SizedBox(width: AppDimens.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movieTitle,
                  style: AppTextStyles.h3,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.spacing8),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text('4.5', style: AppTextStyles.body2),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    final bookingFee = widget.totalPrice * 0.05; // 5% booking fee
    final finalTotal = widget.totalPrice + bookingFee;

    return Container(
      padding: EdgeInsets.all(AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Details', style: AppTextStyles.h3),
          Divider(height: 24, color: Colors.white24),
          _buildDetailRow('Cinema', widget.cinemaName, icon: Icons.location_on),
          SizedBox(height: AppDimens.spacing12),
          _buildDetailRow('Date & Time', widget.showtime,
              icon: Icons.access_time),
          SizedBox(height: AppDimens.spacing12),
          _buildDetailRow('Seats', widget.selectedSeats.join(', '),
              icon: Icons.event_seat),
          SizedBox(height: AppDimens.spacing12),
          _buildDetailRow('Tickets', '${widget.selectedSeats.length}x',
              icon: Icons.confirmation_number),
          Divider(height: 24, color: Colors.white24),
          _buildPriceRow('Subtotal', widget.totalPrice),
          SizedBox(height: AppDimens.spacing8),
          _buildPriceRow('Booking Fee (5%)', bookingFee),
          Divider(height: 24, color: Colors.white24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: AppTextStyles.h3),
              Text(
                formatter.format(finalTotal),
                style: AppTextStyles.h2.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: AppColors.textSecondary),
          SizedBox(width: AppDimens.spacing8),
        ],
        Expanded(
          flex: 2,
          child: Text(label, style: AppTextStyles.body2),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body2),
        Text(
          formatter.format(amount),
          style: AppTextStyles.body1,
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method', style: AppTextStyles.h3),
          SizedBox(height: AppDimens.spacing16),
          _buildPaymentOption(
            PaymentMethod.creditCard,
            'Credit/Debit Card',
            Icons.credit_card,
          ),
          SizedBox(height: AppDimens.spacing12),
          _buildPaymentOption(
            PaymentMethod.momo,
            'MoMo E-Wallet',
            Icons.account_balance_wallet,
          ),
          SizedBox(height: AppDimens.spacing12),
          _buildPaymentOption(
            PaymentMethod.zaloPay,
            'ZaloPay',
            Icons.payment,
          ),
          SizedBox(height: AppDimens.spacing12),
          _buildPaymentOption(
            PaymentMethod.vnPay,
            'VNPay',
            Icons.account_balance,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    PaymentMethod method,
    String name,
    IconData icon,
  ) {
    final isSelected = _selectedPaymentMethod == method;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
      },
      borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
      child: Container(
        padding: EdgeInsets.all(AppDimens.spacing12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white24,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primary,
                size: 24,
              ),
            ),
            SizedBox(width: AppDimens.spacing12),
            Expanded(
              child: Text(
                name,
                style: AppTextStyles.body1.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppColors.primary, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        final isProcessing = state is PaymentProcessing;

        return Container(
          padding: EdgeInsets.all(AppDimens.spacing16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: PrimaryButton(
              text: isProcessing ? 'Processing...' : 'Confirm & Pay',
              onPressed: isProcessing ? null : () => _handlePayment(context),
            ),
          ),
        );
      },
    );
  }

  void _handlePayment(BuildContext context) {
    final bookingFee = widget.totalPrice * 0.05;
    final finalTotal = widget.totalPrice + bookingFee;

    // Create booking object with placeholder user data
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

    // Initiate payment
    context.read<PaymentBloc>().add(
          InitiatePaymentEvent(
            booking: booking,
            method: _selectedPaymentMethod,
          ),
        );
  }

  DateTime _parseShowtime(String showtimeString) {
    try {
      // Try to parse the showtime string
      // Format expected: "Monday, Jan 3 • 14:30"
      final now = DateTime.now();
      return now.add(const Duration(days: 1)); // Simplified for mock
    } catch (e) {
      return DateTime.now().add(const Duration(days: 1));
    }
  }

  void _onPaymentSuccess(BuildContext context, String transactionId) {
    // Navigate to ticket page with booking info
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
