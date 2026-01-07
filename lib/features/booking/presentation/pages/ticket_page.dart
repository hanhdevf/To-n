import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_event.dart';
import 'package:galaxymob/features/booking/presentation/widgets/ticket/ticket_action_button.dart';
import 'package:galaxymob/features/booking/presentation/widgets/ticket/ticket_qr_card.dart';
import 'package:galaxymob/features/booking/presentation/widgets/ticket/ticket_success_header.dart';
import 'package:share_plus/share_plus.dart';

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
    _createTicket();
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

    final qrData = Ticket.generateQRData(booking);

    _ticket = Ticket(
      id: 'TICKET-${const Uuid().v4().substring(0, 12).toUpperCase()}',
      booking: booking,
      qrData: qrData,
      generatedAt: DateTime.now(),
      expiresAt: booking.showtime.add(const Duration(minutes: 30)),
    );

    // Ticket generation now happens manually from My Bookings
    // context.read<TicketBloc>().add(GenerateTicketEvent(booking));
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
            icon: const Icon(Icons.share),
            onPressed: _shareTicket,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimens.spacing16),
        child: Column(
          children: [
            const TicketSuccessHeader(),
            SizedBox(height: AppDimens.spacing16),
            ScaleTransition(
              scale: _scaleAnimation,
              child: TicketQrCard(
                ticket: _ticket,
                movieTitle: widget.movieTitle,
                cinemaName: widget.cinemaName,
                showtime: widget.showtime,
                selectedSeats: widget.selectedSeats,
                userName: widget.userName,
                paymentMethod: widget.paymentMethod,
                totalPrice: widget.totalPrice,
              ),
            ),
            SizedBox(height: AppDimens.spacing16),
            TicketActionButton(
              onPressed: () => context.go('/home'),
            ),
          ],
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
