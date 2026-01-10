# ✅ Flutter Clean Code Audit Standard (Clean Architecture + Feature-First + BLoC)
Vai trò: Senior Flutter Engineer  
Mục tiêu: mọi PR/commit phải tuân thủ chuẩn audit này. Nếu vi phạm => không merge.

---

## 0) Nguyên tắc cốt lõi
1. **Feature-first**: mọi thứ nằm trong `features/<feature_name>/...`
2. **Clean Architecture**: tách `presentation / domain / data` rõ ràng.
3. **Dependency Rule**: 
   - `presentation` -> `domain`
   - `data` -> `domain`
   - `domain` **không** import gì từ `data/presentation/framework`
4. **BLoC only**: state management dùng BLoC/Cubit, không setState cho business logic.
5. **No God file / God class**: file <= 300 lines (khuyến nghị), class <= 200 lines.
6. **Null-safety strict** + `analysis_options.yaml` nghiêm ngặt.
7. **Testability-first**: domain logic phải test được, IO phải mock.

---

## 1) Cấu trúc thư mục chuẩn
lib/
  app/
    di/                         # dependency injection (get_it / injectable)
    router/                     # go_router / auto_route
    theme/
    l10n/
    app.dart
    bootstrap.dart
  core/
    constants/
    error/                      # failures, exceptions
    network/                    # dio client, interceptors
    utils/
    widgets/                    # shared reusable widgets
    usecase/                    # base usecase
  features/
    <feature_name>/
      presentation/
        bloc/
          <feature>_bloc.dart
          <feature>_event.dart
          <feature>_state.dart
        pages/
        widgets/
      domain/
        entities/
        repositories/
        usecases/
      data/
        datasources/
          remote/
          local/
        models/
        repositories/
  main.dart

✅ Audit: không được đặt business logic vào `core/` nếu nó thuộc 1 feature cụ thể.  
✅ Audit: không import chéo feature với nhau trực tiếp; nếu cần, tạo abstraction ở `core/` hoặc module riêng.

---

## 2) Naming conventions (bắt buộc)
### File/folder
- snake_case: `user_profile_page.dart`, `get_user_profile_usecase.dart`
- BLoC file tách 3 file: `*_bloc.dart`, `*_event.dart`, `*_state.dart`  
  (Không dùng bloc “all-in-one” file nếu > 150 lines)

### Class
- PascalCase: `UserProfilePage`, `GetUserProfile`
- Entity: danh từ: `User`
- Usecase: `VerbNoun`: `GetUserProfile`, `UpdateAvatar`
- Repository interface: `UserRepository`
- Impl: `UserRepositoryImpl`
- Model: `UserModel` (extends/implements Entity mapping)

### Biến/hàm
- camelCase
- Boolean bắt đầu bằng `is/has/can/should`: `isLoading`, `hasPermission`

---

## 3) Quy tắc Clean Architecture (audit theo import)
### domain/
- Chỉ chứa: Entities, Repository interfaces, Usecases, ValueObjects
- Không được import:
  - `flutter`, `dio`, `shared_preferences`, `hive`, `json_annotation`, `bloc`, ...
- Usecase luôn return `Either<Failure, T>` (khuyến nghị) hoặc throw Failure-wrapped.

### data/
- Chứa: models (json), datasources, repository implementations
- RepositoryImpl implement domain repository
- Mapping:
  - Model <-> Entity mapping nằm trong `models/` hoặc `mapper/` (nếu lớn)
- Không được trả về Model ra ngoài domain/presentation.

### presentation/
- UI + BLoC/Cubit
- BLoC gọi usecase, không gọi datasource trực tiếp.
- UI không gọi repository/usecase trực tiếp (qua BLoC).

✅ Audit rule: bất cứ file nào trong `domain/` import từ `data/` hoặc `presentation/` => fail.

---

## 4) Chuẩn BLoC (bắt buộc)
### Khi nào dùng Bloc vs Cubit
- **Bloc**: nhiều event, flow phức tạp
- **Cubit**: state đơn giản, ít event

### State design
- State **immutable** (freezed khuyến nghị)
- Không dùng state kiểu “dynamic object”
- Có `status` chuẩn hoặc state union:
  - `initial / loading / success / failure`

### Event design
- Event là intent từ UI: `FetchRequested`, `Submitted`
- Không nhét business rule vào event

### Side-effects
- Navigation, toast, dialog: dùng `BlocListener`
- Không navigation trong `build()` khi state thay đổi.

### Error handling
- BLoC không throw; luôn emit failure state.
- Failure chứa `message`, `code`, `stackTrace?`

✅ Audit: BLoC không được gọi `Dio`/`SharedPreferences` trực tiếp.

---

## 5) Chuẩn DI (Dependency Injection)
- `app/di/` quản lý injection
- register theo layer:
  - datasources
  - repositories
  - usecases
  - blocs/cubits
- Không inject `BuildContext` vào BLoC/usecase.
- Nếu dùng `get_it`: không gọi `GetIt.I()` rải rác; chỉ gọi trong bootstrap/di.

✅ Audit: không tạo instance `Dio()` trong feature file; phải qua core network + DI.

---

## 6) Chuẩn Networking / Persistence
### Networking
- 1 client: `core/network/dio_client.dart`
- Interceptors:
  - auth token
  - logging (dev only)
  - retry (optional)
- Parse json trong `data/models/`
- Response mapping không được nằm trong BLoC.

### Local storage
- abstraction ở `datasources/local/`
- Không gọi SharedPreferences/Hive trong BLoC.

✅ Audit: không có “magic string endpoints” trong feature. Endpoints phải ở constants/config.

---

## 7) Error model (bắt buộc)
- `core/error/failure.dart`: `Failure` base class
- `core/error/exception.dart`: `ServerException`, `CacheException`, ...
- Data layer catch exception -> map to Failure.

✅ Audit: UI chỉ biết Failure message “user friendly”, không show raw exception.

---

## 8) Logging & Debug
- Không dùng `print()`
- Dùng `logger` (hoặc tương đương) inject qua DI
- Log level theo env: debug/info/warn/error

✅ Audit: `print` xuất hiện trong PR => fail.

---

## 9) UI/Widget rules
- Widget nhỏ, tách reusable widget vào `presentation/widgets/`
- Không để business logic trong widget
- `build()` không được call async hoặc trigger event ngoài init/interaction
- Dùng `const` tối đa có thể
- Không hardcode màu; dùng theme tokens

✅ Audit: `MediaQuery.of(context)` lặp nhiều => dùng extensions/util.

---

## 10) Code style & lint (bắt buộc)
### analysis_options.yaml (tối thiểu)
- `flutter_lints` + bật thêm:
  - avoid_print
  - always_use_package_imports
  - prefer_const_constructors
  - prefer_final_locals
  - directives_ordering
  - unnecessary_lambdas
  - depend_on_referenced_packages

✅ Audit: PR không được thêm warning lint mới.

