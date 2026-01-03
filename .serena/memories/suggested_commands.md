# Suggested Commands
- Install deps: `flutter pub get`
- Run app: `flutter run -d <device>` (pick available device/emulator)
- Analyze/lints: `flutter analyze`
- Format: `dart format .` (or `flutter format .`)
- Tests: `flutter test`
- Codegen (models/api/DI): `dart run build_runner build --delete-conflicting-outputs` (or `watch` for auto-rebuild)
- Clean build artifacts: `flutter clean` (then rerun pub get)
