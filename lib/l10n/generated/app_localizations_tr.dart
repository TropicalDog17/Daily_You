// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => 'Bugünü Kayıtla!';

  @override
  String get dailyReminderDescription => 'Günlük kaydı oluştur…';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get pageHomeTitle => 'Ana';

  @override
  String get flashbacksTitle => 'Geçmiş';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Kötü günleri çıkar';

  @override
  String get flaskbacksEmpty => 'Henüz geçmiş yok…';

  @override
  String get flashbackGoodDay => 'İyi Bir Gün';

  @override
  String get flashbackRandomDay => 'Rastgele Bir Gün';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hafta önce',
      one: '$count hafta önce',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ay önce',
      one: '$count ay önce',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yıl önce',
      one: '$count yıl önce',
    );
    return '$_temp0';
  }

  @override
  String get pageGalleryTitle => 'Galeri';

  @override
  String get searchLogsHint => 'Kayıt ara…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kayıt',
      one: '$count kayıt',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sözcük',
      one: '$count sözcük',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Kayıt yok…';

  @override
  String get sortDateTitle => 'Tarih';

  @override
  String get sortOrderAscendingTitle => 'Artan';

  @override
  String get sortOrderDescendingTitle => 'Azalan';

  @override
  String get pageStatisticsTitle => 'Sayımlama';

  @override
  String get statisticsNotEnoughData => 'Yeterli veri yok…';

  @override
  String get statisticsRangeOneMonth => '1 ay';

  @override
  String get statisticsRangeSixMonths => '6 ay';

  @override
  String get statisticsRangeOneYear => '1 yıl';

  @override
  String get statisticsRangeAllTime => 'Tüm zamanlar';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Özeti';
  }

  @override
  String chartByDayTitle(Object tag) {
    return 'Günlük $tag';
  }

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mevcut seri $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'En uzun seri $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Geçen son kötü gün $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Harici depolamaya erişilemiyor';

  @override
  String get errorExternalStorageAccessDescription =>
      'Ağ depolama alanını kullanıyorsanız, hizmetin çevrim içi olduğundan ve ağ erişiminiz olduğundan emin olun.\n\nAksi takdirde, uygulama harici klasör için izinleri kaybetmiş olabilir. Ayarlara gidin ve erişim vermek için harici klasörü yeniden seçin.\n\nUyarı, harici depolama konumuna erişimi geri yükleyene kadar değişiklikler eşlenemeyecektir!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Yerel veri tabanı ile devam edin';

  @override
  String get lastModified => 'Değişiklik';

  @override
  String get writeSomethingHint => 'Bir şeyler yaz…';

  @override
  String get titleHint => 'Başlık…';

  @override
  String get deleteLogTitle => 'Kaydı sil';

  @override
  String get deleteLogDescription => 'Bu kaydı silmek istiyor musun?';

  @override
  String get deletePhotoTitle => 'Fotoğrafı sil';

  @override
  String get deletePhotoDescription => 'Bu fotoğrafı silmek istiyor musun?';

  @override
  String get pageSettingsTitle => 'Ayarlar';

  @override
  String get settingsAppearanceTitle => 'Görünüm';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistem';

  @override
  String get themeLight => 'Aydınlık';

  @override
  String get themeDark => 'Karanlık';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Haftanın ilk günü';

  @override
  String get settingsUseSystemAccentColor => 'Sistem vurgu rengini kullan';

  @override
  String get settingsCustomAccentColor => 'Özel vurgu rengi';

  @override
  String get settingsShowMarkdownToolbar => 'Markdown araç çubuğunu göster';

  @override
  String get settingsShowFlashbacks => 'Bilgi Kartlarını Göster';

  @override
  String get settingsChangeMoodIcons => 'Ruh hali simgelerini değiştir';

  @override
  String get moodIconPrompt => 'Bir simge belirleyin';

  @override
  String get settingsFlashbacksViewLayout => 'Geçmiş Görünüm Düzeni';

  @override
  String get settingsGalleryViewLayout => 'Galeri Görünüm Düzeni';

  @override
  String get settingsHideImagesInGallery => 'Görüntüleri galeride gizle';

  @override
  String get viewLayoutList => 'Liste';

  @override
  String get viewLayoutGrid => 'Izgara';

  @override
  String get settingsNotificationsTitle => 'Bildirimler';

  @override
  String get settingsDailyReminderOnboarding =>
      'Süreklilik için günlük hatırlatıcıları etkinleştirin!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      '\'Takvim alarmları\' izninden bildirimi rastgele bir anda veya tercih ettiğiniz zamanda göndermesi isteyecektir.';

  @override
  String get settingsDailyReminderTitle => 'Günlük Hatırlatma';

  @override
  String get settingsDailyReminderDescription => 'Her gün nazik bir hatırlatma';

  @override
  String get settingsReminderTime => 'Hatırlatma zamanı';

  @override
  String get settingsFixedReminderTimeTitle => 'Sabit hatırlatma zamanı';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Hatırlatma için sabit bir zaman seçin';

  @override
  String get settingsAlwaysSendReminderTitle => 'Daima hatırlatma gönder';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Bir kayıt açılmış olsa bile hatırlatma gönder';

  @override
  String get settingsCustomizeNotificationTitle => 'Bildirimleri özelleştirin';

  @override
  String get settingsTemplatesTitle => 'Şablonlar';

  @override
  String get settingsDefaultTemplate => 'Varsayılan şablon';

  @override
  String get manageTemplates => 'Şablonları yönet';

  @override
  String get addTemplate => 'Bir şablon ekle';

  @override
  String get newTemplate => 'Yeni şablon';

  @override
  String get noTemplateTitle => 'Hiçbiri';

  @override
  String get noTemplatesDescription => 'Henüz şablon oluşturulmadı…';

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
  String get settingsStorageTitle => 'Depolama';

  @override
  String get settingsImageQuality => 'Görüntü kalitesi';

  @override
  String get imageQualityHigh => 'Yüksek';

  @override
  String get imageQualityMedium => 'Orta';

  @override
  String get imageQualityLow => 'Düşük';

  @override
  String get imageQualityNoCompression => 'Sıkıştırmadan';

  @override
  String get settingsLogFolder => 'Kayıt klasörü';

  @override
  String get settingsImageFolder => 'Görüntü klasörü';

  @override
  String get warningTitle => 'Uyarı';

  @override
  String get logFolderWarningDescription =>
      'Seçilen klasör zaten bir \'Daily_you.db\' dosyası içeriyorsa, mevcut günlüklerinizin üzerine yazmak için kullanılacaktır!';

  @override
  String get errorTitle => 'Hata';

  @override
  String get logFolderErrorDescription => 'Günlük klasörü değiştirilemedi!';

  @override
  String get imageFolderErrorDescription => 'Görüntü klasörü değiştirilemedi!';

  @override
  String get backupErrorDescription => 'Yedekleme oluşturulamadı!';

  @override
  String get restoreErrorDescription => 'Yedekleme geri yüklenemedi!';

  @override
  String get settingsBackupRestoreTitle => 'Yedekleme ve Geri yükleme';

  @override
  String get settingsBackup => 'Yedekle';

  @override
  String get settingsRestore => 'Geri yükleme';

  @override
  String get settingsRestorePromptDescription =>
      'Bir yedeklemeyi geri yüklemek mevcut verilerinizin üzerine yazacaktır!';

  @override
  String tranferStatus(Object percent) {
    return 'Aktarılıyor… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Yedekleme oluşturuluyor… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Yedekleme geri yükleniyor… $percent%';
  }

  @override
  String get cleanUpStatus => 'Temizleniyor…';

  @override
  String get settingsExport => 'Dışa aktar';

  @override
  String get settingsExportToAnotherFormat => 'Başka Bir Formatta Dışarı Aktar';

  @override
  String get settingsExportFormatDescription =>
      'Bu yedek olarak kullanılmamalıdır!';

  @override
  String get exportLogs => 'Kayıtları dışa aktar';

  @override
  String get exportImages => 'Görselleri dışa aktar';

  @override
  String get settingsImport => 'İçe aktar';

  @override
  String get settingsImportFromAnotherApp => 'Başka bir uygulamadan içe aktar';

  @override
  String get settingsTranslateCallToAction => 'Herkes bir günlüğe erişebilir!';

  @override
  String get settingsHelpTranslate => 'Çeviri yardımı';

  @override
  String get importLogs => 'Kayıtları içe aktar';

  @override
  String get importImages => 'Görselleri içe aktar';

  @override
  String get logFormatTitle => 'Biçim seçin';

  @override
  String get logFormatDescription =>
      'Başka bir uygulamanın formatı tüm özellikleri desteklemeyebilir. Üçüncü taraf formatlar her an değişebileceğinden dolayı lütfen herhangi bir sorunu bildirin. Bu mevcut günlükleri etkilemez!';

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
  String get formatOneShot => 'Tek çekim';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Tüm kayıtları sil';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Tüm kayıtlarınızı silmek istiyor musunuz?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Onaylamak için \'$prompt\' girin. Bu geri alınamaz!';
  }

  @override
  String get settingsLanguageTitle => 'Dil';

  @override
  String get settingsAppLanguageTitle => 'Uygulama Dili';

  @override
  String get settingsOverrideAppLanguageTitle => 'Uygulama Dilini Özelleştir';

  @override
  String get settingsSecurityTitle => 'Güvenlik';

  @override
  String get settingsSecurityRequirePassword => 'Şifre Gerektir';

  @override
  String get settingsSecurityEnterPassword => 'Şifre Gir';

  @override
  String get settingsSecuritySetPassword => 'Şifre Belirle';

  @override
  String get settingsSecurityChangePassword => 'Şifre Değiştir';

  @override
  String get settingsSecurityPassword => 'Şifre';

  @override
  String get settingsSecurityConfirmPassword => 'Şifreyi Doğrula';

  @override
  String get settingsSecurityOldPassword => 'Eski Şifre';

  @override
  String get settingsSecurityIncorrectPassword => 'Yanlış Şifre';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Şifreler eşleşmiyor';

  @override
  String get requiredPrompt => 'Gerekli';

  @override
  String get settingsSecurityBiometricUnlock => 'Biyometrik Açma';

  @override
  String get unlockAppPrompt => 'Uygulamayı Aç';

  @override
  String get settingsAboutTitle => 'Hakkında';

  @override
  String get settingsVersion => 'Sürüm';

  @override
  String get settingsLicense => 'Lisans';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Kaynak kodu';

  @override
  String get settingsMadeWithLove => '❤️ ile yapılmıştır';

  @override
  String get settingsConsiderSupporting => 'desteklemeyi düşünün';

  @override
  String get tagMoodTitle => 'Ruh hali';

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
