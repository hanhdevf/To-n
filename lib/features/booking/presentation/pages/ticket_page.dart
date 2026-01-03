import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_event.dart';

/// Ticket display page showing QR code and booking details
class TicketPage extends StatefulWidget {
  final String movieTitle;
  final String cinemaName;
  final String showtime;
  final List<String> selectedSeats;
  final double totalPrice;
  final String userName;
  final String userEmail;
  final String userPhone;
  final String transactionId;
  final PaymentMethod paymentMethod;

  const TicketPage({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.transactionId,
    required this.paymentMethod,
  });

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Ticket _ticket;

  @override
  void initState() {
    super.initState();

    // Create booking and ticket
    _createTicket();

    // Animation for ticket reveal
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  void _createTicket() {
    // Create booking entity
    final booking = Booking(
      id: 'BOOK-${const Uuid().v4().substring(0, 8).toUpperCase()}',
      movieId: 'unknown',
      movieTitle: widget.movieTitle,
      cinemaId: 'unknown',
      cinemaName: widget.cinemaName,
      showtimeId: 'unknown',
      showtime: DateTime.now().add(const Duration(days: 1)),
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
      totalPrice: widget.totalPrice,
      userName: widget.userName,
      userEmail: widget.userEmail,
      userPhone: widget.userPhone,
      status: BookingStatus.confirmed,
      paymentMethod: widget.paymentMethod,
      transactionId: widget.transactionId,
      createdAt: DateTime.now(),
    );

    // Generate QR data
    final qrData = Ticket.generateQRData(booking);

    // Create ticket
    _ticket = Ticket(
      id: 'TICKET-${const Uuid().v4().substring(0, 12).toUpperCase()}',
      booking: booking,
      qrData: qrData,
      generatedAt: DateTime.now(),
      expiresAt: booking.showtime.add(const Duration(minutes: 30)),
    );

    // Save ticket to local storage
    context.read<TicketBloc>().add(GenerateTicketEvent(booking));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Your Ticket', style: AppTextStyles.h3),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareTicket,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimens.spacing16),
        child: Column(
          children: [
            // Small success indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: AppColors.success, size: 28),
                SizedBox(width: AppDimens.spacing8),
                Text('Booking Confirmed', style: AppTextStyles.h3),
              ],
            ),
            SizedBox(height: AppDimens.spacing16),
            ScaleTransition(
              scale: _scaleAnimation,
              child: _buildTicketCard(),
            ),
            SizedBox(height: AppDimens.spacing16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top section with movie info
          Container(
            padding: EdgeInsets.all(AppDimens.spacing24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimens.radiusLarge),
                topRight: Radius.circular(AppDimens.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                Text(
                  widget.movieTitle,
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimens.spacing8),
                Text(
                  'E-Ticket',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),

          // Perforation effect
          _buildPerforation(),

          // Ticket details
          Padding(
            padding: EdgeInsets.all(AppDimens.spacing16),
            child: Column(
              children: [
                _buildQRCode(),
                SizedBox(height: AppDimens.spacing16),
                _buildTicketInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerforation() {
    return Row(
      children: List.generate(
        20,
        (index) => Expanded(
          child: Container(
            height: 2,
            color: index.isEven ? AppColors.surface : AppColors.background,
          ),
        ),
      ),
    );
  }

  Widget _buildQRCode() {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: QrImageView(
        data: _ticket.qrData,
        version: QrVersions.auto,
        size: 160,
        backgroundColor: Colors.white,
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: AppColors.primary,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTicketInfo() {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Column(
      children: [
        // Booking ID (prominent)
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.spacing12,
            vertical: AppDimens.spacing8,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Booking ID', style: AppTextStyles.caption),
              Text(
                _ticket.booking.id,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: AppDimens.spacing12),

        // 2-column info grid
        Row(
          children: [
            Expanded(
              child: _buildCompactInfoItem(
                Icons.location_on,
                'Cinema',
                widget.cinemaName,
              ),
            ),
            SizedBox(width: AppDimens.spacing8),
            Expanded(
              child: _buildCompactInfoItem(
                Icons.access_time,
                'Time',
                widget.showtime,
              ),
            ),
          ],
        ),

        SizedBox(height: AppDimens.spacing8),

        Row(
          children: [
            Expanded(
              child: _buildCompactInfoItem(
                Icons.event_seat,
                'Seats',
                widget.selectedSeats.join(', '),
              ),
            ),
            SizedBox(width: AppDimens.spacing8),
            Expanded(
              child: _buildCompactInfoItem(
                Icons.person,
                'Name',
                widget.userName,
              ),
            ),
          ],
        ),

        Divider(height: 24, color: Colors.white24),

        // Total (prominent)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Paid', style: AppTextStyles.body2),
                SizedBox(height: 2),
                Text(
                  'via ${widget.paymentMethod.displayName}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            Text(
              formatter.format(widget.totalPrice),
              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactInfoItem(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing8),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textSecondary),
              SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          context.go('/home'); // Go to home
        },
        icon: Icon(Icons.home),
        label: Text('Back to Home'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.all(AppDimens.spacing16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
        ),
      ),
    );
  }

  void _shareTicket() {
    Share.share(
      'My cinema ticket for ${widget.movieTitle}\n'
      'Cinema: ${widget.cinemaName}\n'
      'Date & Time: ${widget.showtime}\n'
      'Seats: ${widget.selectedSeats.join(', ')}\n'
      'Booking ID: ${_ticket.booking.id}',
      subject: 'Movie Ticket - ${widget.movieTitle}',
    );
  }
}
