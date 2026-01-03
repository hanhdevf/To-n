import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/widgets/widgets.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_event.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_state.dart';

/// Profile page displaying user information
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Load profile on init
    context.read<AuthBloc>().add(const LoadProfileEvent());
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const LogoutRequestedEvent());
            },
            child: Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppColors.background,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go('/login');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded || state is AuthAuthenticated) {
            final user = state is ProfileLoaded
                ? state.user
                : (state as AuthAuthenticated).user;

            return SingleChildScrollView(
              padding: EdgeInsets.all(AppDimens.spacing24),
              child: Column(
                children: [
                  SizedBox(height: AppDimens.spacing24),

                  // Avatar
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.gradientStart,
                          AppColors.gradientEnd,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        user.displayName[0].toUpperCase(),
                        style: AppTextStyles.h1.copyWith(
                          fontSize: 48,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: AppDimens.spacing24),

                  // Name
                  Text(user.displayName, style: AppTextStyles.h2),

                  SizedBox(height: AppDimens.spacing8),

                  // Email
                  Text(user.email, style: AppTextStyles.body1),

                  SizedBox(height: AppDimens.spacing48),

                  // Profile Info Cards
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    title: 'Display Name',
                    value: user.displayName,
                  ),

                  SizedBox(height: AppDimens.spacing16),

                  _buildInfoCard(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: user.email,
                  ),

                  SizedBox(height: AppDimens.spacing16),

                  _buildInfoCard(
                    icon: Icons.badge_outlined,
                    title: 'User ID',
                    value: user.id,
                  ),

                  SizedBox(height: AppDimens.spacing32),

                  // My Bookings Button
                  PrimaryButton(
                    text: 'My Bookings',
                    onPressed: () => context.push('/my-bookings'),
                    icon: const Icon(Icons.receipt_long, color: Colors.white),
                  ),

                  SizedBox(height: AppDimens.spacing16),

                  // Logout Button
                  SecondaryButton(
                    text: 'Logout',
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout, color: AppColors.error),
                  ),
                ],
              ),
            );
          }

          // Error or unauthenticated
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                SizedBox(height: AppDimens.spacing16),
                Text('Unable to load profile', style: AppTextStyles.h3),
                SizedBox(height: AppDimens.spacing24),
                PrimaryButton(
                  text: 'Retry',
                  onPressed: () {
                    context.read<AuthBloc>().add(const LoadProfileEvent());
                  },
                  isFullWidth: false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          SizedBox(width: AppDimens.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.caption),
                SizedBox(height: AppDimens.spacing4),
                Text(value, style: AppTextStyles.body1Medium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
