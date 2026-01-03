import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:galaxymob/config/routes/app_router.dart';
import 'package:galaxymob/config/theme/app_theme.dart';
import 'package:galaxymob/core/bloc/app_bloc_observer.dart';
import 'package:galaxymob/core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize Firebase (will be configured in Phase 2)
  // await Firebase.initializeApp();

  // Setup BLoC observer for logging
  Bloc.observer = AppBlocObserver();

  // Configure dependency injection
  await configureDependencies();

  runApp(const GalaxyMovApp());
}

class GalaxyMovApp extends StatelessWidget {
  const GalaxyMovApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GalaxyMov',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
