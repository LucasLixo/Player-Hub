enum AppLanguages {
  // ==================================================
  english(
    title: 'English',
    code: 0,
    locale: ['en', 'US'],
  ),
  portugues(
    title: 'Português',
    code: 1,
    locale: ['pt', 'BR'],
  ),
  espanol(
    title: 'Español',
    code: 2,
    locale: ['es', 'ES'],
  );

  // ==================================================
  const AppLanguages({
    required this.title,
    required this.code,
    required this.locale,
  });

  // ==================================================
  final String title;
  final int code;
  final List<String> locale;

  // ==================================================
  static final List<String> getLanguagesTitle = [
    for (var index in AppLanguages.values) index.title,
  ];

  // ==================================================
  static final List<int> getLanguagesCode = [
    for (var index in AppLanguages.values) index.code,
  ];

  // ==================================================
  static final List<List<String>> getLanguagesLocale = [
    for (var index in AppLanguages.values) index.locale,
  ];

  // ==================================================
  static String getLanguagesTitleByCode(int index) {
    switch (index) {
      case 0:
        return AppLanguages.english.title;
      case 1:
        return AppLanguages.portugues.title;
      case 2:
        return AppLanguages.espanol.title;
      default:
        throw ArgumentError('Index must be between 0 and 2');
    }
  }
}
