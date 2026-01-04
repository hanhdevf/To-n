# GalaxyMov Best-Practice Audit

## Critical
- Hardcoded TMDB secret and duplicated injection: `lib/config/constants/api_constants.dart:5` commits the API key and `lib/features/movies/data/datasources/tmdb_api_service.dart:18-88` also defaults it while `lib/core/network/api_client.dart:23-37` adds another interceptor, risking leaked secrets and duplicate query params. Move to env/flavor configs and inject via secure storage/config files excluded from VCS.
- Mocked auth/data shipped in DI: `lib/core/di/injection.dart:52-219` registers mock auth, cinema, booking, and payment services for all builds; `lib/features/auth/data/datasources/mock_auth_remote_data_source.dart:8-83` keeps plaintext credentials. Introduce flavors/env-specific modules so prod uses real backends; remove plaintext fixtures from app bundle.
- Unsafe navigation payloads: multiple `state.extra as Map<String, dynamic>` casts in `lib/config/routes/app_router.dart:144-234` will throw at runtime if extras are missing/wrongly typed. Replace with typed route data objects or guards with null/validation fallbacks.

## High
- Tokens and user cache stored unencrypted in SharedPreferences (`lib/features/auth/data/datasources/auth_local_data_source.dart:8-45`); secrets should use `flutter_secure_storage`/platform keystore and avoid persisting mock tokens.
- Network logging always enabled: `PrettyDioLogger` is wired for every build (`lib/core/network/api_client.dart:38-41`) and `debugLogDiagnostics: true` in router (`lib/config/routes/app_router.dart:41`), which will log payloads and navigation paths in release. Gate logs behind kDebugMode/build flavor.
- Crash/analytics not wired: Firebase deps exist but `Firebase.initializeApp()` is commented (`lib/main.dart:25`), and there is no `runZonedGuarded`/`FlutterError.onError`/Crashlytics hook. Production apps need global error reporting before runApp.
- Hive storage without security/typing: tickets persist raw maps with no adapters or encryption (`lib/features/booking/data/repositories/ticket_service_impl.dart:7-136`), and boxes are opened on the fly without lifecycle control. Define Hive adapters, encrypt sensitive data, and manage box open/close centrally.

## Medium
- DI drift and duplication: manual `configureDependencies` (`lib/core/di/injection.dart`) coexists with an unused injectable module (`lib/core/di/register_module.dart:8-17`). Lack of scoped lifetimes/environments makes it hard to swap prod/dev implementations or test doubles. Align on injectable/get_it generation with environments (dev/prod/test).
- Networking resilience gaps: `MovieRemoteDataSource` wraps all failures as `ServerException(e.toString())` (`lib/features/movies/data/datasources/movie_remote_data_source.dart:10-115`) and never checks connectivity (`NetworkInfo` is unused). Centralize Dio error mapping, add retry/backoff, and short-circuit with offline failures.
- State management inconsistency: `HomePage` mixes Bloc listeners with `setState` for multiple lists (`lib/features/home/presentation/pages/home_page.dart:33-205`), increasing flicker and making state hard to test. Prefer Bloc builders/selectors with immutable view models per section.
- MovieBloc UX: every fetch emits the same `MovieLoading` state (`lib/features/movies/presentation/bloc/movie_bloc.dart:35-118`), so one section loading blanks the others and there is no caching/pagination or debounce for search. Split states per slice or use independent cubits with cached results.
- Routing/auth gaps: initial route `/home` is always accessible and AuthBloc is scoped per page (`lib/config/routes/app_router.dart:44-90`), so auth state is not shared and there are no guards/redirects for protected pages (tickets/profile/booking). Add global auth provider and go_router redirect logic.
- Data validity: ticket save/reload relies on `toString()` enum values (`ticket_service_impl.dart:92-131`), which is brittle if enum names change. Persist stable keys.

## Low / Housekeeping
- Lints are minimal (Flutter defaults only, `analysis_options.yaml`); no strict-inference, public_member_api_docs, or immutable collections. Strengthen lints and fix violations incrementally.
- Tests: only a placeholder widget test (`test/widget_test.dart`) and no unit/widget/integration coverage for blocs, repositories, or navigation.
- CI/CD: no pipelines for format/analyze/test/build, and no codegen guardrails (build_runner not enforced). Add GitHub Actions/CI to run `flutter format`, `flutter analyze`, `flutter test`, and `flutter pub run build_runner build --delete-conflicting-outputs`.
- Release readiness: Android appId/signing still TODOs (`android/app/build.gradle.kts:23,35`), and no flavors or env configs are defined. README is stock (`README.md`) and `docs/` is empty, leaving setup undiscoverable.
- Internationalization/accessibility: `MaterialApp.router` lacks locale delegates, text scale/accessibility testing hooks, and there is no localization plan; currency formatting in bookings uses a mangled symbol (`lib/features/booking/presentation/pages/my_bookings_page.dart:62-150`) and hard-coded strings throughout.
- Legacy TODOs remain in UI flows (`my_bookings_page.dart:120-146`, `movie_detail_page.dart:228`) signaling incomplete navigation and trailer playback.

## Quick Wins (next sprint)
- Externalize secrets and logging toggles per flavor; add env loader and remove committed keys.
- Wire Crashlytics/Sentry with `runZonedGuarded`, and add a lightweight error surface for go_router errorBuilder.
- Replace map-based extras with typed route params and add auth redirect middleware.
- Expand lint set and add CI job for format/analyze/test/build_runner to prevent regressions.
- Add bloc/repository tests for auth/movies/booking happy-path and failure mapping, and a golden/widget smoke test for `HomePage`.
