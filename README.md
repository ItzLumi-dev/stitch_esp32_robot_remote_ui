# Iris ESP32 Robot Remote UI (Flutter Native)

Aplikasi mobile native Flutter untuk kendali robot ESP32 berbasis **Tactile Mecha-OS Light** (desain Google Stitch murni) dengan komunikasi **MQTT over Secure WebSocket (WSS)** end-to-end.

Tampilan antarmuka dikunci secara **Landscape tanpa scroll** (fit 100% viewport) dengan ergonomi kontrol dual-thumb ala handheld gaming console (Nintendo Switch OLED / Steam Deck).

---

## 🚀 Fitur Utama & Logika Backend MQTT

### 1. Konfigurasi Koneksi MQTT (WSS)
- **Broker**: `lf96fe6f.ala.asia-southeast1.emqxsl.com`
- **Port**: `8084` (SSL / WSS)
- **Username**: `IoTIris`
- **Password**: `IoTIris123`
- **Status Koneksi**: Ditampilkan secara real-time pada Header Bar (`ONLINE`, `CONNECTING`, `OFFLINE`).
- **Auto-Reconnect**: Otomatis mencoba menyambung kembali setiap 4 detik bila koneksi terputus.

### 2. Logika Pengiriman Data (Publish)
- **Topik Kendali**: `garuda/iot_iris_ab5c9/kendali`
  - **Virtual Joystick / D-Pad**:
    - Ditekan: `MAJU`, `MUNDUR`, `KIRI`, `KANAN`
    - Dilepas: `STOP`
  - **Tombol Aktuator**:
    - `CAPIT_NAIK`
    - `CAPIT_TURUN`
    - `CAPIT_BUKA`
    - `CAPIT_TUTUP`
  - **Emergency Stop (E-STOP)**:
    - Mengirim payload: `STOP`
- **Topik Kecepatan Motor**: `garuda/iot_iris_ab5c9/kendali/speed`
  - **Slider PWM & Tombol Preset (25%, 50%, 75%, MAX)**:
    - Mengirim nilai integer dalam bentuk string (`0` - `255`).

### 3. Logika Penerimaan Data (Subscribe)
- **Topik Suhu**: `garuda/iot_iris_ab5c9/sensor/suhu`
  - Payload: angka desimal (contoh `"32.5"`).
  - Menampilkan angka suhu hero display dan memperbarui grafik sparkline suhu secara live.
  - **Aturan Warna Status**:
    - **Normal** (< 35°C): Badge Cyan / Biru Muda.
    - **Hangat** (35-40°C): Badge Oranye / Amber.
    - **Bahaya Panas** (> 40°C): Badge Merah Terang dengan indikator alert.
- **Topik Diagnostik**: `garuda/iot_iris_ab5c9/status/diag`
  - Payload: status string (contoh `"SD:OK,RTC:OK"`).
  - Ditampilkan pada Header Bar dan Mini Telemetry Strip.

### 4. Logika Kalkulasi Ping
- Timer berkala mengirimkan pesan `PING` ke `garuda/iot_iris_ab5c9/kendali` setiap **2 detik**.
- Mencatat timestamp pengiriman (`_lastPingSentTime`).
- Setiap kali aplikasi menerima balasan apapun pada topik diagnostik (`garuda/iot_iris_ab5c9/status/diag`), latensi dihitung:
  $$\text{Ping (ms)} = \text{Waktu Sekarang} - \text{Timestamp Pengiriman}$$
- Nilai latensi langsung diperbarui pada badge Header Bar dan Strip Telemetri.

### 5. Terminal Log MQTT & MicroSD
- Mencatat setiap aktivitas `TX >` (Publish), `RX <` (Subscribe), dan `ERR >` (Error) secara real-time.
- **Batas Maksimal 18 Baris**: Menghapus baris terlama (index 0) secara otomatis jika panjang log melebihi 18 baris agar tampilan tetap rapi tanpa scroll tak terbatas.
- Terdapat tombol **CLEAR** untuk membersihkan log terminal secara instan.

---

## 📂 Struktur Proyek

```
stitch_esp32_robot_remote_ui/
├── pubspec.yaml                 # Dependensi Flutter (mqtt_client, provider, google_fonts, intl)
├── android/
│   └── app/src/main/AndroidManifest.xml  # Orientasi landscape & izin internet
├── ios/
│   └── Runner/Info.plist        # Konfigurasi orientasi landscape iOS
├── lib/
│   ├── main.dart                # Entrypoint, orientasi landscape & Provider setup
│   ├── constants/
│   │   ├── app_colors.dart      # Palet warna murni Tactile Mecha-OS Light
│   │   ├── app_styles.dart      # Tipografi (Space Grotesk, Plus Jakarta Sans, JetBrains Mono)
│   │   └── mqtt_config.dart     # Konfigurasi Broker & Topik MQTT
│   ├── models/
│   │   └── terminal_log.dart    # Model data log terminal
│   ├── services/
│   │   └── mqtt_service.dart    # Service MQTT WSS, state management, auto-reconnect, ping
│   ├── screens/
│   │   └── dashboard_screen.dart# Tampilan utama cockpit landscape tanpa scroll
│   └── widgets/
│       ├── header_bar.dart      # Tactical header bar (status MQTT, ping, diag, E-Stop)
│       ├── footer_bar.dart      # Bottom handheld status ribbon
│       ├── dpad_controller.dart # Virtual D-Pad dengan event touch onDown / onUp (STOP)
│       ├── joystick_controller.dart # Joystick 360° dengan auto-recenter & heading vector
│       ├── drive_control_card.dart  # Flank kiri: Switcher D-Pad / Joystick & status arah
│       ├── temperature_card.dart    # Telemetri DS18B20, grafik sparkline & simulasi panas
│       ├── speed_slider_card.dart   # Slider PWM 0-255 & preset 25%, 50%, 75%, MAX
│       ├── terminal_card.dart       # Layar terminal gelap 18 baris & mini telemetry
│       └── actuator_card.dart       # Flank kanan: Kontrol Lengan (Naik/Turun) & Capit (Buka/Jepit)
├── code.html                    # Desain asli dari Google Stitch
└── DESIGN.md                    # Panduan desain Tactile Mecha-OS Light
```

---

## 🛠️ Cara Menjalankan Proyek

1. **Pastikan Flutter SDK terinstal** di komputer Anda (Flutter >= 3.0.0).
2. Buka terminal di folder proyek ini:
   ```bash
   cd stitch_esp32_robot_remote_ui
   ```
3. Unduh semua paket dependensi:
   ```bash
   flutter pub get
   ```
4. Sambungkan perangkat Android / Emulator (atau pilih Chrome/Windows):
   ```bash
   flutter run
   ```
   *Aplikasi akan langsung terbuka dalam posisi Landscape secara otomatis!*
