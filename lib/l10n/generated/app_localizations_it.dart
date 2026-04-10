// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => 'Scrivi sul Tuo Diario!';

  @override
  String get dailyReminderDescription =>
      'Non dimenticare di tener traccia della tua giornata…';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get pageHomeTitle => 'Home';

  @override
  String get flashbacksTitle => 'Ricordi';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Escludi le giornate negative';

  @override
  String get flaskbacksEmpty => 'Ancora nessun ricordo…';

  @override
  String get flashbackGoodDay => 'Una bella giornata';

  @override
  String get flashbackRandomDay => 'Una giornata a caso';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Settimane Fa',
      one: '$count Settimana Fa',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mesi Fa',
      one: '$count Mese Fa',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Anni Fa',
      one: '$count Anno Fa',
    );
    return '$_temp0';
  }

  @override
  String get pageGalleryTitle => 'Galleria';

  @override
  String get searchLogsHint => 'Cerca annotazioni…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count annotazioni',
      one: '$count annotazione',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parole',
      one: '$count parola',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Nessuna annotazione…';

  @override
  String get sortDateTitle => 'Data';

  @override
  String get sortOrderAscendingTitle => 'Ascendente';

  @override
  String get sortOrderDescendingTitle => 'Discendente';

  @override
  String get pageStatisticsTitle => 'Statistiche';

  @override
  String get statisticsNotEnoughData => 'Dati insufficienti…';

  @override
  String get statisticsRangeOneMonth => '1 Mese';

  @override
  String get statisticsRangeSixMonths => '6 Mesi';

  @override
  String get statisticsRangeOneYear => '1 Anno';

  @override
  String get statisticsRangeAllTime => 'Tutto';

  @override
  String chartSummaryTitle(Object tag) {
    return 'Riepilogo $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag per giorno';
  }

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sequenza corrente $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Sequenza più Lunga $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Giorni trascorsi dall\'ultima giornata negativa $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Impossibile accedere alla memoria esterna';

  @override
  String get errorExternalStorageAccessDescription =>
      'Se utilizzi un archivio di rete, assicurati che il servizio sia online e che tu disponga di accesso alla rete.\n\nIn caso contrario, l\'app potrebbe aver perso le autorizzazioni per la cartella esterna. Vai alle impostazioni e riseleziona la cartella esterna per concedere l\'accesso.\n\nAttenzione, le modifiche non verranno sincronizzate finché non ripristinerai l\'accesso alla posizione di archiviazione esterna!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Prosegui con la base di dati locale';

  @override
  String get lastModified => 'Modificato';

  @override
  String get writeSomethingHint => 'Scrivi qualcosa…';

  @override
  String get titleHint => 'Titolo…';

  @override
  String get deleteLogTitle => 'Elimina l\'annotazione';

  @override
  String get deleteLogDescription =>
      'Vuoi davvero eliminare questa annotazione?';

  @override
  String get deletePhotoTitle => 'Elimina la foto';

  @override
  String get deletePhotoDescription => 'Vuoi eliminare questa foto?';

  @override
  String get pageSettingsTitle => 'Impostazioni';

  @override
  String get settingsAppearanceTitle => 'Aspetto';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Primo Giorno della Settimana';

  @override
  String get settingsUseSystemAccentColor => 'Usa il colore di sistema';

  @override
  String get settingsCustomAccentColor => 'Colore personalizzato';

  @override
  String get settingsShowMarkdownToolbar =>
      'Mostra la barra degli strumenti Markdown';

  @override
  String get settingsShowFlashbacks => 'Mostra i ricordi';

  @override
  String get settingsChangeMoodIcons => 'Cambia le icone dell\'umore';

  @override
  String get moodIconPrompt => 'Inserisci un\'icona';

  @override
  String get settingsFlashbacksViewLayout =>
      'Layout di visualizzazione Ricordi';

  @override
  String get settingsGalleryViewLayout => 'Layout visualizzazione Galleria';

  @override
  String get settingsHideImagesInGallery =>
      'Nascondi le immagini nella galleria';

  @override
  String get viewLayoutList => 'Elenco';

  @override
  String get viewLayoutGrid => 'Griglia';

  @override
  String get settingsNotificationsTitle => 'Notifiche';

  @override
  String get settingsDailyReminderOnboarding =>
      'Attiva i promemoria giornalieri per rimanere costante!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Sarà richiesta l\'autorizzazione \'programma sveglie\' per poter inviare promemoria casuali o al momento da te preferito.';

  @override
  String get settingsDailyReminderTitle => 'Promemoria Giornaliero';

  @override
  String get settingsDailyReminderDescription =>
      'Un gentile promemoria ogni giorno';

  @override
  String get settingsReminderTime => 'Orario Promemoria';

  @override
  String get settingsFixedReminderTimeTitle => 'Orario Promemoria Fissato';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Scegli un orario fisso per il promemoria';

  @override
  String get settingsAlwaysSendReminderTitle => 'Invia sempre promemoria';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Invia promemoria anche se è già stata creata un\'annotazione';

  @override
  String get settingsCustomizeNotificationTitle => 'Personalizza Notifiche';

  @override
  String get settingsTemplatesTitle => 'Modelli';

  @override
  String get settingsDefaultTemplate => 'Modello Predefinito';

  @override
  String get manageTemplates => 'Gestisci Modelli';

  @override
  String get addTemplate => 'Aggiungi un Modello';

  @override
  String get newTemplate => 'Nuovo Modello';

  @override
  String get noTemplateTitle => 'Nessuno';

  @override
  String get noTemplatesDescription => 'Nessun modello ancora creato…';

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
  String get settingsStorageTitle => 'Memoria';

  @override
  String get settingsImageQuality => 'Qualità Immagine';

  @override
  String get imageQualityHigh => 'Alta';

  @override
  String get imageQualityMedium => 'Media';

  @override
  String get imageQualityLow => 'Bassa';

  @override
  String get imageQualityNoCompression => 'Nessuna Compressione';

  @override
  String get settingsLogFolder => 'Cartella delle Annotazioni';

  @override
  String get settingsImageFolder => 'Cartella Immagini';

  @override
  String get warningTitle => 'Attenzione';

  @override
  String get logFolderWarningDescription =>
      'Se la cartella selezionata contiene già un file \'daily_you.db\', questo verrà utilizzato per sovrascrivere le annotazioni esistenti!';

  @override
  String get errorTitle => 'Errore';

  @override
  String get logFolderErrorDescription =>
      'Impossibile cambiare cartella delle annotazioni!';

  @override
  String get imageFolderErrorDescription =>
      'Impossibile modificare la cartella delle immagini!';

  @override
  String get backupErrorDescription => 'Impossibile creare il backup!';

  @override
  String get restoreErrorDescription => 'Impossibile ripristinare il backup!';

  @override
  String get settingsBackupRestoreTitle => 'Backup & Ripristino';

  @override
  String get settingsBackup => 'Backup';

  @override
  String get settingsRestore => 'Ripristino';

  @override
  String get settingsRestorePromptDescription =>
      'Ripristinare un backup sovrascriverà i dati esistenti!';

  @override
  String tranferStatus(Object percent) {
    return 'Trasferimento… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Creazione Backup… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Ripristino Backup… $percent%';
  }

  @override
  String get cleanUpStatus => 'Pulizia…';

  @override
  String get settingsExport => 'Export';

  @override
  String get settingsExportToAnotherFormat => 'Esporta in un Altro Formato';

  @override
  String get settingsExportFormatDescription =>
      'Questo non dovrebbe essere usato come backup!';

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get exportImages => 'Export Images';

  @override
  String get settingsImport => 'Import';

  @override
  String get settingsImportFromAnotherApp => 'Importa da un\'altra App';

  @override
  String get settingsTranslateCallToAction =>
      'Chiunque dovrebbe poter tenere un diario!';

  @override
  String get settingsHelpTranslate => 'Aiuta a tradurre';

  @override
  String get importLogs => 'Import Logs';

  @override
  String get importImages => 'Import Images';

  @override
  String get logFormatTitle => 'Scegli il Formato';

  @override
  String get logFormatDescription =>
      'Il formato di un\'altra App potrebbe non supportare tutte le funzionalità. Riporta qualsiasi problema riscontri poiché i formati di terze parti possono cambiare in qualsiasi momento. Ciò non avrà impatto sulle note esistenti!';

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
  String get settingsDeleteAllLogsTitle => 'Cancella Tutte le Annotazioni';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Vuoi davvero cancellare tutte le tue annotazioni?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Inserisci \'$prompt\' per confermare. Questa operazione non può essere annullata!';
  }

  @override
  String get settingsLanguageTitle => 'Lingua';

  @override
  String get settingsAppLanguageTitle => 'Lingua dell\'App';

  @override
  String get settingsOverrideAppLanguageTitle => 'Ridefinisci Lingua dell\'App';

  @override
  String get settingsSecurityTitle => 'Sicurezza';

  @override
  String get settingsSecurityRequirePassword => 'Richiedi Password';

  @override
  String get settingsSecurityEnterPassword => 'Inserisci Password';

  @override
  String get settingsSecuritySetPassword => 'Imposta Password';

  @override
  String get settingsSecurityChangePassword => 'Cambia Password';

  @override
  String get settingsSecurityPassword => 'Password';

  @override
  String get settingsSecurityConfirmPassword => 'Conferma Password';

  @override
  String get settingsSecurityOldPassword => 'Vecchia Password';

  @override
  String get settingsSecurityIncorrectPassword => 'Password Errata';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Le password non coincidono';

  @override
  String get requiredPrompt => 'Obbligatorio';

  @override
  String get settingsSecurityBiometricUnlock => 'Sblocco Biometrico';

  @override
  String get unlockAppPrompt => 'Sblocca l\'App';

  @override
  String get settingsAboutTitle => 'Informazioni';

  @override
  String get settingsVersion => 'Versione';

  @override
  String get settingsLicense => 'Licenza';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Codice Sorgente';

  @override
  String get settingsMadeWithLove => 'Fatto con ❤️';

  @override
  String get settingsConsiderSupporting =>
      'Considera la possibilità di sostenere il progetto';

  @override
  String get tagMoodTitle => 'Stato d\'animo';

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
