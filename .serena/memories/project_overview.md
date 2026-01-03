# Project Overview
- Purpose: Flutter mobile application named "galaxymob"; structure suggests features for auth, bookings, cinema listings, home, and movies.
- Tech stack: Flutter 3.x / Dart SDK >=3.0; flutter_bloc + equatable for state management; dependency injection via get_it/injectable; navigation with go_router; networking via dio + retrofit + pretty_dio_logger; data models generated with freezed/json_serializable; local storage using hive/hive_flutter, shared_preferences, flutter_secure_storage; Firebase suite (core, auth, firestore, storage, analytics, crashlytics); UI helpers such as cached_network_image, flutter_svg, google_fonts, rating bar, carousel_slider, shimmer; utilities include intl, dartz, connectivity_plus, url_launcher.
- Codegen: build_runner with injectable_generator, freezed, json_serializable, retrofit_generator.
- Platform targets: Android/iOS plus web/desktop scaffolding present (platform folders exist).
- Repository structure (top-level): lib/config, lib/core, lib/features (auth/booking/cinema/home/movies), main.dart; tests under test/; platform folders android/ios/web/windows/linux/macos; docs folder currently empty.
- Notable configs: analysis_options.yaml includes flutter_lints defaults and ignores invalid_annotation_target for freezed compatibility; pubspec.yaml disables publishing (publish_to: none).
