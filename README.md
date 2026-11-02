# Kedai-Ku

Aplikasi pemesanan untuk kafe dan warung kecil. Pembeli memilih menu, mengatur varian,
dan memesan untuk diambil pada jam tertentu. Pemilik menerima pesanan dalam satu antrean.

- **Domain:** Local Business Solutions
- **Stack:** Flutter (Android), SQLite lokal, Supabase (REST)
- **Status:** G1 (Fondasi) sedang dikerjakan

## Struktur

```
lib/
  main.dart
  data/        sumber data (sementara di memori)
  features/
    menu/      model dan layar menu
    cart/      keranjang
    orders/    pesanan dan status
docs/sketsa/   foto sketsa layar
```

## Menjalankan

```
flutter pub get
flutter run
```