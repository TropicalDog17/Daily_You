// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => 'Wpisz się!';

  @override
  String get dailyReminderDescription => 'Zrób dzisiejszy wpis…';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get pageHomeTitle => 'Strona domowa';

  @override
  String get flashbacksTitle => 'Wspomnienia';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Wyklucz złe dni';

  @override
  String get flaskbacksEmpty => 'Brak dodanych wspomnień…';

  @override
  String get flashbackGoodDay => 'Dobry dzień';

  @override
  String get flashbackRandomDay => 'Losowy dzień';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tygodnie temu',
      one: '$count Tydzień temu',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Miesiące Temu',
      one: '$count Miesiąc Temu',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Lata Temu',
      one: '$count Rok Temu',
    );
    return '$_temp0';
  }

  @override
  String get pageGalleryTitle => 'Galeria';

  @override
  String get searchLogsHint => 'Szukaj wpisu…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ilość wpisów',
      one: '$count log',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count słowa',
      one: '$count word',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Brak wpisu…';

  @override
  String get sortDateTitle => 'Data';

  @override
  String get sortOrderAscendingTitle => 'Rosnąco';

  @override
  String get sortOrderDescendingTitle => 'Malejąco';

  @override
  String get pageStatisticsTitle => 'Statystyki';

  @override
  String get statisticsNotEnoughData => 'Zbyt mało danych…';

  @override
  String get statisticsRangeOneMonth => '1 miesiąc';

  @override
  String get statisticsRangeSixMonths => '6 miesięcy';

  @override
  String get statisticsRangeOneYear => '1 rok';

  @override
  String get statisticsRangeAllTime => 'Cały okres';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag - Podsumowanie';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag';
  }

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Aktualna passa $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Najdłuższa passa $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dni od złego dnia$count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Nie można uzyskać dostępu do pamięci zewnętrznej';

  @override
  String get errorExternalStorageAccessDescription =>
      'Jeśli używasz pamięci sieciowej, upewnij się czy usługa jest online i czy masz połączenie z internetem.\n\nW innym wypadku aplikacja mogła stracić uprawnienia do zewnętrznego folderu. Idź do ustawień i ponownie wybierz zewnętrzny folder by uzyskać uprawnienia.\n\nUwaga, zmiany nie zostaną zsynchronizowane dopóki nie przywrócisz dostępu do lokalizacji pamięci zewnętrznej!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Kontynuuj z lokalną bazą danych';

  @override
  String get lastModified => 'Zmodyfikowane';

  @override
  String get writeSomethingHint => 'Napisz coś…';

  @override
  String get titleHint => 'Tytuł…';

  @override
  String get deleteLogTitle => 'Usuń wpis';

  @override
  String get deleteLogDescription => 'Czy chcesz usunąć ten wpis?';

  @override
  String get deletePhotoTitle => 'Usuń zdjęcie';

  @override
  String get deletePhotoDescription => 'Czy chcesz usunąć to zdjęcie?';

  @override
  String get pageSettingsTitle => 'Ustawienia';

  @override
  String get settingsAppearanceTitle => 'Wygląd';

  @override
  String get settingsTheme => 'Motyw';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Pierwszy dzień tygodnia';

  @override
  String get settingsUseSystemAccentColor => 'Użyj systemowego koloru akcentu';

  @override
  String get settingsCustomAccentColor => 'Własny kolor akcentu';

  @override
  String get settingsShowMarkdownToolbar => 'Pokaż pasek narzędzi';

  @override
  String get settingsShowFlashbacks => 'Pokaż wspomnienia';

  @override
  String get settingsChangeMoodIcons => 'Zmień ikony nastroju';

  @override
  String get moodIconPrompt => 'Wprowadź ikonę';

  @override
  String get settingsFlashbacksViewLayout => 'Układ widoku wspomnień';

  @override
  String get settingsGalleryViewLayout => 'Widok galerii';

  @override
  String get settingsHideImagesInGallery => 'Ukryj zdjęcia w galerii';

  @override
  String get viewLayoutList => 'Lista';

  @override
  String get viewLayoutGrid => 'Siatka';

  @override
  String get settingsNotificationsTitle => 'Powiadomienia';

  @override
  String get settingsDailyReminderOnboarding =>
      'Włącz codzienne przypomnienia by utrzymać swoją konsekwentność!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Uprawnienie \'alarmy i przypomnienia\' jest wymagane, by wysyłać powiadomienia o ustalonym lub losowym czasie.';

  @override
  String get settingsDailyReminderTitle => 'Codzienne przypomnienie';

  @override
  String get settingsDailyReminderDescription =>
      'Subtelne przypomnienie każdego dnia';

  @override
  String get settingsReminderTime => 'Czas przypomnienia';

  @override
  String get settingsFixedReminderTimeTitle => 'Stały czas przypomnienia';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Ustaw niezmienny czas przypomnienia';

  @override
  String get settingsAlwaysSendReminderTitle => 'Zawsze wysyłaj powiadomienie';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Wyślij powiadomienie nawet jeśli wpis został rozpoczęty';

  @override
  String get settingsCustomizeNotificationTitle => 'Modyfikuj powiadomienia';

  @override
  String get settingsTemplatesTitle => 'Szablony';

  @override
  String get settingsDefaultTemplate => 'Domyślny szablon';

  @override
  String get manageTemplates => 'Zarządzaj szblonami';

  @override
  String get addTemplate => 'Dodaj szablon';

  @override
  String get newTemplate => 'Nowy szablon';

  @override
  String get noTemplateTitle => 'Brak';

  @override
  String get noTemplatesDescription => 'Brak utworzonych szablonów…';

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
  String get settingsStorageTitle => 'Pamięć';

  @override
  String get settingsImageQuality => 'Jakość obrazów';

  @override
  String get imageQualityHigh => 'Wysoka';

  @override
  String get imageQualityMedium => 'Średnia';

  @override
  String get imageQualityLow => 'Niska';

  @override
  String get imageQualityNoCompression => 'Brak kompresji';

  @override
  String get settingsLogFolder => 'Folder wpisów';

  @override
  String get settingsImageFolder => 'Folder obrazów';

  @override
  String get warningTitle => 'Ostrzeżenie';

  @override
  String get logFolderWarningDescription =>
      'Jeśli wybrany folder zawiera już plik \'daily_you.db\', zostanie on użyty do nadpisania twoich wpisów!';

  @override
  String get errorTitle => 'Błąd';

  @override
  String get logFolderErrorDescription =>
      'Nie udało się zmienić folderu wpisów!';

  @override
  String get imageFolderErrorDescription =>
      'Nie udało się zmienić folderu obrazów!';

  @override
  String get backupErrorDescription =>
      'Nie udało się utworzyć kopii zapasowej!';

  @override
  String get restoreErrorDescription =>
      'Nie udało się przywrócić kopii zapasowej!';

  @override
  String get settingsBackupRestoreTitle => 'Kopia i przywracanie';

  @override
  String get settingsBackup => 'Kopia zapasowa';

  @override
  String get settingsRestore => 'Przywróć';

  @override
  String get settingsRestorePromptDescription =>
      'Przywracanie kopii nadpisze wszystkie istniejące dane!';

  @override
  String tranferStatus(Object percent) {
    return 'Przenoszenie...$percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Tworzenie kopii zapasowej... $percent\$';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Przywracanie kopii zapasowej... $percent%';
  }

  @override
  String get cleanUpStatus => 'Czyszczenie…';

  @override
  String get settingsExport => 'Eksport';

  @override
  String get settingsExportToAnotherFormat => 'Eksportuj do innego formatu';

  @override
  String get settingsExportFormatDescription =>
      'To nie powinno być używane jako kopia!';

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get exportImages => 'Export Images';

  @override
  String get settingsImport => 'Import';

  @override
  String get settingsImportFromAnotherApp => 'Importuj z innej aplikacji';

  @override
  String get settingsTranslateCallToAction =>
      'Każdy powinien mieć dostęp do dziennika!';

  @override
  String get settingsHelpTranslate => 'Pomóż w tłumaczeniu';

  @override
  String get importLogs => 'Import Logs';

  @override
  String get importImages => 'Import Images';

  @override
  String get logFormatTitle => 'Wybierz format';

  @override
  String get logFormatDescription =>
      'Formaty innych aplikacji mogą nie wspierać wszystkich funkcji. Proszę o zgłaszanie jakichkolwiek błędów, ponieważ formaty tych aplikacji mogą się zmienić w każdym momencie. To nie wpłynie na istniejące wpisy!';

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
  String get formatOneShot => 'OneShot';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Usuń wszystkie wpisy';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Czy chcesz usunąć wszystkie twoje wpisy?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Wprowadź \'$prompt\' by potwierdzić. Ta operacja jest nieodwracalna!';
  }

  @override
  String get settingsLanguageTitle => 'Język';

  @override
  String get settingsAppLanguageTitle => 'Język aplikacji';

  @override
  String get settingsOverrideAppLanguageTitle => 'Wymuś język aplikacji';

  @override
  String get settingsSecurityTitle => 'Bezpieczeństwo';

  @override
  String get settingsSecurityRequirePassword => 'Wymagaj Hasła';

  @override
  String get settingsSecurityEnterPassword => 'Wprowadź hasło';

  @override
  String get settingsSecuritySetPassword => 'Ustaw Hasło';

  @override
  String get settingsSecurityChangePassword => 'Zmień Hasło';

  @override
  String get settingsSecurityPassword => 'Hasło';

  @override
  String get settingsSecurityConfirmPassword => 'Potwierdź Hasło';

  @override
  String get settingsSecurityOldPassword => 'Stare Hasło';

  @override
  String get settingsSecurityIncorrectPassword => 'Hasło Nieprawidłowe';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Hasła się nie zgadzają';

  @override
  String get requiredPrompt => 'Wymagane';

  @override
  String get settingsSecurityBiometricUnlock => 'Odblokowanie Biometryczne';

  @override
  String get unlockAppPrompt => 'Odblokuj aplikację';

  @override
  String get settingsAboutTitle => 'O aplikacji';

  @override
  String get settingsVersion => 'Wersja';

  @override
  String get settingsLicense => 'Licencja';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Kod źródłowy';

  @override
  String get settingsMadeWithLove => 'Zrobione z ❤️';

  @override
  String get settingsConsiderSupporting => 'rozważ wsparcie';

  @override
  String get tagMoodTitle => 'Nastrój';

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
