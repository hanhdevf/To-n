# Done Checklist
- Dependencies installed (`flutter pub get`) and codegen updated if models/apis/DI changed (`dart run build_runner build --delete-conflicting-outputs`).
- Code formatted (e.g., `dart format .`) and analyzer clean (`flutter analyze`).
- Relevant tests executed (`flutter test`) or note coverage gaps if skipped.
- App runs on at least one target device/simulator when feature affects runtime behavior.
- Document notable decisions or follow-up work in task notes/PR description.
