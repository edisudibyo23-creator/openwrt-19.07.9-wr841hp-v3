# Eksperimen backport OpenWrt 19.07.9 — TL-WR841HP v3

**Status: kerangka eksperimen, belum merupakan firmware yang terverifikasi. Jangan flash hasil build sebelum validasi perangkat dan image dilakukan.**

Perangkat:
- TP-Link TL-WR841HP v3
- SoC QCA9533, RAM 64 MB, flash 8 MB
- Dukungan resmi upstream tercatat mulai OpenWrt 22.03.0, target `ath79/generic`.
- OpenWrt 19.07.9 tidak mencantumkan perangkat ini sebagai profil resmi.

## Apa yang perlu di-backport

1. **DTS perangkat**: biasanya `target/linux/ath79/dts/qca9533_tplink_tl-wr841hp-v3.dts`, termasuk LED, tombol, Ethernet/switch, Wi-Fi calibration/ART partition, dan `compatible`.
2. **Pendaftaran image perangkat**: entri `tplink_tl-wr841hp-v3` di file image TP-Link ath79 (pada source lebih baru `target/linux/ath79/image/generic-tp-link.mk`), termasuk SoC `qca9533`, varian `v3`, dan hardware ID `0x08411003`. Nama file dan macro image harus disesuaikan dengan struktur 19.07.9.
3. **Dukungan DTS/Makefile**: pastikan DTS masuk daftar build kernel untuk target `ath79/generic`; pastikan file DTS menyertakan include dan label yang memang tersedia pada kernel/source 19.07.9.
4. **Profil target dan metadata**: profil `CONFIG_TARGET_ath79_generic_DEVICE_tplink_tl-wr841hp-v3` (jika tersedia pada build system hasil backport), device name, image recipe, dan supported-device metadata harus konsisten.
5. **openNDS**: pastikan paket `opennds` benar-benar tersedia pada feeds yang dipakai dan dependensinya kompatibel dengan kernel/userspace 19.07.9. Workflow sengaja gagal bila paket tidak tersedia. Jangan menganggap sekadar menambahkan nama paket cukup.

Commit upstream yang menjadi titik awal dukungan resmi:  
https://git.openwrt.org/?p=openwrt/openwrt.git;a=commit;h=c5235f6b2441a6b531622b76b66c354896c0dae0

Techdata perangkat:  
https://openwrt.org/toh/hwdata/tp-link/tp-link_tl-wr841hp_v3

## Cara menggunakan

1. Buat repository GitHub baru dan unggah isi folder ini.
2. Tambahkan patch backport yang sudah Anda audit ke folder `patches/`. Patch harus berformat `git format-patch` atau unified diff yang dapat diterapkan dengan `patch -p1`.
3. Buka **Actions** → **Build experimental OpenWrt 19.07.9** → **Run workflow**.
4. Workflow mengunduh source tag `v19.07.9`, menginisialisasi feeds, mencoba menerapkan patch, memeriksa profil dan paket, lalu baru menjalankan build.
5. Jika validasi gagal, baca log; kegagalan adalah perilaku yang diharapkan sampai semua dukungan benar-benar di-backport.
6. Jika build sukses, ambil artifact `wr841hp-v3-openwrt-19.07.9-experimental`. Periksa image, checksum, ukuran, dan formatnya sebelum mempertimbangkan flashing.

## Mengapa folder patches kosong?

Patch dukungan perangkat ditambahkan setelah 19.07.9 dan perlu di-port secara manual ke layout source lama. Mengambil DTS dan satu entri image dari versi baru secara membabi buta bisa gagal karena perubahan kernel, include DTS, macro image, metadata perangkat, atau struktur target. Kerangka ini tidak menyisipkan patch yang belum diuji dan tidak mengklaim dukungan sudah lengkap.

## Catatan ruang flash

Flash 8 MB sangat ketat. LuCI dan openNDS bersama dependensinya mungkin tidak muat. Jangan membuang pemeriksaan ukuran atau mengabaikan error `Image file ... is too big`. Bila image tidak muat, build dianggap gagal dan tidak dipublikasikan sebagai artifact firmware.

## Peringatan

OpenWrt 19.07.9 sudah usang dan tidak menerima pembaruan keamanan. Build ini hanya cocok untuk eksperimen/lab. Simpan backup firmware dan konfigurasi, siapkan pemulihan serial/TFTP sesuai dokumentasi perangkat, dan jangan flash jika model, hardware revision, image type, atau checksum belum dipastikan.
