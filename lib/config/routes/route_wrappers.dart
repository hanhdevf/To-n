import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper to wrap a widget with a single BlocProvider.
Widget withBloc<T extends BlocBase<Object?>>(
  T Function(BuildContext) create,
  Widget child,
) =>
    BlocProvider<T>(
      create: create,
      child: child,
    );

/// Helper to wrap a widget with multiple BlocProviders.
Widget withMultiBloc(
  List<BlocProvider> providers,
  Widget child,
) =>
    MultiBlocProvider(
      providers: providers,
      child: child,
    );
