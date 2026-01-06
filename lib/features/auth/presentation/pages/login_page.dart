import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/utils/validators.dart';
import 'package:galaxymob/core/widgets/widgets.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_event.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_state.dart';

/// Login page with Email/Password and Google Sign-In
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequestedEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _handleGoogleSignIn() {
    context.read<AuthBloc>().add(const GoogleSignInRequestedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.go('/home');
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
            final isLoading = state is AuthLoading;

            return SingleChildScrollView(
              padding: EdgeInsets.all(AppDimens.spacing24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimens.spacing48),

                    // Logo/Title
                    Text(
                      'GalaxyMov',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: AppDimens.spacing8),
                    Text('Welcome back!', style: AppTextStyles.h2),
                    SizedBox(height: AppDimens.spacing8),
                    Text(
                      'Login to continue booking movies',
                      style: AppTextStyles.body1,
                    ),

                    SizedBox(height: AppDimens.spacing48),

                    // Email Field
                    CustomTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: Validators.email,
                      enabled: !isLoading,
                    ),

                    SizedBox(height: AppDimens.spacing16),

                    // Password Field
                    PasswordTextField(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      validator: Validators.password,
                    ),

                    SizedBox(height: AppDimens.spacing32),

                    // Login Button
                    PrimaryButton(
                      text: 'Login',
                      onPressed: isLoading ? null : _handleLogin,
                      isLoading: isLoading,
                    ),

                    SizedBox(height: AppDimens.spacing24),

                    // Divider with "Or continue with"
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color:
                                AppColors.textSecondary.withValues(alpha: 0.3),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.spacing16,
                          ),
                          child: Text(
                            'Or continue with',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color:
                                AppColors.textSecondary.withValues(alpha: 0.3),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimens.spacing24),

                    // Google Sign-In Button
                    _GoogleSignInButton(
                      onPressed: isLoading ? null : _handleGoogleSignIn,
                      isLoading: isLoading,
                    ),

                    SizedBox(height: AppDimens.spacing24),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: AppTextStyles.body2,
                        ),
                        GestureDetector(
                          onTap: () => context.go('/register'),
                          child: Text(
                            'Register',
                            style: AppTextStyles.body2Medium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Google Sign-In Button with premium styling
class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const _GoogleSignInButton({
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          backgroundColor: AppColors.surface,
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textSecondary,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google Logo
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'G',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimens.spacing12),
                  Text(
                    'Continue with Google',
                    style: AppTextStyles.button.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
