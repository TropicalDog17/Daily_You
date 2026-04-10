// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => 'Log hari ini!';

  @override
  String get dailyReminderDescription => 'Ambil log harian Anda…';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get pageHomeTitle => 'Beranda';

  @override
  String get flashbacksTitle => 'Kilas balik';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Kecualikan hari buruk';

  @override
  String get flaskbacksEmpty => 'Belum ada kilas balik…';

  @override
  String get flashbackGoodDay => 'Hari yang baik';

  @override
  String get flashbackRandomDay => 'Hari yang acak';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Weeks Ago',
      one: '$count Week Ago',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Months Ago',
      one: '$count Month Ago',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Years Ago',
      one: '$count Year Ago',
    );
    return '$_temp0';
  }

  @override
  String get pageGalleryTitle => 'Galeri';

  @override
  String get searchLogsHint => 'Cari log…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count logs',
      one: '$count log',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kata',
      one: '$count kata',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Tidak ada log…';

  @override
  String get sortDateTitle => 'Tanggal';

  @override
  String get sortOrderAscendingTitle => 'Naik';

  @override
  String get sortOrderDescendingTitle => 'Turun';

  @override
  String get pageStatisticsTitle => 'Statistik';

  @override
  String get statisticsNotEnoughData => 'Tidak cukup data…';

  @override
  String get statisticsRangeOneMonth => '1 Bulan';

  @override
  String get statisticsRangeSixMonths => '6 Bulan';

  @override
  String get statisticsRangeOneYear => '1 Tahun';

  @override
  String get statisticsRangeAllTime => 'Sepanjang Waktu';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Rangkuman';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Perhari';
  }

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Beruntun Saat ini $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Beruntun terpanjang $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hari dimulai dari hari yang buruk $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Tidak bisa mengakses penyimpanan eksternal';

  @override
  String get errorExternalStorageAccessDescription =>
      'Jika Anda menggunakan penyimpanan jaringan, pastikan layanan ini online dan Anda memiliki akses jaringan.\n\nJika tidak, aplikasi mungkin kehilangan izin untuk folder eksternal. Buka Pengaturan, dan pilih kembali folder eksternal untuk memberikan akses.\n\nPeringatan, perubahan tidak akan disinkronkan sampai Anda mengembalikan akses ke lokasi penyimpanan eksternal!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Lanjutkan dengan database lokal';

  @override
  String get lastModified => 'Diubah';

  @override
  String get writeSomethingHint => 'Tulis sesuatu…';

  @override
  String get titleHint => 'Judul…';

  @override
  String get deleteLogTitle => 'Hapus Log';

  @override
  String get deleteLogDescription => 'Apakah Anda ingin menghapus log ini?';

  @override
  String get deletePhotoTitle => 'Hapus Photo';

  @override
  String get deletePhotoDescription => 'Apakah Anda ingin menghapus foto ini?';

  @override
  String get pageSettingsTitle => 'Pengaturan';

  @override
  String get settingsAppearanceTitle => 'Penampilan';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeAmoled => 'Hitam Amoled';

  @override
  String get settingsFirstDayOfWeek => 'Hari pertama dalam seminggu';

  @override
  String get settingsUseSystemAccentColor => 'Gunakan warna aksen sistem';

  @override
  String get settingsCustomAccentColor => 'Warna aksen khusus';

  @override
  String get settingsShowMarkdownToolbar => 'Tampilkan Markdown Toolbar';

  @override
  String get settingsShowFlashbacks => 'Tampilkan Kilas Balik';

  @override
  String get settingsChangeMoodIcons => 'Ubah ikon suasana hati';

  @override
  String get moodIconPrompt => 'Masukkan ikon';

  @override
  String get settingsFlashbacksViewLayout => 'Tata Letak Tampilan Kilas Balik';

  @override
  String get settingsGalleryViewLayout => 'Tata Letak Tampilan Galeri';

  @override
  String get settingsHideImagesInGallery => 'Sembunyikan Gambar di Galeri';

  @override
  String get viewLayoutList => 'Daftar';

  @override
  String get viewLayoutGrid => 'Kisi';

  @override
  String get settingsNotificationsTitle => 'Pemberitahuan';

  @override
  String get settingsDailyReminderOnboarding =>
      'Aktifkan pengingat harian untuk menjaga konsistensi Anda!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Izin \'jadwalkan alarm\' akan diminta untuk mengirim pengingat pada waktu acak atau pada waktu yang Anda inginkan.';

  @override
  String get settingsDailyReminderTitle => 'Pengingat harian';

  @override
  String get settingsDailyReminderDescription => 'Pengingat lembut setiap hari';

  @override
  String get settingsReminderTime => 'Waktu penginggat';

  @override
  String get settingsFixedReminderTimeTitle => 'Memperbaiki waktu pengingat';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Pilih waktu yang tetap untuk pengingat';

  @override
  String get settingsAlwaysSendReminderTitle => 'Selalu Kirim Pengingat';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Kirim pengingat meskipun catatan sudah dimulai';

  @override
  String get settingsCustomizeNotificationTitle => 'Sesuaikan Notifikasi';

  @override
  String get settingsTemplatesTitle => 'Template';

  @override
  String get settingsDefaultTemplate => 'Template Baku';

  @override
  String get manageTemplates => 'Atur Template';

  @override
  String get addTemplate => 'Tambahkan template';

  @override
  String get newTemplate => 'Template Baru';

  @override
  String get noTemplateTitle => 'Ga ada';

  @override
  String get noTemplatesDescription => 'Belum ada template yang dibuat…';

  @override
  String get templateVariableTime => 'Time';

  @override
  String get templateDefaultTimestampTitle => 'Timestamp';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Day Summary';

  @override
  String get templateDefaultSummaryBody => '### Summary\n- \n\n### Quote\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflection';

  @override
  String get templateDefaultReflectionBody =>
      '### What did you enjoy about today?\n- \n\n### What are you thankful for?\n- \n\n### What are you looking forward to?\n- ';

  @override
  String get settingsStorageTitle => 'Penyimpanan';

  @override
  String get settingsImageQuality => 'Kualitas Gambar';

  @override
  String get imageQualityHigh => 'Gede';

  @override
  String get imageQualityMedium => 'Sedang';

  @override
  String get imageQualityLow => 'Rendah';

  @override
  String get imageQualityNoCompression => 'Tidak dikompres';

  @override
  String get settingsLogFolder => 'Folder Log';

  @override
  String get settingsImageFolder => 'Folder gambar';

  @override
  String get warningTitle => 'Hati hati';

  @override
  String get logFolderWarningDescription =>
      'Jika folder yang dipilih sudah berisi file \'daily_you.db\', itu akan digunakan untuk menimpa log Anda yang ada!';

  @override
  String get errorTitle => 'Eror';

  @override
  String get logFolderErrorDescription => 'Gagal Mengubah Folder Log!';

  @override
  String get imageFolderErrorDescription => 'Gagal Mengubah Folder Gambar!';

  @override
  String get backupErrorDescription => 'Gagal membuat cadangan!';

  @override
  String get restoreErrorDescription => 'Gagal memulihkan cadangan!';

  @override
  String get settingsBackupRestoreTitle => 'Cadangkan & Pulihkan';

  @override
  String get settingsBackup => 'Cadangan';

  @override
  String get settingsRestore => 'Pulihkan';

  @override
  String get settingsRestorePromptDescription =>
      'Memulihkan cadangan akan menimpa data yang sudah ada!';

  @override
  String tranferStatus(Object percent) {
    return 'Mentransfer... $percent';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Membuat cadangan… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Memulihkan Cadangan… $percent%';
  }

  @override
  String get cleanUpStatus => 'Membersihkan…';

  @override
  String get settingsExport => 'Eksport';

  @override
  String get settingsExportToAnotherFormat => 'Ekspor ke Format Lain';

  @override
  String get settingsExportFormatDescription =>
      'Ini tidak boleh digunakan sebagai cadangan!';

  @override
  String get exportLogs => 'Ekspor Log';

  @override
  String get exportImages => 'Ekspor Gambar';

  @override
  String get settingsImport => 'Impor';

  @override
  String get settingsImportFromAnotherApp => 'Impor dari Aplikasi Lain';

  @override
  String get settingsTranslateCallToAction =>
      'Semua orang berhak memiliki akses ke jurnal!';

  @override
  String get settingsHelpTranslate => 'Bantu Terjemahkan';

  @override
  String get importLogs => 'Impor log';

  @override
  String get importImages => 'Impor gambar';

  @override
  String get logFormatTitle => 'Pilih Format';

  @override
  String get logFormatDescription =>
      'Format aplikasi lain mungkin tidak mendukung semua fitur. Harap laporkan masalah apa pun karena format pihak ketiga dapat berubah sewaktu-waktu. Ini tidak akan memengaruhi catatan yang sudah ada!';

  @override
  String get formatDailyYouJson => 'Daily You (JSON)';

  @override
  String get formatDaybook => 'Daybook';

  @override
  String get formatDaylio => 'Daylio';

  @override
  String get formatDiarium => 'Diarium';

  @override
  String get formatDiaro => 'Diaro';

  @override
  String get formatMyBrain => 'My Brain';

  @override
  String get formatOneShot => 'Satu kali photo';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Hapus semua log';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Apakah Anda ingin menghapus semua log Anda?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Masukkan \'$prompt\' untuk mengonfirmasi. Ini tidak dapat dibatalkan!';
  }

  @override
  String get settingsLanguageTitle => 'Bahasa';

  @override
  String get settingsAppLanguageTitle => 'Bahasa Aplikasi';

  @override
  String get settingsOverrideAppLanguageTitle => 'Ganti Bahasa Aplikasi';

  @override
  String get settingsSecurityTitle => 'Keamanan';

  @override
  String get settingsSecurityRequirePassword => 'Wajibkan Kata Sandi';

  @override
  String get settingsSecurityEnterPassword => 'Masukkan Kata Sandi';

  @override
  String get settingsSecuritySetPassword => 'Atur Kata Sandi';

  @override
  String get settingsSecurityChangePassword => 'Ubah Kata Sandi';

  @override
  String get settingsSecurityPassword => 'Kata Sandi';

  @override
  String get settingsSecurityConfirmPassword => 'Konfirmasi Kata Sandi';

  @override
  String get settingsSecurityOldPassword => 'Kata Sandi Lama';

  @override
  String get settingsSecurityIncorrectPassword => 'Kata Sandi Salah';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Kata sandi tidak cocok';

  @override
  String get requiredPrompt => 'Wajib diisi';

  @override
  String get settingsSecurityBiometricUnlock => 'Buka Kunci Biometrik';

  @override
  String get unlockAppPrompt => 'Buka kunci aplikasi';

  @override
  String get settingsAboutTitle => 'Tentang';

  @override
  String get settingsVersion => 'Versi';

  @override
  String get settingsLicense => 'Lisensi';

  @override
  String get licenseGPLv3 => 'GPL -3.0';

  @override
  String get settingsSourceCode => 'Sumber kode';

  @override
  String get settingsMadeWithLove => 'Dibuat dengan ❤️';

  @override
  String get settingsConsiderSupporting => 'pertimbangkan untuk mendukung';

  @override
  String get tagMoodTitle => 'Perasaan';

  @override
  String get settingsMediaTitle => 'Media';

  @override
  String get settingsMediaImportLivePhotoTitle => 'Import Live Photos as video';

  @override
  String get settingsMediaImportLivePhotoDescription =>
      'When possible, preserve Live Photo motion as a paired MOV clip.';

  @override
  String get settingsMediaMaxVideoDurationTitle => 'Max picked video duration';

  @override
  String settingsMediaDurationSeconds(Object seconds) {
    return '$seconds seconds';
  }

  @override
  String get mediaVideoTrimFailed => 'Couldn\'t trim the selected video.';

  @override
  String mediaVideoTrimmedToDuration(Object seconds) {
    return 'Trimmed video to $seconds seconds.';
  }

  @override
  String get compilationTitle => 'Compilation';

  @override
  String get compilationRangeTitle => 'Range';

  @override
  String get compilationRangeWeek => 'Week';

  @override
  String get compilationRangeMonth => 'Month';

  @override
  String get compilationRangeYear => 'Year';

  @override
  String get compilationRangeCustom => 'Custom';

  @override
  String compilationRangeValue(Object end, Object start) {
    return '$start - $end';
  }

  @override
  String get compilationClipDurationTitle => 'Clip duration';

  @override
  String compilationSelectedClipCount(Object count) {
    return 'Selected clips: $count';
  }

  @override
  String get compilationIncludedEntriesTitle => 'Included entries';

  @override
  String get compilationNoEntriesInRange =>
      'No entries with media in this range.';

  @override
  String get compilationNoTextFallback => '(No text)';

  @override
  String get compilationGenerateAction => 'Generate';

  @override
  String get compilationShareAction => 'Share';

  @override
  String get compilationSaveAction => 'Save';

  @override
  String get compilationDiscardAction => 'Discard';

  @override
  String get compilationShareText => 'Daily You compilation';

  @override
  String get compilationSelectAtLeastOneEntry =>
      'Select at least one entry with media.';

  @override
  String get compilationProgressPreparing => 'Preparing clips...';

  @override
  String compilationProgressEncodingClip(Object current, Object total) {
    return 'Encoding clip $current/$total';
  }

  @override
  String get compilationProgressRenderingFinal => 'Rendering final video';

  @override
  String get compilationProgressReady => 'Compilation ready';

  @override
  String compilationProgressPercent(Object percent) {
    return '$percent%';
  }

  @override
  String compilationFailed(Object error) {
    return 'Compilation failed: $error';
  }

  @override
  String get savedToGalleryMessage => 'Saved to gallery.';

  @override
  String get yearInReviewTitle => 'Year in Review';

  @override
  String get yearInReviewCardSubtitle =>
      'Generate a highlight reel from your entries.';

  @override
  String get yearInReviewBannerTitle => 'Year in Review is ready';

  @override
  String get yearInReviewBannerSubtitle =>
      'Create your highlight reel from last year.';

  @override
  String get yearInReviewSelectYearTitle => 'Select year';

  @override
  String yearInReviewEntriesCount(Object count) {
    return 'Entries: $count';
  }

  @override
  String yearInReviewEntriesWithMediaCount(Object count) {
    return 'Entries with media: $count';
  }

  @override
  String yearInReviewRange(Object end, Object start) {
    return 'Range: $start - $end';
  }

  @override
  String get yearInReviewSummaryTitle => 'Year summary';

  @override
  String yearInReviewActiveDaysCount(Object count) {
    return 'Active days: $count';
  }

  @override
  String get yearInReviewGenerateAction => 'Generate Year in Review';

  @override
  String yearInReviewSelectedHighlights(Object count) {
    return 'Selected highlights: $count';
  }

  @override
  String get yearInReviewNoMediaEntries =>
      'No media entries found for this year.';

  @override
  String get yearInReviewShareText => 'My Daily You Year in Review';

  @override
  String get rewindTitle => 'Rewind';

  @override
  String get rewindShowAnother => 'Show another';

  @override
  String get rewindOpenMemoryHint => 'Tap to open this memory.';

  @override
  String get homeEmptyStateMessage =>
      'No entries yet. Tap + to start your first memory.';

  @override
  String get statsUnlockAfterWeek =>
      'Keep going! Stats unlock after a week of entries.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Daily You';

  @override
  String get onboardingWelcomeSubtitle => 'Every day is worth remembering.';

  @override
  String get onboardingWelcomeBody =>
      'Capture one meaningful moment each day and keep it safely on your device.';

  @override
  String get onboardingCaptureTitle => 'Capture Your Day';

  @override
  String get onboardingCaptureSubtitle => 'Photo, video, or a few words.';

  @override
  String get onboardingCaptureBody =>
      'Use Daily You your way: quick note, snapshot, or short clip for a one-second-everyday style memory.';

  @override
  String get onboardingPrivacyTitle => 'Private by Default';

  @override
  String get onboardingPrivacySubtitle => 'No account required.';

  @override
  String get onboardingPrivacyBody =>
      'Everything stays on your device. No cloud dependency, no tracking, no ads.';

  @override
  String get onboardingGetStartedTitle => 'Get Started';

  @override
  String get onboardingEnableReminderPrompt => 'Enable daily reminders?';

  @override
  String get onboardingDailyReminderTitle => 'Daily reminder';

  @override
  String get onboardingDailyReminderSubtitle =>
      'A gentle nudge to log your day.';

  @override
  String get onboardingContinue => 'Continue';

  @override
  String get onboardingCreateFirstEntry => 'Create your first entry';
}
