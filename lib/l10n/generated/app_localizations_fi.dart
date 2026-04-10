// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => 'Täytä päiväkirja tänään!';

  @override
  String get dailyReminderDescription => 'Pidä päivittäinen päiväkirjasi…';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get pageHomeTitle => 'Etusivu';

  @override
  String get flashbacksTitle => 'Muistikuvat';

  @override
  String get settingsFlashbacksExcludeBadDays =>
      'Jätä huonot päivät huomioimatta';

  @override
  String get flaskbacksEmpty => 'Ei ole vielä muistikuvia…';

  @override
  String get flashbackGoodDay => 'Hyvä päivä';

  @override
  String get flashbackRandomDay => 'Satunnainen päivä';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count viikkoa sitten',
      one: '$count viikko sitten',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kuukautta sitten',
      one: '$count kuukausi sitten',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vuotta sitten',
      one: '$count vuosi sitten',
    );
    return '$_temp0';
  }

  @override
  String get pageGalleryTitle => 'Galleria';

  @override
  String get searchLogsHint => 'Hae lokeista…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lokia',
      one: '$count loki',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sanaa',
      one: '$count sana',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Ei lokeja…';

  @override
  String get sortDateTitle => 'Päivämäärä';

  @override
  String get sortOrderAscendingTitle => 'Nouseva';

  @override
  String get sortOrderDescendingTitle => 'Laskeva';

  @override
  String get pageStatisticsTitle => 'Tilastot';

  @override
  String get statisticsNotEnoughData => 'Ei tarpeeksi dataa…';

  @override
  String get statisticsRangeOneMonth => 'Yksi kuukausi';

  @override
  String get statisticsRangeSixMonths => 'Kuusi kuukautta';

  @override
  String get statisticsRangeOneYear => 'Yksi vuosi';

  @override
  String get statisticsRangeAllTime => 'Koko aika';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag Yhteenveto';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Päiväkohtaisesti';
  }

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nykyinen putki $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pisin putki $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Päiviä huonosta päivästä lähtien $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Ulkoiseen tallennustilaan ei pääse käsiksi';

  @override
  String get errorExternalStorageAccessDescription =>
      'Jos käytät verkkotallennustilaa, varmista, että palvelu on verkossa ja sinulla on verkkoyhteys.\n\nMuuten sovellus on saattanut menettää ulkoisen kansion käyttöoikeudet. Siirry asetuksiin ja valitse ulkoinen kansio uudelleen myöntääksesi käyttöoikeudet.\n\nVaroitus: muutoksia ei synkronoida, ennen kuin palautat käyttöoikeuden ulkoiseen tallennussijaintiin!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Jatka paikallisen tietokannan kanssa';

  @override
  String get lastModified => 'Muokattu';

  @override
  String get writeSomethingHint => 'Kirjoita jotain…';

  @override
  String get titleHint => 'Otsikko…';

  @override
  String get deleteLogTitle => 'Poista loki';

  @override
  String get deleteLogDescription => 'Haluatko poistaa tämän lokin?';

  @override
  String get deletePhotoTitle => 'Poista valokuva';

  @override
  String get deletePhotoDescription => 'Haluatko poistaa tämän valokuvan?';

  @override
  String get pageSettingsTitle => 'Asetukset';

  @override
  String get settingsAppearanceTitle => 'Ulkoasu';

  @override
  String get settingsTheme => 'Teema';

  @override
  String get themeSystem => 'Järjestelmä';

  @override
  String get themeLight => 'Vaalea';

  @override
  String get themeDark => 'Tumma';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Viikon ensimmäinen päivä';

  @override
  String get settingsUseSystemAccentColor => 'Käytä järjestelmän korostusväriä';

  @override
  String get settingsCustomAccentColor => 'Mukautettu korostusväri';

  @override
  String get settingsShowMarkdownToolbar => 'Show Markdown Toolbar';

  @override
  String get settingsShowFlashbacks => 'Näytä takaumat';

  @override
  String get settingsChangeMoodIcons => 'Vaihda mielialakuvakkeita';

  @override
  String get moodIconPrompt => 'Syötä kuvake';

  @override
  String get settingsFlashbacksViewLayout => 'Takaumien näkymän asettelu';

  @override
  String get settingsGalleryViewLayout => 'Gallerianäkymän asettelu';

  @override
  String get settingsHideImagesInGallery => 'Piilota kuvat galleriassa';

  @override
  String get viewLayoutList => 'Lista';

  @override
  String get viewLayoutGrid => 'Ruudukko';

  @override
  String get settingsNotificationsTitle => 'Ilmoitukset';

  @override
  String get settingsDailyReminderOnboarding =>
      'Ota päivittäiset muistutukset käyttöön pysyäksesi johdonmukaisena!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      '\'Ajoita hälytykset\' -lupaa pyydetään muistutuksen lähettämiseksi satunnaiseen aikaan tai haluamanasi aikana.';

  @override
  String get settingsDailyReminderTitle => 'Päivittäinen muistutus';

  @override
  String get settingsDailyReminderDescription => 'Lempeä muistutus joka päivä';

  @override
  String get settingsReminderTime => 'Muistutusaika';

  @override
  String get settingsFixedReminderTimeTitle => 'Kiinteä muistutusaika';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Valitse muistutukselle kiinteä aika';

  @override
  String get settingsAlwaysSendReminderTitle => 'Lähetä aina muistutus';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Lähetä muistutus, vaikka loki olisi jo aloitettu';

  @override
  String get settingsCustomizeNotificationTitle => 'Mukauta ilmoituksia';

  @override
  String get settingsTemplatesTitle => 'Pohjamallit';

  @override
  String get settingsDefaultTemplate => 'Oletuspohjamalli';

  @override
  String get manageTemplates => 'Hallitse pohjamalleja';

  @override
  String get addTemplate => 'Lisää pohjamalli';

  @override
  String get newTemplate => 'New Template';

  @override
  String get noTemplateTitle => 'Ei mitään';

  @override
  String get noTemplatesDescription => 'Ei vielä luotuja pohjamalleja…';

  @override
  String get templateVariableTime => 'Aika';

  @override
  String get templateDefaultTimestampTitle => 'Aikaleima';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'Päivän yhteenveto';

  @override
  String get templateDefaultSummaryBody =>
      '### Yhteenveto\n- \n\n### Lainaus\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Pohdinta';

  @override
  String get templateDefaultReflectionBody =>
      '### Mistä nautit tänään?\n- \n\n### Mistä olet kiitollinen?\n- \n\n### Mitä odotat innolla?\n- ';

  @override
  String get settingsStorageTitle => 'Tallennustila';

  @override
  String get settingsImageQuality => 'Kuvanlaatu';

  @override
  String get imageQualityHigh => 'Korkea';

  @override
  String get imageQualityMedium => 'Keskitasoinen';

  @override
  String get imageQualityLow => 'Alhainen';

  @override
  String get imageQualityNoCompression => 'Ei pakkausta';

  @override
  String get settingsLogFolder => 'Lokikansio';

  @override
  String get settingsImageFolder => 'Kuvakansio';

  @override
  String get warningTitle => 'Varoitus';

  @override
  String get logFolderWarningDescription =>
      'Jos valitussa kansiossa on jo \'daily_you.db\'-tiedosto, sitä käytetään olemassa olevien lokien korvaamiseen!';

  @override
  String get errorTitle => 'Virhe';

  @override
  String get logFolderErrorDescription =>
      'Lokikansion vaihtaminen epäonnistui!';

  @override
  String get imageFolderErrorDescription =>
      'Kuvakansion vaihtaminen epäonnistui!';

  @override
  String get backupErrorDescription => 'Varmuuskopion luominen epäonnistui!';

  @override
  String get restoreErrorDescription =>
      'Varmuuskopion palauttaminen epäonnistui!';

  @override
  String get settingsBackupRestoreTitle => 'Varmuuskopiointi ja palautus';

  @override
  String get settingsBackup => 'Varmuuskopioi';

  @override
  String get settingsRestore => 'Palauta';

  @override
  String get settingsRestorePromptDescription =>
      'Varmuuskopion palauttaminen korvaa olemassa olevat tiedot!';

  @override
  String tranferStatus(Object percent) {
    return 'Siirretään… $percent %';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Varmuuskopiota luodaan… $percent %';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Varmuuskopiota palautetaan… $percent %';
  }

  @override
  String get cleanUpStatus => 'Siivotaan…';

  @override
  String get settingsExport => 'Export';

  @override
  String get settingsExportToAnotherFormat => 'Vie toiseen muotoon';

  @override
  String get settingsExportFormatDescription =>
      'Tätä ei tule käyttää varmuuskopiona!';

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get exportImages => 'Export Images';

  @override
  String get settingsImport => 'Import';

  @override
  String get settingsImportFromAnotherApp => 'Tuo toisesta sovelluksesta';

  @override
  String get settingsTranslateCallToAction =>
      'Jokaisella pitäisi olla pääsy päiväkirjaan!';

  @override
  String get settingsHelpTranslate => 'Auta kääntämään';

  @override
  String get importLogs => 'Import Logs';

  @override
  String get importImages => 'Import Images';

  @override
  String get logFormatTitle => 'Valitse muoto';

  @override
  String get logFormatDescription =>
      'Toisen sovelluksen muoto ei välttämättä tue kaikkia ominaisuuksia. Ilmoita kaikista vioista, koska kolmansien osapuolten muodot voivat muuttua milloin tahansa. Tämä ei vaikuta olemassa oleviin lokeihin!';

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
  String get settingsDeleteAllLogsTitle => 'Poista kaikki lokit';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Haluatko poistaa kaikki lokisi?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Vahvista syöttämällä \'$prompt\'. Tätä ei voi perua!';
  }

  @override
  String get settingsLanguageTitle => 'Kieli';

  @override
  String get settingsAppLanguageTitle => 'Sovelluksen kieli';

  @override
  String get settingsOverrideAppLanguageTitle => 'Ohita sovelluksen kieli';

  @override
  String get settingsSecurityTitle => 'Turvallisuus';

  @override
  String get settingsSecurityRequirePassword => 'Vaadi salasana';

  @override
  String get settingsSecurityEnterPassword => 'Syötä salasana';

  @override
  String get settingsSecuritySetPassword => 'Aseta salasana';

  @override
  String get settingsSecurityChangePassword => 'Vaihda salasana';

  @override
  String get settingsSecurityPassword => 'Salasana';

  @override
  String get settingsSecurityConfirmPassword => 'Vahvista salasana';

  @override
  String get settingsSecurityOldPassword => 'Vanha salasana';

  @override
  String get settingsSecurityIncorrectPassword => 'Väärä salasana';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Salasanat eivät täsmää';

  @override
  String get requiredPrompt => 'Pakollinen';

  @override
  String get settingsSecurityBiometricUnlock =>
      'Biometrinen lukituksen avaaminen';

  @override
  String get unlockAppPrompt => 'Avaa sovelluksen lukitus';

  @override
  String get settingsAboutTitle => 'Tietoja';

  @override
  String get settingsVersion => 'Versio';

  @override
  String get settingsLicense => 'Lisenssi';

  @override
  String get licenseGPLv3 => 'GPL-v. 3.0';

  @override
  String get settingsSourceCode => 'Lähdekoodi';

  @override
  String get settingsMadeWithLove => '❤️:lla tehty';

  @override
  String get settingsConsiderSupporting => 'harkitse tukemista';

  @override
  String get tagMoodTitle => 'Mieliala';

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
