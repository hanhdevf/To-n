# Style & Conventions
- Linting: Uses `flutter_lints` defaults (see analysis_options.yaml); analyzer suppresses `invalid_annotation_target` for freezed. Follow Dart/Flutter idioms and prefer analyzer-clean code.
- State & DI: flutter_bloc for presentation; get_it + injectable for dependency injection—register via generated code; value equality via equatable; use dartz types where appropriate.
- Code generation: freezed and json_serializable for models; retrofit for API clients; injectable config for DI. Regenerate with build_runner after model/API/DI changes.
- Navigation: go_router; prefer declarative route definitions and typed navigation helpers.
- UI: Uses Material with helper packages (google_fonts, cached_network_image, svg, carousel_slider, shimmer). Keep widgets composable and responsive.
- Storage & Services: Hive/shared_preferences/secure storage for local data; Firebase auth/firestore/storage/analytics/crashlytics available.
- Formatting: Default Dart formatter (`dart format`/`flutter format`) presumed; keep imports ordered by formatter.
