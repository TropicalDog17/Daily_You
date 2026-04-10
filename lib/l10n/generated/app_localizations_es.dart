// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => '¡Anota hoy!';

  @override
  String get dailyReminderDescription => 'Anota tu entrada diaria…';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get pageHomeTitle => 'Inicio';

  @override
  String get flashbacksTitle => 'Recuerdos';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Excluir dias malos';

  @override
  String get flaskbacksEmpty => 'Aún no hay recuerdos…';

  @override
  String get flashbackGoodDay => 'Un Buen Día';

  @override
  String get flashbackRandomDay => 'Un Día Aleatorio';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count semanas',
      one: 'Hace $count semana',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count meses',
      one: 'Hace $count mes',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hace $count años',
      one: 'Hace $count año',
    );
    return '$_temp0';
  }

  @override
  String get pageGalleryTitle => 'Galería';

  @override
  String get searchLogsHint => 'Buscar registros…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count registros',
      one: '$count registro',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count palabras',
      one: '$count palabra',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'No hay registros…';

  @override
  String get sortDateTitle => 'Fecha';

  @override
  String get sortOrderAscendingTitle => 'Ascendente';

  @override
  String get sortOrderDescendingTitle => 'Descendente';

  @override
  String get pageStatisticsTitle => 'Estadísticas';

  @override
  String get statisticsNotEnoughData => 'No hay suficientes datos…';

  @override
  String get statisticsRangeOneMonth => '1 Mes';

  @override
  String get statisticsRangeSixMonths => '6 Meses';

  @override
  String get statisticsRangeOneYear => '1 Año';

  @override
  String get statisticsRangeAllTime => 'Todo el tiempo';

  @override
  String chartSummaryTitle(Object tag) {
    return 'Resumen de $tag';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag Por Día';
  }

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Racha actual $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Racha más larga $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Días desde un día malo $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'No Se Puede Acceder al Almacenamiento Externo';

  @override
  String get errorExternalStorageAccessDescription =>
      'Si estás usando almacenamiento en red, asegúrate de que el servicio esté en línea y de que tengas acceso a la red.\n\nDe lo contrario, la aplicación puede haber perdido los permisos para la carpeta externa. Ve a la configuración y vuelve a seleccionar la carpeta externa para otorgar acceso.\n\nAdvertencia: Los cambios no se sincronizarán hasta que restaures el acceso a la ubicación de almacenamiento externo.';

  @override
  String get errorExternalStorageAccessContinue =>
      'Continuar con la base de datos local';

  @override
  String get lastModified => 'Modificado';

  @override
  String get writeSomethingHint => 'Escribe algo…';

  @override
  String get titleHint => 'Título…';

  @override
  String get deleteLogTitle => 'Eliminar entrada';

  @override
  String get deleteLogDescription => '¿Quieres eliminar esta entrada?';

  @override
  String get deletePhotoTitle => 'Eliminar foto';

  @override
  String get deletePhotoDescription => '¿Quieres eliminar esta foto?';

  @override
  String get pageSettingsTitle => 'Ajustes';

  @override
  String get settingsAppearanceTitle => 'Apariencia';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeAmoled => 'AMOLED';

  @override
  String get settingsFirstDayOfWeek => 'Primer Día de la Semana';

  @override
  String get settingsUseSystemAccentColor => 'Usar Color de Acento del Sistema';

  @override
  String get settingsCustomAccentColor => 'Color de Acento Personalizado';

  @override
  String get settingsShowMarkdownToolbar =>
      'Mostrar Barra de Herramientas Markdown';

  @override
  String get settingsShowFlashbacks => 'Mostrar Recuerdos';

  @override
  String get settingsChangeMoodIcons => 'Cambiar Iconos de Estado de Ánimo';

  @override
  String get moodIconPrompt => 'Introduce un icono';

  @override
  String get settingsFlashbacksViewLayout => 'Vista de Recuerdos';

  @override
  String get settingsGalleryViewLayout => 'Vista de Galería';

  @override
  String get settingsHideImagesInGallery => 'Ocultar Imágenes en Galería';

  @override
  String get viewLayoutList => 'Lista';

  @override
  String get viewLayoutGrid => 'Cuadrícula';

  @override
  String get settingsNotificationsTitle => 'Notificaciones';

  @override
  String get settingsDailyReminderOnboarding =>
      '¡Activa recordatorios diarios para mantenerte activo!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Los permisos de \"alarmas de planificacion\" seran solicitados para enviarte un recordatorio en un momento aleatorio de tu preferencia.';

  @override
  String get settingsDailyReminderTitle => 'Recordatorio diario';

  @override
  String get settingsDailyReminderDescription => 'Breve recordatorio diario';

  @override
  String get settingsReminderTime => 'Hora del Recordatorio';

  @override
  String get settingsFixedReminderTimeTitle => 'Tiempo de Recordatorio Fijo';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Elija una hora fija para el recordatorio';

  @override
  String get settingsAlwaysSendReminderTitle => 'Siempre enviar recordatorio';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Enviar recordatorio aunque ya se haya hecho un registro del dia';

  @override
  String get settingsCustomizeNotificationTitle =>
      'Personalizar notificaciones';

  @override
  String get settingsTemplatesTitle => 'Plantillas';

  @override
  String get settingsDefaultTemplate => 'Plantilla Predeterminada';

  @override
  String get manageTemplates => 'Administrar Plantillas';

  @override
  String get addTemplate => 'Agregar una Plantilla';

  @override
  String get newTemplate => 'Nueva Plantilla';

  @override
  String get noTemplateTitle => 'Ninguno';

  @override
  String get noTemplatesDescription => 'Aún no se han creado plantillas…';

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
  String get settingsStorageTitle => 'Almacenamiento';

  @override
  String get settingsImageQuality => 'Calidad de Imagen';

  @override
  String get imageQualityHigh => 'Alta';

  @override
  String get imageQualityMedium => 'Media';

  @override
  String get imageQualityLow => 'Baja';

  @override
  String get imageQualityNoCompression => 'Sin Compresión';

  @override
  String get settingsLogFolder => 'Carpeta de entradas';

  @override
  String get settingsImageFolder => 'Carpeta de Imágenes';

  @override
  String get warningTitle => 'Advertencia';

  @override
  String get logFolderWarningDescription =>
      'Si la carpeta seleccionada ya contiene un archivo \'daily_you.db\', se usará para sobrescribir tus entradas existentes!';

  @override
  String get errorTitle => 'Error';

  @override
  String get logFolderErrorDescription =>
      '¡No se pudo cambiar la carpeta de registro!';

  @override
  String get imageFolderErrorDescription =>
      '¡No se pudo cambiar la carpeta de imágenes!';

  @override
  String get backupErrorDescription => '¡Error al intentar crear un resplado!';

  @override
  String get restoreErrorDescription => '¡Error en restaurar respaldo!';

  @override
  String get settingsBackupRestoreTitle => 'Respaldo y Restauracion';

  @override
  String get settingsBackup => 'Respaldo';

  @override
  String get settingsRestore => 'Restauracion';

  @override
  String get settingsRestorePromptDescription =>
      '¡Restaurar un respaldo hara sobreescritura en tus datos ya existente!';

  @override
  String tranferStatus(Object percent) {
    return 'Transfiriendo... $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Creando Respaldo... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Restaurando Respaldo… $percent%';
  }

  @override
  String get cleanUpStatus => 'Restableciendo…';

  @override
  String get settingsExport => 'Exportar';

  @override
  String get settingsExportToAnotherFormat => 'Exportar A Otro Formato';

  @override
  String get settingsExportFormatDescription =>
      '¡Esto no deberia ser usado como un\nrespaldo!';

  @override
  String get exportLogs => 'Exportar Registros';

  @override
  String get exportImages => 'Exportar Imágenes';

  @override
  String get settingsImport => 'Importar';

  @override
  String get settingsImportFromAnotherApp => 'Importar de otra aplicacion';

  @override
  String get settingsTranslateCallToAction =>
      'Todos deberian tener acceso a el diario!';

  @override
  String get settingsHelpTranslate => 'Ayuda a traducir';

  @override
  String get importLogs => 'Importar Registros';

  @override
  String get importImages => 'Importar Imágenes';

  @override
  String get logFormatTitle => 'Elija Formato';

  @override
  String get logFormatDescription =>
      'Otros formatos de aplicaciones pueden no soportar todas las caracteristicas. Por favor reporta cualquier problema, ya que los formatos de terceros pueden cambiar con el tiempo. Esto no afectara a los registros ya existentes';

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
  String get formatMarkdown => 'Reduccion';

  @override
  String get settingsDeleteAllLogsTitle => 'Eliminar Todos los Registros';

  @override
  String get settingsDeleteAllLogsDescription =>
      '¿Quieres eliminar todos tus registros?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Escribe \'$prompt\'para confirmar. ¡Esto no se puede desahacer!';
  }

  @override
  String get settingsLanguageTitle => 'Lenguaje';

  @override
  String get settingsAppLanguageTitle => 'Lenguaje de aplicacion';

  @override
  String get settingsOverrideAppLanguageTitle =>
      'Anular lenguaje de aplicacion';

  @override
  String get settingsSecurityTitle => 'Seguridad';

  @override
  String get settingsSecurityRequirePassword => 'Requiere Contraseña';

  @override
  String get settingsSecurityEnterPassword => 'Introduzca la contraseña';

  @override
  String get settingsSecuritySetPassword => 'Establecer contraseña';

  @override
  String get settingsSecurityChangePassword => 'Cambiar contraseña';

  @override
  String get settingsSecurityPassword => 'Contraseña';

  @override
  String get settingsSecurityConfirmPassword => 'Confirmar contraseña';

  @override
  String get settingsSecurityOldPassword => 'Contraseña antigua';

  @override
  String get settingsSecurityIncorrectPassword => 'Contraseña incorrecta';

  @override
  String get settingsSecurityPasswordsDoNotMatch =>
      'Las contraseñas no coinciden';

  @override
  String get requiredPrompt => 'Necesario';

  @override
  String get settingsSecurityBiometricUnlock => 'Desbloqueo biometrico';

  @override
  String get unlockAppPrompt => 'Desbloquea la aplicacion';

  @override
  String get settingsAboutTitle => 'Acerca de';

  @override
  String get settingsVersion => 'Versión';

  @override
  String get settingsLicense => 'Licencia';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Código Fuente';

  @override
  String get settingsMadeWithLove => 'Hecho con 💚';

  @override
  String get settingsConsiderSupporting => 'Considera en apoyar';

  @override
  String get tagMoodTitle => 'Ánimo';

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
