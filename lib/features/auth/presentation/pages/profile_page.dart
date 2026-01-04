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
import 'package:galaxymob/features/auth/presentation/widgets/profile/profile_header.dart';
import 'package:galaxymob/features/auth/presentation/widgets/profile/profile_logged_out.dart';
import 'package:galaxymob/features/auth/presentation/widgets/profile/profile_menu_item.dart';
import 'package:galaxymob/features/auth/presentation/widgets/profile/profile_quick_actions.dart';

/// Enhanced profile page with modern UI
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const LoadProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
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

          if (state is AuthUnauthenticated || state is AuthInitial) {
            return const ProfileLoggedOut();
          }

          if (state is ProfileLoaded || state is AuthAuthenticated) {
            final user = state is ProfileLoaded
                ? state.user
                : (state as AuthAuthenticated).user;

            return CustomScrollView(
              slivers: [
                ProfileHeader(user: user),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppDimens.spacing16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Quick Actions'),
                        SizedBox(height: AppDimens.spacing12),
                        ProfileQuickActions(
                          onBookings: () => context.push('/my-bookings'),
                          onFavorites: () => _showComingSoon(context),
                          onHistory: () => _showComingSoon(context),
                        ),
                        SizedBox(height: AppDimens.spacing24),
                        _buildSectionTitle('Account'),
                        SizedBox(height: AppDimens.spacing12),
                        ProfileMenuItem(
                          icon: Icons.person_outline,
                          title: 'Edit Profile',
                          subtitle: 'Update your personal information',
                          onTap: () => _showComingSoon(context),
                        ),
                        SizedBox(height: AppDimens.spacing8),
                        ProfileMenuItem(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          subtitle: 'Update your password',
                          onTap: () => _showComingSoon(context),
                        ),
                        SizedBox(height: AppDimens.spacing24),
                        _buildSectionTitle('Preferences'),
                        SizedBox(height: AppDimens.spacing12),
                        ProfileMenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          subtitle: 'Manage notification settings',
                          onTap: () => _showComingSoon(context),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                        SizedBox(height: AppDimens.spacing8),
                        ProfileMenuItem(
                          icon: Icons.language_outlined,
                          title: 'Language',
                          subtitle: 'English',
                          onTap: () => _showComingSoon(context),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                        SizedBox(height: AppDimens.spacing8),
                        ProfileMenuItem(
                          icon: Icons.dark_mode_outlined,
                          title: 'Dark Mode',
                          subtitle: 'Always dark',
                          trailing: Switch(
                            value: true,
                            onChanged: (value) => _showComingSoon(context),
                            activeColor: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: AppDimens.spacing24),
                        _buildSectionTitle('Support'),
                        SizedBox(height: AppDimens.spacing12),
                        ProfileMenuItem(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          subtitle: 'Get help with the app',
                          onTap: () => _showComingSoon(context),
                        ),
                        SizedBox(height: AppDimens.spacing8),
                        ProfileMenuItem(
                          icon: Icons.policy_outlined,
                          title: 'Privacy Policy',
                          subtitle: 'Read our privacy policy',
                          onTap: () => _showComingSoon(context),
                        ),
                        SizedBox(height: AppDimens.spacing8),
                        ProfileMenuItem(
                          icon: Icons.info_outline,
                          title: 'About',
                          subtitle: 'Version 1.0.0',
                          onTap: () => _showAboutDialog(context),
                        ),
                        SizedBox(height: AppDimens.spacing32),
                        SecondaryButton(
                          text: 'Logout',
                          onPressed: _handleLogout,
                          icon:
                              const Icon(Icons.logout, color: AppColors.error),
                        ),
                        SizedBox(height: AppDimens.spacing48),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'GalaxyMov',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.movie, color: Colors.white, size: 32),
      ),
      children: [
        const Text('A modern cinema booking application'),
        const SizedBox(height: 8),
        const Text('Built with Flutter & Clean Architecture'),
      ],
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Logout', style: AppTextStyles.h3),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(const LogoutRequestedEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
