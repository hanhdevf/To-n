import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart';

/// Helper to wrap a widget with a single BlocProvider.
Widget withBloc<T extends BlocBase<Object?>>(
  T Function(BuildContext) create,
  Widget child,
) {
  return BlocProvider<T>(
    create: create,
    child: child,
  );
}

/// Helper to wrap a widget with multiple BlocProviders.
Widget withMultiBloc(
  List<SingleChildWidget> providers,
  Widget child,
) {
  return MultiBlocProvider(
    providers: providers,
    child: child,
  );
}
