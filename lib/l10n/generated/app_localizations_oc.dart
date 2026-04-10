// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Occitan (`oc`).
class AppLocalizationsOc extends AppLocalizations {
  AppLocalizationsOc([String locale = 'oc']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => 'Enregistratz vòstra jornada !';

  @override
  String get dailyReminderDescription => 'Remplissez votre journal de bord…';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get pageHomeTitle => 'Acuèlh';

  @override
  String get flashbacksTitle => 'Retorn enrèire';

  @override
  String get settingsFlashbacksExcludeBadDays => '';

  @override
  String get flaskbacksEmpty => 'No Flashbacks Yet…';

  @override
  String get flashbackGoodDay => 'Una bona jornada';

  @override
  String get flashbackRandomDay => 'Un jorn ordinari';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fa $count setmanas',
      one: 'fa $count setmana',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fa $count meses',
      one: 'fa $count mes',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'fa $count ans',
      one: 'fa $count an',
    );
    return '$_temp0';
  }

  @override
  String get pageGalleryTitle => 'Galariá';

  @override
  String get searchLogsHint => 'Search Logs…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entradas',
      one: '$count entrada',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mots',
      one: '$count mot',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Cap d’entrada…';

  @override
  String get sortDateTitle => 'Data';

  @override
  String get sortOrderAscendingTitle => 'Ascendent';

  @override
  String get sortOrderDescendingTitle => 'Descendent';

  @override
  String get pageStatisticsTitle => 'Estatisticas';

  @override
  String get statisticsNotEnoughData => 'Pas pro de donadas…';

  @override
  String get statisticsRangeOneMonth => '1 mes';

  @override
  String get statisticsRangeSixMonths => '6 meses';

  @override
  String get statisticsRangeOneYear => '1 an';

  @override
  String get statisticsRangeAllTime => 'Tot temps';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Resumit';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag per jorn';
  }

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Current Streak $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Longest Streak $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Days Since a Bad Day $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Can\'t Access External Storage';

  @override
  String get errorExternalStorageAccessDescription =>
      'If you are using network storage make sure the service is online and you have network access.\n\nOtherwise, the app may have lost permissions for the external folder. Go to settings, and reselect the external folder to grant access.\n\nWarning, changes will not be synced until you restore access to the external storage location!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Continue With Local Database';

  @override
  String get lastModified => 'Modificacion';

  @override
  String get writeSomethingHint => 'Escrivètz quicòm…';

  @override
  String get titleHint => 'Títol…';

  @override
  String get deleteLogTitle => 'Suprimir l’entrada ?';

  @override
  String get deleteLogDescription => 'Do you want to delete this log?';

  @override
  String get deletePhotoTitle => 'Escafar la fòto';

  @override
  String get deletePhotoDescription => 'Volètz escafar aquesta fòto ?';

  @override
  String get pageSettingsTitle => 'Paramètres';

  @override
  String get settingsAppearanceTitle => 'Aparéncia';

  @override
  String get settingsTheme => 'Tèma';

  @override
  String get themeSystem => 'Sistèma';

  @override
  String get themeLight => 'Clar';

  @override
  String get themeDark => 'Escur';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Primièr jorn de la setmana';

  @override
  String get settingsUseSystemAccentColor => 'Personalizar la color afortida';

  @override
  String get settingsCustomAccentColor => 'Custom Accent Color';

  @override
  String get settingsShowMarkdownToolbar =>
      'Aficha la barra d\'aisinas Markdown';

  @override
  String get settingsShowFlashbacks => 'Show Flashbacks';

  @override
  String get settingsChangeMoodIcons => 'Change Mood Icons';

  @override
  String get moodIconPrompt => 'Enter an icon';

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
  String get settingsNotificationsTitle => 'Notificacions';

  @override
  String get settingsDailyReminderOnboarding =>
      'Enable daily reminders to keep yourself consistent!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'The \'schedule alarms\' permission will be requested to send the reminder at a random moment or at your preferred time.';

  @override
  String get settingsDailyReminderTitle => 'Daily Reminder';

  @override
  String get settingsDailyReminderDescription => 'A gentle reminder each day';

  @override
  String get settingsReminderTime => 'Ora del rapèl';

  @override
  String get settingsFixedReminderTimeTitle => 'Fixed Reminder Time';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Pick a fixed time for the reminder';

  @override
  String get settingsAlwaysSendReminderTitle => 'Always Send Reminder';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Send reminder even if a log was already started';

  @override
  String get settingsCustomizeNotificationTitle => 'Customize Notifications';

  @override
  String get settingsTemplatesTitle => 'Modèls';

  @override
  String get settingsDefaultTemplate => 'Default Template';

  @override
  String get manageTemplates => 'Gerir los modèls';

  @override
  String get addTemplate => 'Apondre un modèl';

  @override
  String get newTemplate => 'Modèl novèl';

  @override
  String get noTemplateTitle => 'Cap';

  @override
  String get noTemplatesDescription => 'No templates created yet…';

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
  String get settingsStorageTitle => 'Emmagazinatge';

  @override
  String get settingsImageQuality => 'Qualitat d\'imatge';

  @override
  String get imageQualityHigh => 'Elevada';

  @override
  String get imageQualityMedium => 'Mejana';

  @override
  String get imageQualityLow => 'Febla';

  @override
  String get imageQualityNoCompression => 'Cap de compression';

  @override
  String get settingsLogFolder => 'Dossièr dels jornals';

  @override
  String get settingsImageFolder => 'Dossièrs dels imatges';

  @override
  String get warningTitle => 'Avertiment';

  @override
  String get logFolderWarningDescription =>
      'If the selected folder already contains a \'daily_you.db\' file, it will be used to overwrite your existing logs!';

  @override
  String get errorTitle => 'Error';

  @override
  String get logFolderErrorDescription => 'Failed to change log folder!';

  @override
  String get imageFolderErrorDescription => 'Failed to change image folder!';

  @override
  String get backupErrorDescription =>
      'Fracàs de la creacion de la salvagarda !';

  @override
  String get restoreErrorDescription => 'Failed to restore backup!';

  @override
  String get settingsBackupRestoreTitle => 'Backup & Restore';

  @override
  String get settingsBackup => 'Salvagardar';

  @override
  String get settingsRestore => 'Restaurar';

  @override
  String get settingsRestorePromptDescription =>
      'Restoring a backup will overwrite your existing data!';

  @override
  String tranferStatus(Object percent) {
    return 'Transferiment… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Creacion de la salvagarda… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Restauracion de la salvagarda… $percent%';
  }

  @override
  String get cleanUpStatus => 'Netejatge…';

  @override
  String get settingsExport => 'Exportar';

  @override
  String get settingsExportToAnotherFormat => 'Export To Another Format';

  @override
  String get settingsExportFormatDescription =>
      'This should not be used as a backup!';

  @override
  String get exportLogs => 'Exportar las entradas';

  @override
  String get exportImages => 'Export Images';

  @override
  String get settingsImport => 'Importar';

  @override
  String get settingsImportFromAnotherApp => 'Import From Another App';

  @override
  String get settingsTranslateCallToAction =>
      'Everyone should have access to a journal!';

  @override
  String get settingsHelpTranslate => 'Help Translate';

  @override
  String get importLogs => 'Importar las entradas';

  @override
  String get importImages => 'Importar los imatges';

  @override
  String get logFormatTitle => 'Choose Format';

  @override
  String get logFormatDescription =>
      'Another app\'s format may not support all features. Please report any issues since third party formats may change at any time. This will not impact existing logs!';

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
  String get settingsDeleteAllLogsTitle => 'Delete All Logs';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Do you want to delete all of your logs?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Enter \'$prompt\' to confirm. This cannot be undone!';
  }

  @override
  String get settingsLanguageTitle => 'Language';

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
  String get settingsAboutTitle => 'A prepaus';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsLicense => 'Licéncia';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Còdi font';

  @override
  String get settingsMadeWithLove => 'Made with ❤️';

  @override
  String get settingsConsiderSupporting => 'consider supporting';

  @override
  String get tagMoodTitle => 'Umor';

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
