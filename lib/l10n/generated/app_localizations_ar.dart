// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Daily You';

  @override
  String get dailyReminderTitle => 'سَجِّل اليوم!';

  @override
  String get dailyReminderDescription => 'خذ سجل يومياتك…';

  @override
  String get actionTakePhoto => 'Take photo';

  @override
  String get pageHomeTitle => 'الرئيسية';

  @override
  String get flashbacksTitle => 'الذكريات';

  @override
  String get settingsFlashbacksExcludeBadDays => 'استبعد الأيام السيئة';

  @override
  String get flaskbacksEmpty => 'لا توجد ذكريات حتى الآن…';

  @override
  String get flashbackGoodDay => 'يوم جيد';

  @override
  String get flashbackRandomDay => 'يوم عشوائي';

  @override
  String flashbackWeek(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count أسبوع',
      many: 'منذ $count أسبوعًا',
      few: 'منذ $count أسابيع',
      two: 'منذ أسبوعين',
      one: 'منذ أسبوع واحد',
      zero: 'منذ $count أسبوع',
    );
    return '$_temp0';
  }

  @override
  String flashbackMonth(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count أشهر',
      one: 'منذ شهر واحد',
    );
    return '$_temp0';
  }

  @override
  String flashbackYear(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count سنوات',
      one: 'منذ سنة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get pageGalleryTitle => 'المعرض';

  @override
  String get searchLogsHint => 'ابحث في السجلات…';

  @override
  String logCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count سجلات',
      one: '$count سجل',
    );
    return '$_temp0';
  }

  @override
  String wordCount(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count كلمات',
      one: '$count كلمة',
    );
    return '$_temp0';
  }

  @override
  String get noLogs => 'لا توجد سجلات…';

  @override
  String get sortDateTitle => 'التاريخ';

  @override
  String get sortOrderAscendingTitle => 'تصاعدي';

  @override
  String get sortOrderDescendingTitle => 'تنازلي';

  @override
  String get pageStatisticsTitle => 'إحصائيات';

  @override
  String get statisticsNotEnoughData => 'لا توجد بيانات كافية…';

  @override
  String get statisticsRangeOneMonth => 'شهر';

  @override
  String get statisticsRangeSixMonths => '٦ أشهر';

  @override
  String get statisticsRangeOneYear => 'سنة';

  @override
  String get statisticsRangeAllTime => 'كل الأوقات';

  @override
  String chartSummaryTitle(Object tag) {
    return '$tag الملخص';
  }

  @override
  String chartByDayTitle(Object tag) {
    return '$tag حسب اليوم';
  }

  @override
  String streakCurrent(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'السلسلة الحالية $count',
    );
    return '$_temp0';
  }

  @override
  String streakLongest(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أطول سلسلة $count',
    );
    return '$_temp0';
  }

  @override
  String streakSinceBadDay(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'أيام منذ يوم سيء',
      one: 'يوم منذ يوم سيء',
    );
    return '$_temp0';
  }

  @override
  String get errorExternalStorageAccessTitle =>
      'لا يمكن الوصول إلى وحدة التخزين الخارجية';

  @override
  String get errorExternalStorageAccessDescription =>
      'إذا كنت تستخدم التخزين عبر الانترنت تأكد من أن الخدمة متاحة ولديك وصول للشبكة.\n\nوإلا فقد يكون التطبيق فقد الأذونات للمجلد الخارجي. اذهب إلى الإعدادات وأعد اختيار المجلد الخارجي لمنح الوصول.\n\nتحذير، لن تتم مزامنة التغييرات حتى تستعيد الوصول إلى موقع التخزين الخارجي!';

  @override
  String get errorExternalStorageAccessContinue =>
      'متابعة مع قاعدة البيانات المحلية';

  @override
  String get lastModified => 'معدّل';

  @override
  String get writeSomethingHint => 'اكتب شيئًا…';

  @override
  String get titleHint => 'عنوان…';

  @override
  String get deleteLogTitle => 'احذف السجل';

  @override
  String get deleteLogDescription => 'هل تريد حذف هذا السجل؟';

  @override
  String get deletePhotoTitle => 'احذف الصورة';

  @override
  String get deletePhotoDescription => 'هل تريد حذف هذه الصورة؟';

  @override
  String get pageSettingsTitle => 'الإعدادات';

  @override
  String get settingsAppearanceTitle => 'المظهر';

  @override
  String get settingsTheme => 'السمة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeAmoled => 'أموليد';

  @override
  String get settingsFirstDayOfWeek => 'أول يوم في الأسبوع';

  @override
  String get settingsUseSystemAccentColor => 'استخدم ألوان النظام';

  @override
  String get settingsCustomAccentColor => 'لون مخصص';

  @override
  String get settingsShowMarkdownToolbar => 'إظهار شريط أدوات Markdown';

  @override
  String get settingsShowFlashbacks => 'اعرض الذكريات';

  @override
  String get settingsChangeMoodIcons => 'غيِّر شكل الأيقونات';

  @override
  String get moodIconPrompt => 'أدخل أيقونة';

  @override
  String get settingsFlashbacksViewLayout => 'طريقة عرض الذكريات';

  @override
  String get settingsGalleryViewLayout => 'طريقة عرض الصور';

  @override
  String get settingsHideImagesInGallery => 'إخفاء الصور من معرض الصور';

  @override
  String get viewLayoutList => 'قائمة';

  @override
  String get viewLayoutGrid => 'شبكة';

  @override
  String get settingsNotificationsTitle => 'الإشعارات';

  @override
  String get settingsDailyReminderOnboarding =>
      'قم بتفعيل التذكيرات اليومية لتحافظ على استمرارك!';

  @override
  String get settingsNotificationsPermissionsPrompt =>
      'سيتم طلب إذن \"جدولة التنبيهات\" لإرسال التذكير في لحظة عشوائية أو في الوقت المفضل لديك.';

  @override
  String get settingsDailyReminderTitle => 'تذكير يومي';

  @override
  String get settingsDailyReminderDescription => 'تذكير لطيف كل يوم';

  @override
  String get settingsReminderTime => 'وقت التذكير';

  @override
  String get settingsFixedReminderTimeTitle => 'وقت التذكير الثابت';

  @override
  String get settingsFixedReminderTimeDescription =>
      'اختر وقتًا ثابتًا للتذكير';

  @override
  String get settingsAlwaysSendReminderTitle => 'أرسل تذكير دائمًا';

  @override
  String get settingsAlwaysSendReminderDescription =>
      'أرسل تذكير حتى لو تم بدء السجل بالفعل';

  @override
  String get settingsCustomizeNotificationTitle => 'تخصيص الإشعارات';

  @override
  String get settingsTemplatesTitle => 'القوالب';

  @override
  String get settingsDefaultTemplate => 'القالب الافتراضي';

  @override
  String get manageTemplates => 'إدارة القوالب';

  @override
  String get addTemplate => 'إضافة قالب';

  @override
  String get newTemplate => 'قالب جديد';

  @override
  String get noTemplateTitle => 'لا شيء';

  @override
  String get noTemplatesDescription => 'لم يتم إنشاء أي قوالب بعد…';

  @override
  String get templateVariableTime => 'الوقت';

  @override
  String get templateDefaultTimestampTitle => 'الطابع الزمني';

  @override
  String templateDefaultTimestampBody(Object date, Object time) {
    return '$date - $time:';
  }

  @override
  String get templateDefaultSummaryTitle => 'ملخص اليوم';

  @override
  String get templateDefaultSummaryBody => '### Summary\n- \n\n### Quote\n> ';

  @override
  String get templateDefaultReflectionTitle => 'Reflection';

  @override
  String get templateDefaultReflectionBody =>
      '### What did you enjoy about today?\n- \n\n### What are you thankful for?\n- \n\n### What are you looking forward to?\n- ';

  @override
  String get settingsStorageTitle => 'التخزين';

  @override
  String get settingsImageQuality => 'جودة الصورة';

  @override
  String get imageQualityHigh => 'عالية';

  @override
  String get imageQualityMedium => 'متوسطة';

  @override
  String get imageQualityLow => 'منخفضة';

  @override
  String get imageQualityNoCompression => 'بدون ضغط';

  @override
  String get settingsLogFolder => 'مجلد السجل';

  @override
  String get settingsImageFolder => 'مجلد الصور';

  @override
  String get warningTitle => 'تحذير';

  @override
  String get logFolderWarningDescription =>
      'إذا كان المجلد المحدد يحتوي بالفعل على ملف \"daily_you.db\"، فسيتم استخدامه لاستبدال سجلاتك الحالية!';

  @override
  String get errorTitle => 'خطأ';

  @override
  String get logFolderErrorDescription => 'فشل في تغيير مجلد السجل!';

  @override
  String get imageFolderErrorDescription => 'فشل في تغيير مجلد الصور!';

  @override
  String get backupErrorDescription => 'فشل في إنشاء النسخة الاحتياطية!';

  @override
  String get restoreErrorDescription => 'فشل في استعادة النسخة الاحتياطية!';

  @override
  String get settingsBackupRestoreTitle => 'النسخ الاحتياطي والاستعادة';

  @override
  String get settingsBackup => 'النسخ الاحتياطي';

  @override
  String get settingsRestore => 'الاستعادة';

  @override
  String get settingsRestorePromptDescription =>
      'إن استعادة النسخة الاحتياطية سوف يؤدي إلى استبدال بياناتك الحالية!';

  @override
  String tranferStatus(Object percent) {
    return 'جارٍ النقل… $percent%';
  }

  @override
  String creatingBackupStatus(Object percent) {
    return 'جارٍ إنشاء نسخة احتياطية... $percent%';
  }

  @override
  String restoringBackupStatus(Object percent) {
    return 'جارٍ استعادة النسخة الاحتياطية… $percent%';
  }

  @override
  String get cleanUpStatus => 'جارٍ التنظيف…';

  @override
  String get settingsExport => 'Export';

  @override
  String get settingsExportToAnotherFormat => 'التصدير إلى تنسيق آخر';

  @override
  String get settingsExportFormatDescription =>
      'لا ينبغي استخدام هذا كنسخة احتياطية!';

  @override
  String get exportLogs => 'Export Logs';

  @override
  String get exportImages => 'Export Images';

  @override
  String get settingsImport => 'Import';

  @override
  String get settingsImportFromAnotherApp => 'الاستيراد من تطبيق آخر';

  @override
  String get settingsTranslateCallToAction =>
      'ينبغي أن يكون لدى الجميع إمكانية الوصول إلى دفتر اليوميات!';

  @override
  String get settingsHelpTranslate => 'ساعد في الترجمة';

  @override
  String get importLogs => 'Import Logs';

  @override
  String get importImages => 'Import Images';

  @override
  String get logFormatTitle => 'اختر التنسيق';

  @override
  String get logFormatDescription =>
      'قد لا يدعم تنسيق تطبيق آخر جميع الميزات. يُرجى الإبلاغ عن أي مشاكل، إذ قد تتغير تنسيقات الجهات الخارجية في أي وقت. لن يؤثر هذا على السجلات الحالية!';

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
  String get formatMarkdown => 'ماركداون (markdown)';

  @override
  String get settingsDeleteAllLogsTitle => 'احذف جميع السجلات';

  @override
  String get settingsDeleteAllLogsDescription => 'هل تريد حذف كافة سجلاتك؟';

  @override
  String settingsDeleteAllLogsPrompt(Object prompt) {
    return 'أدخل \'$prompt\' للتأكيد. لا يمكن التراجع عن هذا!';
  }

  @override
  String get settingsLanguageTitle => 'اللغة';

  @override
  String get settingsAppLanguageTitle => 'لغة التطبيق';

  @override
  String get settingsOverrideAppLanguageTitle => 'أجبر لغة التطبيق';

  @override
  String get settingsSecurityTitle => 'الأمان';

  @override
  String get settingsSecurityRequirePassword => 'اطلب كلمة مرور';

  @override
  String get settingsSecurityEnterPassword => 'أدخل كلمة المرور';

  @override
  String get settingsSecuritySetPassword => 'تعيين كلمة المرور';

  @override
  String get settingsSecurityChangePassword => 'تغيير كلمة المرور';

  @override
  String get settingsSecurityPassword => 'كلمة المرور';

  @override
  String get settingsSecurityConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get settingsSecurityOldPassword => 'كلمة المرور القديمة';

  @override
  String get settingsSecurityIncorrectPassword => 'كلمة المرور غير صحيحة';

  @override
  String get settingsSecurityPasswordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get requiredPrompt => 'مطلوب';

  @override
  String get settingsSecurityBiometricUnlock =>
      'افتح باستخدام القياسات الحيوية';

  @override
  String get unlockAppPrompt => 'افتح التطبيق';

  @override
  String get settingsAboutTitle => 'عن التطبيق';

  @override
  String get settingsVersion => 'الإصدار';

  @override
  String get settingsLicense => 'الرخصة';

  @override
  String get licenseGPLv3 => 'GPL-3.0';

  @override
  String get settingsSourceCode => 'الكود المصدري';

  @override
  String get settingsMadeWithLove => 'مصنوع ب ❤️';

  @override
  String get settingsConsiderSupporting => 'فكر في الدعم';

  @override
  String get tagMoodTitle => 'المزاج';

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
