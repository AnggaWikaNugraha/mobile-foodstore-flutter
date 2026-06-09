# Foodstore Mobile App

Flutter mobile app for Foodstore.

## Tech Stack

| Kategori | Package |
|---|---|
| Framework | Flutter + Dart |
| Navigation | go_router (+ deep linking) |
| HTTP Client | dio + interceptor JWT |
| State Management | flutter_riverpod (auth, cart, tema, wishlist) |
| Form & Validasi | reactive_forms |
| Storage (secure) | flutter_secure_storage (token) |
| Storage (umum) | shared_preferences (search history, tema) |
| Cache Gambar | cached_network_image |
| Biometric | local_auth |
| Google Sign-In | google_sign_in |
| Image Picker | image_picker |
| WebView (Midtrans) | webview_flutter |
| Carousel | carousel_slider |
| Skeleton/Shimmer | shimmer |
| Infinite Scroll | infinite_scroll_pagination |
| Realtime | pusher_channels_flutter |
| Push Notifikasi | firebase_messaging + flutter_local_notifications |
| Konektivitas | connectivity_plus |
| Debounce | rxdart |

## Backend

Base URL: `https://foodstore-server-nu.vercel.app`

## Features

### 🚧 Coming Soon

**Auth**

- [ ] Login (email + password)
- [ ] Register
- [ ] Auto login — cek token saat buka app, redirect otomatis
- [ ] Logout
- [ ] Guest mode — beranda bisa diakses tanpa login
- [ ] Biometric auth (`expo-local-authentication`) — fingerprint / Face ID setiap buka app & kembali dari background (`AppState`); cache tetap ada, hanya auth gate yang di-reset
- [ ] Google Sign-In native (`@react-native-google-signin/google-signin`) — OAuth native flow, butuh endpoint `POST /auth/google/mobile` di backend

**Home**

- [ ] Product list (grid 2 kolom)
- [ ] Search produk dengan debounce (500ms)
- [ ] Filter kategori
- [ ] Filter tags (multi-select)
- [ ] Banner carousel
- [ ] Header dengan cart badge + user avatar
- [ ] Badge "Sisa n" di product card saat stok ≤ 5
- [ ] Disable tombol "+" di product card kalau qty di cart sudah mencapai stok

**Cart**

- [ ] Tambah ke cart (guest → redirect login)
- [ ] Cart badge count di header (realtime)
- [ ] Cart icon loading saat mutasi berjalan
- [ ] Empty state "Keranjang kosong" saat cart tidak ada isi
- [ ] Checkbox per item + Pilih Semua
- [ ] Hapus item yang di-check via tombol "Hapus"
- [ ] Ikon trash per item — hapus satu item langsung
- [ ] Update qty; qty → 0 otomatis hapus item dari cart
- [ ] Subtotal per item tampil di kanan setiap card
- [ ] Card items disabled (opacity 0.6) saat mutasi berjalan
- [ ] Ringkasan belanja (subtotal + ongkir Rp 20.000 + total) — hanya tampil jika ada item yang di-check
- [ ] Tombol "Beli (n)" — hanya muncul jika ada item yang di-check, meneruskan hanya item `checked = true` ke Checkout

**Checkout**

- [ ] 3-step checkout flow dengan stepper UI
- [ ] Step 1: Review item pesanan — hanya item yang `checked = true` dari cart
- [ ] Step 2: Pilih alamat pengiriman dari daftar saved addresses (dengan radio select)
- [ ] Step 3: Konfirmasi — ringkasan alamat, item, subtotal, ongkir (Rp 20.000), dan total pembayaran
- [ ] Buat order via `POST /api/orders` → langsung navigate ke InvoiceScreen

**Invoice & Pembayaran**

- [ ] Invoice card — nomor invoice, status badge (Lunas), stepper 4 tahap (Pembayaran → Diproses → Dikirim → Diterima)
- [ ] Status banner per kondisi: Menunggu Pembayaran, Dikonfirmasi, Diproses, Dalam Pengiriman, Diterima, Gagal
- [ ] Tombol "Bayar Sekarang" saat status `waiting_payment`
- [ ] Midtrans Snap popup via WebView (inject Snap.js sandbox) — dipicu dari InvoiceScreen
- [ ] Callback Snap.js via `postMessage`: `success`, `pending`, `error`, `close`
- [ ] Verifikasi pembayaran via `GET /api/payments/verify/:order_id` setelah sukses
- [ ] Tombol "Konfirmasi Diterima" saat status `in_delivery`
- [ ] Tombol "Beri Rating" per item saat status `delivered`
- [ ] Info pengiriman (alamat), info pembayaran (nama + email user), item pesanan, ringkasan harga
- [ ] Auto-refetch status setiap 10 detik (sementara sebelum Pusher)
- [ ] Tracking status order realtime — ganti polling 10s dengan Pusher (`private-order-<id>`, event `order:status_updated`)

**Profile**

- [ ] Biodata diri (nama, email, role, customer ID, login via Google)
- [ ] Ganti tema warna (Green Fern, Green Jade, Merah, Biru, Orange)
- [ ] Image picker untuk avatar profile — `expo-image-picker`, kamera + galeri, upload ke `PUT /api/users/avatar` (Cloudinary), foto langsung update di hero section

**Riwayat Belanja**

- [ ] Tab "Riwayat Belanja" di Profile — daftar semua order dari `GET /api/orders`
- [ ] Setiap row: ikon, "Order #n", tanggal, total harga, badge status (Menunggu/Diproses/Dikirim/Lunas/Gagal)
- [ ] Tap order → navigate ke InvoiceScreen
- [ ] Banner "n pesanan menunggu pembayaran" — collapsible, expand tampilkan list order waiting
- [ ] Tap order di banner → langsung ke InvoiceScreen order tersebut

**Tema**

- [ ] Multi-tema — Green Fern, Green Jade, Merah, Biru, Orange
- [ ] Token warna terpusat di `src/constants/themes.ts`
- [ ] Ganti tema dari Profile → tab Keamanan
- [ ] Dark mode — theme system sudah ada, tambah variant `dark` per token warna

**Wishlist**

- [ ] Toggle wishlist dari product card (ikon hati merah/abu-abu)
- [ ] Wishlist disinkron via `GET /api/wishlists` — heart langsung update saat buka HomeScreen
- [ ] Tambah ke wishlist via `POST /api/wishlists { product_id }`
- [ ] Hapus dari wishlist via `DELETE /api/wishlists/:product_id`
- [ ] Tab "Favorit" di ProfileScreen — daftar produk favorit dengan thumbnail, nama, harga
- [ ] Hapus dari favorit langsung via tombol hati di tab Favorit

**Product Detail**

- [ ] Tap product card di Home → buka detail screen
- [ ] Tap item di tab Favorit → buka detail screen
- [ ] Gambar produk full-width, nama, harga, kategori, tags, deskripsi, stok
- [ ] Tombol "Tambah ke Keranjang" dengan loading state & disable saat stok habis / penuh
- [ ] Toggle wishlist (hati) di header detail screen dengan loading state
- [ ] Fetch via `GET /api/products?q=name` — filter by `_id` (tidak ada endpoint detail tersendiri)

**Review Produk**

- [ ] Tombol "Beri Rating" per item di InvoiceScreen saat status `delivered`
- [ ] Bottom sheet modal: star rating 1–5 (tap), kolom komentar, label rating (Sangat Buruk–Sangat Bagus)
- [ ] Submit via `POST /api/reviews { product_id, order_id, rating, comment }`
- [ ] Error inline di modal (kotak merah) — termasuk pesan duplikat dari backend
- [ ] Tombol "Beri Rating" hilang setelah berhasil submit atau terdeteksi sudah pernah diulas
- [ ] List review per produk tampil di bawah setiap item (dari semua user) via `GET /api/reviews?product_id=X`
- [ ] Nama reviewer + bintang + komentar ditampilkan per review

**Alamat Pengiriman**

- [ ] CRUD alamat di tab "Alamat Pengiriman" ProfileScreen
- [ ] List alamat tersimpan (nama, wilayah, detail) dengan tombol edit & hapus
- [ ] Form tambah / edit alamat via bottom sheet modal
- [ ] Cascading region picker: Provinsi → Kabupaten → Kecamatan → Kelurahan (dengan search)
- [ ] Data wilayah dari `GET /api/wilayah/provinsi|kabupaten|kecamatan|desa`
- [ ] Konfirmasi hapus alamat via Alert

**Product & UX**

- [ ] `useInfiniteQuery` + infinite scroll — `GET /api/products` (auto-load via `onEndReached` di FlatList) + `GET /api/orders` (auto-load via `onScroll` di ScrollView); `limit:5`, `skip` per page, `getNextPageParam` dari `count`
- [ ] Skeleton loading — shimmer placeholder (`Animated` + `expo-linear-gradient`) di HomeScreen (product grid 6 card), ProductDetailScreen (hero + konten), ProfileScreen Riwayat tab (4 row)
- [ ] Average rating di ProductCard (⭐ 4.2 · count) dan ProductDetailScreen (5 bintang + avg + jumlah ulasan) dari field `avg_rating` + `review_count`
- [ ] Search history — simpan pencarian terakhir ke `AsyncStorage` (maks 8), tampil saat search fokus + kosong; tap untuk isi ulang, hapus per item, hapus semua

**Realtime & Notifikasi**

- [ ] Notifikasi realtime (Pusher) — subscribe channel user, tampil toast/badge saat ada event baru
- [ ] Expo Push Notifications — notif OS-level saat status order berubah, token management, background handler

**Infrastruktur**

- [ ] Deep linking — buka InvoiceScreen / ProductDetailScreen langsung dari notifikasi atau external link
- [ ] Offline banner (`@react-native-community/netinfo`) — deteksi koneksi hilang, tampil banner, retry otomatis saat online kembali
