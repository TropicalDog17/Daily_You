// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => 'Напиши про день!';

  @override
  String get dailyReminderDescription => 'Час написати про сьогодні…';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get pageHomeTitle => 'Домашня';

  @override
  String get flashbacksTitle => 'Спогади';

  @override
  String get settingsFlashbacksExcludeBadDays => 'Виключити погані дні';

  @override
  String get flaskbacksEmpty => 'Ще немає спогадів…';

  @override
  String get flashbackGoodDay => 'Хороший день';

  @override
  String get flashbackRandomDay => 'Випадковий день';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count тижнів тому',
      few: '$count тижні тому',
      one: '$count тиждень тому',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count місяців тому',
      few: '$count місяці тому',
      one: '$count місяць тому',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count років тому',
      few: '$count роки тому',
      one: '$count рік тому',
    );
    return '$_temp0';
  }

  @override
  String get pageGalleryTitle => 'Галерея';

  @override
  String get searchLogsHint => 'Шукати запис…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count записів',
      few: '$count записи',
      one: '$count запис',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count слова',
      one: '$count слово',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'Немає записів…';

  @override
  String get sortDateTitle => 'За датою';

  @override
  String get sortOrderAscendingTitle => 'За зростанням';

  @override
  String get sortOrderDescendingTitle => 'За зменшенням';

  @override
  String get pageStatisticsTitle => 'Статистика';

  @override
  String get statisticsNotEnoughData => 'Недостатньо даних…';

  @override
  String get statisticsRangeOneMonth => '1 місяць';

  @override
  String get statisticsRangeSixMonths => '6 місяців';

  @override
  String get statisticsRangeOneYear => '1 рік';

  @override
  String get statisticsRangeAllTime => 'За весь час';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag зведений';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag за днем тижня';
  }

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Поточний ланцюжок: $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Найдовший ланцюжок: $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Пройшло днів з останнього поганого дня: $count',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'Не вдається отримати доступ до зовнішнього сховища';

  @override
  String get errorExternalStorageAccessDescription =>
      'Якщо ви використовуєте мережеве сховище, перевірте інтернет і доступ до сервісу сховища.\n\nТакож DailyYou могла втратити дозволи на доступ до зовнішньої теки. Перейдіть до налаштувань і знову виберіть зовнішню теку, щоб надати до неї доступ.\n\nУвага, зміни не будуть синхронізовані, доки ви не відновите доступ до зовнішнього сховища!';

  @override
  String get errorExternalStorageAccessContinue =>
      'Використовувати натомість локальне сховище';

  @override
  String get lastModified => 'Востаннє змінено';

  @override
  String get writeSomethingHint => 'Щось таки написати ж треба…';

  @override
  String get titleHint => 'Назва…';

  @override
  String get deleteLogTitle => 'Видалити запис';

  @override
  String get deleteLogDescription => 'Точно хочете видалити цей запис?';

  @override
  String get deletePhotoTitle => 'Видалити фото';

  @override
  String get deletePhotoDescription => 'Все ж таки видалити це фото?';

  @override
  String get pageSettingsTitle => 'Налаштування';

  @override
  String get settingsAppearanceTitle => 'Зовнішній вигляд';

  @override
  String get settingsTheme => 'Тема';

  @override
  String get themeSystem => 'Як у системі';

  @override
  String get themeLight => 'Світла';

  @override
  String get themeDark => 'Темна';

  @override
  String get themeAmoled => 'Я бачу вас цікавить пітьма (OLED)';

  @override
  String get settingsFirstDayOfWeek => 'Перший день тижня';

  @override
  String get settingsUseSystemAccentColor =>
      'Використовувати колір акценту як в системі';

  @override
  String get settingsCustomAccentColor => 'Обрати свій колір акценту';

  @override
  String get settingsShowMarkdownToolbar =>
      'Відображати панель форматування тексту';

  @override
  String get settingsShowFlashbacks => 'Показати флешбеки';

  @override
  String get settingsChangeMoodIcons => 'Змініть емоджи настроїв';

  @override
  String get moodIconPrompt => 'Введіть іконку (емоджи)';

  @override
  String get settingsFlashbacksViewLayout => 'Макет перегляду флешбеків';

  @override
  String get settingsGalleryViewLayout => 'Макет перегляду галереї';

  @override
  String get settingsHideImagesInGallery => 'Приховати зображення в галереї';

  @override
  String get viewLayoutList => 'Список';

  @override
  String get viewLayoutGrid => 'Сітка';

  @override
  String get settingsNotificationsTitle => 'Нагадування';

  @override
  String get settingsDailyReminderOnboarding =>
      'Увімкніть щоденні нагадування, щоб залишатися послідовним!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'Для надсилання нагадування у випадковий момент або у вибраний вами час буде запрошено дозвіл на «запланування будильників».';

  @override
  String get settingsDailyReminderTitle => 'Кожноденне нагадування';

  @override
  String get settingsDailyReminderDescription => 'Ніжне нагадування щодня';

  @override
  String get settingsReminderTime => 'Час нагадування';

  @override
  String get settingsFixedReminderTimeTitle => 'Фіксований час нагадування';

  @override
  String get settingsFixedReminderTimeDescription =>
      'Оберіть точний час для нагадувань';

  @override
  String get settingsAlwaysSendReminderTitle => 'Завжди надсилати нагадування';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'Надсилати нагадування, навіть якщо ведення журналу вже розпочато';

  @override
  String get settingsCustomizeNotificationTitle => 'Налаштувати сповіщення';

  @override
  String get settingsTemplatesTitle => 'Шаблони';

  @override
  String get settingsDefaultTemplate => 'Шаблон за замовчуванням';

  @override
  String get manageTemplates => 'Керувати шаблонами';

  @override
  String get addTemplate => 'Додати шаблон';

  @override
  String get newTemplate => 'Новий шаблон';

  @override
  String get noTemplateTitle => 'Порожній';

  @override
  String get noTemplatesDescription => 'Жодного шаблону немає…';

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
  String get settingsStorageTitle => 'Сховище';

  @override
  String get settingsImageQuality => 'Якість світлин';

  @override
  String get imageQualityHigh => 'Висока';

  @override
  String get imageQualityMedium => 'Середня';

  @override
  String get imageQualityLow => 'Низька';

  @override
  String get imageQualityNoCompression => 'Оригінальна';

  @override
  String get settingsLogFolder => 'Тека для записів';

  @override
  String get settingsImageFolder => 'Тека для світлин';

  @override
  String get warningTitle => 'Увага';

  @override
  String get logFolderWarningDescription =>
      'Якщо вибрана тека вже містить файл \'daily_you.db\', він перезапише існуючі записи в журналі!';

  @override
  String get errorTitle => 'Помилка';

  @override
  String get logFolderErrorDescription =>
      'Не вдалось змінити теку для записів!';

  @override
  String get imageFolderErrorDescription =>
      'Не вдалось змінити теку для світлин!';

  @override
  String get backupErrorDescription => 'Не вдалось створити резервну копію!';

  @override
  String get restoreErrorDescription => 'Не вдалось відновити резервну копію!';

  @override
  String get settingsBackupRestoreTitle => 'Резервне копіювання та відновлення';

  @override
  String get settingsBackup => 'Резервна копія';

  @override
  String get settingsRestore => 'Відновити резервну копію';

  @override
  String get settingsRestorePromptDescription =>
      'Відновлення резервної копії перезапише всі дані!';

  @override
  String tranferStatus(Object percent) {
    return 'Обробка… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'Створення резервної копії… $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'Відновлення із резервної копії… $percent%';
  }

  @override
  String get cleanUpStatus => 'Замітаємо сліди…';

  @override
  String get settingsExport => 'Експорт';

  @override
  String get settingsExportToAnotherFormat => 'Експорт в інший формат';

  @override
  String get settingsExportFormatDescription =>
      'Це не слід використовувати як резервний варіант!';

  @override
  String get exportLogs => 'Експортувати записи';

  @override
  String get exportImages => 'Експортувати світлини';

  @override
  String get settingsImport => 'Імпорт';

  @override
  String get settingsImportFromAnotherApp => 'Імпорт з іншої програми';

  @override
  String get settingsTranslateCallToAction =>
      'Кожен повинен мати доступ до щоденника!';

  @override
  String get settingsHelpTranslate => 'Допомога з перекладом';

  @override
  String get importLogs => 'Імпортувати записи';

  @override
  String get importImages => 'Імпортувати світлини';

  @override
  String get logFormatTitle => 'Оберіть тип файлу';

  @override
  String get logFormatDescription =>
      'Формат іншої програми може не підтримувати всі функції. Будь ласка, повідомляйте про будь-які проблеми, оскільки формати сторонніх розробників можуть змінитися будь-коли. Це не вплине на існуючі журнали!';

  @override
  String get formatDailyYouJson => 'Daily You (JSON)';

  @override
  String get formatDaybook => 'Щоденник';

  @override
  String get formatDaylio => 'Daylio';

  @override
  String get formatDiarium => 'Diarium';

  @override
  String get formatDiaro => 'Діаро';

  @override
  String get formatMyBrain => 'My Brain';

  @override
  String get formatOneShot => 'OneShot';

  @override
  String get formatPixels => 'Pixels';

  @override
  String get formatMarkdown => 'Markdown';

  @override
  String get settingsDeleteAllLogsTitle => 'Видалити всі записи';

  @override
  String get settingsDeleteAllLogsDescription =>
      'Ви дійсно хочете видалити ВСІ записи журналу?';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'Введіть \'$prompt\' для підтвердження. Назад шляху вже не буде!';
  }

  @override
  String get settingsLanguageTitle => 'Мова';

  @override
  String get settingsAppLanguageTitle => 'Мова програми';

  @override
  String get settingsOverrideAppLanguageTitle => 'Перевизначити мову програми';

  @override
  String get settingsSecurityTitle => 'Безпека';

  @override
  String get settingsSecurityRequirePassword => 'Вимагати пароль';

  @override
  String get settingsSecurityEnterPassword => 'Введіть пароль';

  @override
  String get settingsSecuritySetPassword => 'Встановити пароль';

  @override
  String get settingsSecurityChangePassword => 'Змінити пароль';

  @override
  String get settingsSecurityPassword => 'Пароль';

  @override
  String get settingsSecurityConfirmPassword => 'Підтвердьте пароль';

  @override
  String get settingsSecurityOldPassword => 'Старий пароль';

  @override
  String get settingsSecurityIncorrectPassword => 'Неправильний пароль';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'Паролі не збігаються';

  @override
  String get requiredPrompt => 'Обов\'язково';

  @override
  String get settingsSecurityBiometricUnlock => 'Біометричне розблокування';

  @override
  String get unlockAppPrompt => 'Розблокувати додаток';

  @override
  String get settingsAboutTitle => 'Про нас';

  @override
  String get settingsVersion => 'Версія';

  @override
  String get settingsLicense => 'Ліцензія';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'Вихідний код';

  @override
  String get settingsMadeWithLove => 'Зроблено з ❤️';

  @override
  String get settingsConsiderSupporting => 'розглянути можливість підтримки';

  @override
  String get tagMoodTitle => 'Настрій';

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
