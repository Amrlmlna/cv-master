// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get welcomeBack => 'Selamat Datang Kembali';

  @override
  String get signInSubtitle => 'Masuk untuk sinkronisasi CV di semua perangkat';

  @override
  String get email => 'Email';

  @override
  String get password => 'Kata Sandi';

  @override
  String get login => 'Masuk';

  @override
  String get or => 'ATAU';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get dontHaveAccount => 'Belum punya akun?';

  @override
  String get signUp => 'Daftar';

  @override
  String get createAccount => 'Buat Akun';

  @override
  String get createAccountSubtitle =>
      'Mulai perjalanan karirmu yang lebih baik';

  @override
  String get fullName => 'Nama Lengkap';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun?';

  @override
  String get logIn => 'Masuk';

  @override
  String get pleaseEnterEmail => 'Mohon masukkan email Anda';

  @override
  String get pleaseEnterPassword => 'Mohon masukkan kata sandi Anda';

  @override
  String get pleaseEnterName => 'Mohon masukkan nama Anda';

  @override
  String get passwordMinLength => 'Kata sandi minimal 6 karakter';

  @override
  String get accountCreatedSuccess => 'Akun berhasil dibuat!';

  @override
  String get welcomeBackSuccess => 'Selamat datang kembali!';

  @override
  String get googleSignInSuccess => 'Berhasil masuk dengan Google!';

  @override
  String googleSignInError(Object error) {
    return 'Gagal masuk dengan Google: $error';
  }

  @override
  String get errorDetailsCopied => 'Detail kesalahan disalin ke papan klip';

  @override
  String get technicalDetails => 'DETAIL TEKNIS';

  @override
  String get goHome => 'Ke Beranda';

  @override
  String get close => 'Tutup';

  @override
  String get rewrite => 'Tulis Ulang';

  @override
  String get typeHere => 'Ketik di sini...';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get bold => 'Tebal';

  @override
  String get italic => 'Miring';

  @override
  String get header => 'Judul';

  @override
  String get locationLabel => 'Lokasi (Cari Kota/Kabupaten)';

  @override
  String get locationHint => 'Cth: Palu -> Sulawesi Tengah, Kota Palu';

  @override
  String get schoolLabel => 'Sekolah / Universitas';

  @override
  String get schoolHint => 'Cth: Universitas Indonesia';

  @override
  String get requiredField => 'Wajib diisi';

  @override
  String get syncData => 'Sinkronisasi Data';

  @override
  String get logOut => 'Keluar';

  @override
  String get completeProfileFirst => 'Lengkapi profil dulu untuk hasil terbaik';

  @override
  String get validatingData => 'Memvalidasi data...';

  @override
  String get preparingProfile => 'Menyiapkan profil...';

  @override
  String get continuingToForm => 'Melanjutkan ke form...';

  @override
  String analyzeProfileError(Object error) {
    return 'Gagal menganalisis profil: $error';
  }

  @override
  String get fillJobTitle => 'Isi judul pekerjaan dulu!';

  @override
  String get scanJobPosting => 'Pindai Lowongan Kerja';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get ocrScanning => 'PEMINDAIAN OCR';

  @override
  String get analyzingText => 'Menganalisis teks...';

  @override
  String get identifyingVacancy => 'Mengidentifikasi lowongan...';

  @override
  String get organizingData => 'Menyusun data...';

  @override
  String get finalizing => 'Finalisasi...';

  @override
  String get jobExtractionSuccess => 'Lowongan kerja berhasil diekstrak!';

  @override
  String get noTextFound => 'Tidak ada teks ditemukan dalam gambar';

  @override
  String get jobExtractionFailed => 'Gagal mengekstrak lowongan kerja';

  @override
  String get targetPosition => 'Target Posisi';

  @override
  String get continueToReview => 'Lanjut: Review Data';

  @override
  String get whatJobApply => 'Mau lamar kerja apa?';

  @override
  String get aiHelpCreateCV =>
      'AI bakal bantuin bikin CV yang pas banget buat tujuan ini.';

  @override
  String get positionHint => 'Posisi (Misal: UI Designer)';

  @override
  String get companyHint => 'Nama Perusahaan (Opsional)';

  @override
  String get requiredFieldFriendly => 'Wajib diisi ya';

  @override
  String get jobDetailLabel => 'Detail / Kualifikasi (Opsional)';

  @override
  String get jobDetailHint =>
      'Paste deskripsi posisi, persyaratan, atau kualifikasi di sini...';

  @override
  String get reviewedByAI => 'Data & Summary telah disesuaikan oleh AI';

  @override
  String get autoFillFromMaster =>
      'Data otomatis diisi dari Master Profile kamu';

  @override
  String get jobInputMissing => 'Error: Job Input tidak ditemukan';

  @override
  String generateSummaryFailed(Object error) {
    return 'Gagal membuat ringkasan: $error';
  }

  @override
  String get masterProfileUpdated => 'Master Profile berhasil diperbarui';

  @override
  String get reviewData => 'Tinjau Data';

  @override
  String get continueChooseTemplate => 'Lanjut: Pilih Template';

  @override
  String get tailoredDataMessage =>
      'Data ini sudah disesuaikan AI agar relevan dengan posisi yang kamu tuju. Cek lagi ya!';

  @override
  String get personalInfo => 'Informasi Personal';

  @override
  String get professionalSummary => 'Ringkasan Profesional';

  @override
  String get workExperience => 'Pengalaman Kerja';

  @override
  String get educationHistory => 'Riwayat Pendidikan';

  @override
  String get certifications => 'Sertifikasi';

  @override
  String get skills => 'Keahlian (Skills)';

  @override
  String get summaryHint =>
      'Tulis ringkasan profesional Anda secara singkat...';

  @override
  String get summaryEmpty => 'Ringkasan tidak boleh kosong';

  @override
  String get generateWithAI => 'Buat dengan AI';

  @override
  String get phoneNumber => 'Nomor HP';

  @override
  String get add => 'Tambah';

  @override
  String get noExperience => 'Belum ada pengalaman kerja.';

  @override
  String get present => 'Sekarang';

  @override
  String get schoolName => 'Nama Sekolah';

  @override
  String get degree => 'Gelar / Jurusan';

  @override
  String get degreeHint => 'Sarjana Komputer';

  @override
  String get startDate => 'Masuk';

  @override
  String get endDate => 'Lulus';

  @override
  String get year => 'Tahun';

  @override
  String get addEducation => 'TAMBAH PENDIDIKAN';

  @override
  String get editEducation => 'EDIT PENDIDIKAN';

  @override
  String get cancelAllCaps => 'BATAL';

  @override
  String get saveAllCaps => 'SIMPAN';

  @override
  String get noEducation => 'Belum ada riwayat pendidikan.';

  @override
  String get certificationsLicenses => 'Sertifikasi & Lisensi';

  @override
  String get noCertifications => 'Belum ada sertifikasi.';

  @override
  String get addSkill => 'Tambah Skill';

  @override
  String get skillHint => 'contoh: Flutter, Leadership';

  @override
  String get noSkills => 'Belum ada skill.';

  @override
  String get thinking => 'Berpikir...';

  @override
  String get writing => 'Menulis...';

  @override
  String get fillDescriptionFirst =>
      'Isi deskripsi dulu baru bisa di-rewrite AI!';

  @override
  String get jobTitle => 'Posisi / Jabatan';

  @override
  String get company => 'Perusahaan';

  @override
  String get companyPlaceholder => 'PT Teknologi Maju';

  @override
  String get selectDate => 'Pilih Tanggal';

  @override
  String get untilNow => 'Sampai Sekarang';

  @override
  String get shortDescription => 'Deskripsi Singkat';

  @override
  String get improving => 'Memperbaiki...';

  @override
  String get rephrasing => 'Menyusun ulang...';

  @override
  String get rewriteAI => 'Rewrite AI';

  @override
  String get descriptionHint =>
      'Jelaskan tanggung jawab utama dan pencapaianmu...';

  @override
  String get addExperience => 'TAMBAH PENGALAMAN';

  @override
  String get editExperienceTitle => 'EDIT PENGALAMAN';

  @override
  String get addCertification => 'Tambah Sertifikasi';

  @override
  String get editCertification => 'Edit Sertifikasi';

  @override
  String get certificationName => 'Nama Sertifikasi';

  @override
  String get issuer => 'Penerbit (Issuer)';

  @override
  String get dateLabel => 'Tanggal:';
}
