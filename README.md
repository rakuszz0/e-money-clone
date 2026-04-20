# 📱 E-Wallet App

Aplikasi E-Wallet modern yang dibangun menggunakan **Flutter**, dirancang dengan antarmuka yang bersih dan fitur finansial yang komprehensif. Aplikasi ini mendukung akses simulasi ke berbagai bank dan layanan keuangan.

## 🚀 Fitur Utama

### 🏠 Beranda (Home)
- **Manajemen Saldo**: Pantau total saldo Anda dengan tampilan kartu yang elegan.
- **Top-up**: Tambahkan saldo ke dompet digital Anda dengan mudah.
- **Transfer**: Kirim uang ke pengguna lain atau rekening bank.
- **Withdraw**: Tarik saldo ke rekening bank terdaftar.

### 🔍 QRIS Scanner
- **Scan & Pay**: Simulasi pemindaian kode QRIS untuk pembayaran instan di berbagai merchant.
- **Upload Gallery**: Mendukung pembayaran melalui unggahan gambar QR dari galeri.

### 📊 Riwayat Transaksi
- **Log Detail**: Pantau semua aktivitas keuangan Anda.
- **Fitur Sort & Filter**: Urutkan berdasarkan tanggal atau nominal, dan filter berdasarkan jenis layanan (Top Up, Transfer, QRIS, dll).

### 💰 Keuangan (Finance)
- **Sumber Dana**: Kelola berbagai sumber dana seperti Bank BCA, Kartu Kredit, dan lainnya.
- **E-Wallet Coins**: Dapatkan poin reward dari setiap transaksi yang dilakukan.
- **Simpanan & Asuransi**: Akses layanan perlindungan dan tabungan masa depan.
- **Pinjaman**: Layanan pengajuan dana cepat yang terintegrasi.

### 👤 Profil
- **Manajemen Akun**: Ubah detail profil dan atur keamanan PIN.
- **Status Member**: Tampilan eksklusif untuk Member Premium.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Dart)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **UI Design**: Material 3
- **Utility**: [Intl](https://pub.dev/packages/intl) untuk pemformatan mata uang.

## 📦 Struktur Proyek

```text
lib/
├── screens/       # Halaman utama aplikasi (Home, History, Finance, dll)
├── widgets/       # Komponen UI yang dapat digunakan kembali
├── models/        # Model data transaksi dan pengguna
├── services/      # Logika bisnis dan integrasi API (Simulasi)
├── app.dart       # Konfigurasi navigasi utama
└── main.dart      # Titik masuk aplikasi
```

## 🏁 Cara Menjalankan

1. **Pastikan Flutter SDK sudah terinstal.**
2. **Clone repositori ini.**
3. **Jalankan perintah berikut di terminal:**
   ```bash
   flutter pub get
   flutter run
   ```
4. **Untuk menjalankan di Web:**
   ```bash
   flutter run -d chrome
   ```

---
Dibuat dengan ❤️ menggunakan Flutter.
