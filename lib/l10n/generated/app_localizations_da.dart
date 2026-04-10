// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => 'Log i dag!';

  @override
  String get dailyReminderDescription => 'Skriv din daglige log…';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get pageHomeTitle => 'Hjem';

  @override
  String get flashbacksTitle => 'Minder';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Ekskluder dårlige dage';

  @override
  String get flaskbacksEmpty => 'Ingen minder endnu…';

  @override
  String get flashbackGoodDay => 'En god dag';

  @override
  String get flashbackRandomDay => 'En tilfældig dag';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count uger siden',
      one: '$count uge siden',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count måneder siden',
      one: '$count måned siden',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count år siden',
      one: '$count år siden',
    );
    return '$_temp0';
  }

  @override
  String get pageGalleryTitle => 'Galleri';

  @override
  String get searchLogsHint => 'Søg i logs…';

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
      other: '$count ord',
      one: '$count ord',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Ingen logs…';

  @override
  String get sortDateTitle => 'Dato';

  @override
  String get sortOrderAscendingTitle => 'Stigende';

  @override
  String get sortOrderDescendingTitle => 'Faldende';

  @override
  String get pageStatisticsTitle => 'Statistikker';

  @override
  String get statisticsNotEnoughData => 'Ikke nok data…';

  @override
  String get statisticsRangeOneMonth => '1 måned';

  @override
  String get statisticsRangeSixMonths => '6 måneder';

  @override
  String get statisticsRangeOneYear => '1 år';

  @override
  String get statisticsRangeAllTime => 'Altid';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag oversigt';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag efter dag';
  }

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nuværende stribe $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Længste stribe $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Dage siden en dårlig dag $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle => 'Kan ikke tilgå eksternt lager';

  @override
  String get errorExternalStorageAccessDescription =>
      'Hvis du bruger netværkslagring, skal du sikre, at tjenesten er online, og at du har netværksadgang.\n\nEllers kan appen have mistet tilladelser til den eksterne mappe. Gå til indstillinger og vælg den igen for at gendanne adgang.\n\nAdvarsel: Ændringer synkroniseres ikke, før adgangen til lagringsplaceringen er gendannet!';

  @override
  String get errorExternalStorageAccessContinue => 'Fortsæt med lokal database';

  @override
  String get lastModified => 'Ændret';

  @override
  String get writeSomethingHint => 'Skriv noget…';

  @override
  String get titleHint => 'Titel…';

  @override
  String get deleteLogTitle => 'Slet log';

  @override
  String get deleteLogDescription => 'Vil du slette denne log?';

  @override
  String get deletePhotoTitle => 'Slet foto';

  @override
  String get deletePhotoDescription => 'Vil du slette dette foto?';

  @override
  String get pageSettingsTitle => 'Indstillinger';

  @override
  String get settingsAppearanceTitle => 'Udseende';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Lys';

  @override
  String get themeDark => 'Mørk';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Ugens første dag';

  @override
  String get settingsUseSystemAccentColor => 'Brug systemets accentfarve';

  @override
  String get settingsCustomAccentColor => 'Brugerdefineret accentfarve';

  @override
  String get settingsShowMarkdownToolbar => 'Vis markdown-værktøjslinje';

  @override
  String get settingsShowFlashbacks => 'Vis minder';

  @override
  String get settingsChangeMoodIcons => 'Skift humør-ikoner';

  @override
  String get moodIconPrompt => 'Angiv et ikon';

  @override
  String get settingsFlashbacksViewLayout => 'Flashbacks View Layout';

  @override
  String get settingsGalleryViewLayout => 'Gallery View Layout';

  @override
  String get settingsHideImagesInGallery => 'Hide Images In Gallery';

  @override
  String get viewLayoutList => 'List';

  @override
  String get viewLayoutGrid => 'Grid';

  @override
  String get settingsNotificationsTitle => 'Meddelelser';

  @override
  String get settingsDailyReminderOnboarding =>
      'Aktivér daglige påmindelser for at forblive konsekvent!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'The \'schedule alarms\' permission will be requested to send the reminder at a random moment or at your preferred time.';

  @override
  String get settingsDailyReminderTitle => 'Daglig påmindelse';

  @override
  String get settingsDailyReminderDescription =>
      'Lad appen køre i baggrunden for bedste resultater';

  @override
  String get settingsReminderTime => 'Påmindelsestid';

  @override
  String get settingsFixedReminderTimeTitle => 'Fast påmindelsestid';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Vælg et fast tidspunkt for påmindelsen';

  @override
  String get settingsAlwaysSendReminderTitle => 'Send altid påmindelse';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Send påmindelse, selvom en log allerede er startet';

  @override
  String get settingsCustomizeNotificationTitle => 'Tilpas meddelelser';

  @override
  String get settingsTemplatesTitle => 'Skabeloner';

  @override
  String get settingsDefaultTemplate => 'Standardskabelon';

  @override
  String get manageTemplates => 'Administrer skabeloner';

  @override
  String get addTemplate => 'Tilføj en skabelon';

  @override
  String get newTemplate => 'Ny skabelon';

  @override
  String get noTemplateTitle => 'Ingen';

  @override
  String get noTemplatesDescription => 'Ingen skabeloner oprettet endnu…';

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
  String get settingsStorageTitle => 'Lager';

  @override
  String get settingsImageQuality => 'Billedkvalitet';

  @override
  String get imageQualityHigh => 'Høj';

  @override
  String get imageQualityMedium => 'Middel';

  @override
  String get imageQualityLow => 'Lav';

  @override
  String get imageQualityNoCompression => 'Ingen komprimering';

  @override
  String get settingsLogFolder => 'Logmappe';

  @override
  String get settingsImageFolder => 'Billedmappe';

  @override
  String get warningTitle => 'Advarsel';

  @override
  String get logFolderWarningDescription =>
      'Hvis den valgte mappe allerede indeholder en \'daily_you.db\'-fil, bruges den til at overskrive dine eksisterende logs!';

  @override
  String get errorTitle => 'Fejl';

  @override
  String get logFolderErrorDescription => 'Kunne ikke ændre logmappe!';

  @override
  String get imageFolderErrorDescription => 'Kunne ikke ændre billedmappe!';

  @override
  String get backupErrorDescription => 'Kunne ikke oprette sikkerhedskopi!';

  @override
  String get restoreErrorDescription => 'Kunne ikke gendanne sikkerhedskopi!';

  @override
  String get settingsBackupRestoreTitle => 'Sikkerhedskopiering og gendannelse';

  @override
  String get settingsBackup => 'Sikkerhedskopiér';

  @override
  String get settingsRestore => 'Gendan';

  @override
  String get settingsRestorePromptDescription =>
      'Gendannelse af en sikkerhedskopi overskriver dine eksisterende data!';

  @override
  String tranferStatus(Object percent) {
    return 'Overfører… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Opretter sikkerhedskopi… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Gendanner sikkerhedskopi… $percent%';
  }

  @override
  String get cleanUpStatus => 'Rydder op…';

  @override
  String get settingsExport => 'Eksportér';

  @override
  String get settingsExportToAnotherFormat => 'Export To Another Format';

  @override
  String get settingsExportFormatDescription =>
      'This should not be used as a backup!';

  @override
  String get exportLogs => 'Eksportér logs';

  @override
  String get exportImages => 'Eksportér billeder';

  @override
  String get settingsImport => 'Importér';

  @override
  String get settingsImportFromAnotherApp => 'Importér fra en anden app';

  @override
  String get settingsTranslateCallToAction =>
      'Alle burde have adgang til en dagbog!';

  @override
  String get settingsHelpTranslate => 'Hjælp med at oversætte';

  @override
  String get importLogs => 'Importér logs';

  @override
  String get importImages => 'Importér billeder';

  @override
  String get logFormatTitle => 'Vælg format';

  @override
  String get logFormatDescription =>
      'En anden apps format understøtter muligvis ikke alle funktioner. Dette påvirker ikke eksisterende logs!';

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
  String get settingsDeleteAllLogsTitle => 'Slet alle logs';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Vil du slette alle dine logs?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Indtast \'$prompt\' for at bekræfte. Dette kan ikke fortrydes!';
  }

  @override
  String get settingsLanguageTitle => 'Sprog';

  @override
  String get settingsAppLanguageTitle => 'App Language';

  @override
  String get settingsOverrideAppLanguageTitle => 'Override App Language';

  @override
  String get settingsSecurityTitle => 'Security';

  @override
  String get settingsSecurityRequirePassword => 'Require Password';

  @override
  String get settingsSecurityEnterPassword => 'Enter Password';

  @override
  String get settingsSecuritySetPassword => 'Set Password';

  @override
  String get settingsSecurityChangePassword => 'Change Password';

  @override
  String get settingsSecurityPassword => 'Password';

  @override
  String get settingsSecurityConfirmPassword => 'Confirm Password';

  @override
  String get settingsSecurityOldPassword => 'Old Password';

  @override
  String get settingsSecurityIncorrectPassword => 'Incorrect Password';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get requiredPrompt => 'Required';

  @override
  String get settingsSecurityBiometricUnlock => 'Biometric Unlock';

  @override
  String get unlockAppPrompt => 'Unlock the app';

  @override
  String get settingsAboutTitle => 'Om';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicense => 'Licens';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Kildekode';

  @override
  String get settingsMadeWithLove => 'Lavet med ❤️';

  @override
  String get settingsConsiderSupporting => 'overvej at støtte';

  @override
  String get tagMoodTitle => 'Humør';

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
