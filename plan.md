# Home Screen Upgrade Plan (GalaxyMov)

## Muc tieu
- Nang cap trang chu thuc te (lib/features/movies/presentation/pages/home_page.dart) lam ro luong dat ve va kham pha phim.
- Tang ty le click vao phim/ve (CTA ro rang, thong tin day du), giam bo cung bang trang thai loading/error ro rang.
- Tai su dung he thong bloc/DI, thiet ke theo go_router va cac widget da co (SectionHeader, MovieCard, PromoBanner, shimmer).

## Hien trang nhanh
- HomePage dung bloc NowPlaying/Trending/Upcoming + GenreBloc, hero banner, danh sach ngang, GlassHeader co search/profile, PromoBanner chen giua, RefreshIndicator.
- PromoBanner da duoc chuyen ve `lib/features/movies/presentation/widgets/promo_banner.dart`; TempHomePage demo va folder `features/home` da xoa.

## Bo cuc de xuat
- Header: loi chao + avatar (neu co), chon vi tri rap/thi tran, nut thong bao.
- Thanh tim kiem noi bat (tu khoa, goi y) + chip loc nhanh (ngay, rap, the loai, dinh dang 2D/3D/IMAX).
- Promo hero: dung `PromoBanner` lam baner uu dai/chi dinh 1 CTA (Dat ve ngay).
- Khoi \"Dat nhanh\" (Quick booking): phim/suat chieu gan nhat o rap dang chon, nut Dat ve dan toi flow booking.
- Danh sach phim:
  - Now Showing (LoadNowPlayingEvent) dang carousel ngang, the co anh poster, diem, the loai, dinh dang, gia tu, suat gan nhat.
  - Popular/Trending/Upcoming tabs hoac khoi tach (su dung LoadPopularEvent/LoadTrendingEvent/LoadUpcomingEvent) de nguoi dung dao ngay.
  - Top Picks/De xuat cho ban (neu co ca nhan hoa basic du tren luot xem gan).
- Noi dung bo sung:
  - Trailer/Teaser hang ngang (play inline hoac mo bottom sheet).
  - Suat chieu gan ban: hien rap gan nhat, khoang cach, khung gio; CTA dat ve.
  - Uu dai/News: slider cac baner uu dai khac (reuse PromoBanner bien the).
- Footer: bottom navigation toi Home/Movies/Bookings/Profile (neu tuyen duong co san).

## Thong tin can hien thi
- Phim: ten, poster, diem danh gia, xep hang (trending), the loai, thoi luong, dinh dang (2D/3D/IMAX), ngon ngu, do tuoi, ngay cong chieu.
- Suat chieu: rap, phong, gio, con cho, gia tu, uu dai dang ap dung.
- Trang thai: loading skeleton (HorizontalListShimmer), error kieu snackbar + khoi retry, empty message co goi y hanh dong khac.

## Tinh nang uu tien
- Tim kiem co goi y nhanh (SearchMoviesEvent), prefetch ket qua trang 1, giu history tuan/thang.
- Loc & sap xep: the loai, rap, khoang cach, thoi gian, dinh dang; sap xep theo diem IMDB/pho bien/thoi gian chieu.
- CTA dat ve tro mot suat (prefill rap/gio tu khoi hien tai); neu phim chua co lich, cho phep nhan thong bao khi co lich.
- Yeu thich/Watchlist: luu phim yeu thich (Hive/secure storage) de goi y nhanh.
- Trailer preview: mo video, hien rating/age gate neu can.
- Pull-to-refresh + auto refresh mem (khi app resume).
- Offline/yeu mang: doc cache tu Hive, thong bao ket noi + nut thu lai.
- Cleanup (done): thong nhat widget Home o `features/movies`; di chuyen `PromoBanner` vao thu muc dung chung va xoa TempHomePage demo.

## Huong ky thuat
- Bloc: gom cac event hien co (LoadNowPlaying/Popular/Upcoming/Trending, SearchMovies) vao HomeBloc hoac dung nhieu bloc rieng va MultiBlocProvider; cap trang thai tach theo section de khong block UI.
- Data: dung repo dio+retrofit; cache manh phim chu de & search gan day vao Hive, TTL ngan (1-2h).
- DI: tiep tuc get_it/injectable; them provider cho HomeBloc, movie repos, storage service.
- UI: dung AppColors/AppDimens/AppTextStyles; reuse MovieCard/SectionHeader/PromoBanner; them SearchBar, FilterChip, BookingCard, TheaterChip; ho tro dark/light neu theme co.
- Dieu huong: go_router deep link tu baner/phim/CTA toi trang chi tiet phim, chon suat, thanh toan.
- Hieu nang: lazy load list ngang, pre-cache anh bang cached_network_image, debounce tim kiem, su dung shimmer thay vi spinner.
- Kha dung & truy cap: safe area, ho tro tablet (grid/two-column), font size scale, hit area 44px+, thong bao loi ro rang.
- Quan sat: log analytics (view_section, tap_movie, tap_cta_booking, search_submit), log error Crashlytics, them id phim/rap trong su kien.

## Lo trinh de xuat
1) Skeleton & layout: bo sung header/search/filter/quick-booking tren HomePage hien co; them empty/error states ro rang cho moi section.
2) Du lieu: mo rong bloc hien tai cho Popular/Trending/Upcoming + loc theo genre; wiring search + cache ngan han (Hive) + debounce.
3) Booking CTA: them khoi Dat nhanh + deep link toi booking flow, yeu thich/watchlist local.
4) Polish: animation nhe (hero banner fade/scroll), responsive tablet, accessbility pass, analytics event tracking.
5) QA: kiem thu tren thiet bi that + emulator, offline/yeu mang, do luong hieu nang scroll, kiem tra Crashlytics log.
6) Hang muc mo rong (neu co thoi gian): ca nhan hoa de xuat, goi y suat chieu tu lich su dat ve.

## Tieu chi hoan thanh
- Trang chu moi hien day du cac khoi tren, tai su dung bloc/DI, co trang thai loading/error/empty ro rang.
- CTA dat ve/chi tiet phim hoat dong thong qua go_router; tim kiem + loc co debounce va ket qua truoc 2s.
- UI thong nhat mau sac/typography cua AppColors/AppTextStyles, khong flicker, thoi gian render khung dau <200ms sau du lieu co san cache.
