enum AppLanguages {
  // ==================================================
  english(
    title: 'English',
    code: 0,
  ),
  portugues(
    title: 'Português',
    code: 1,
  ),
  espanol(
    title: 'Español',
    code: 2,
  );

  // ==================================================
  const AppLanguages({
    required this.title,
    required this.code,
  });

  // ==================================================
  final String title;
  final int code;

  // ==================================================
  static final List<String> getLanguagesTitle = [
    for (var index in AppLanguages.values) index.title,
  ];

  // ==================================================
  static final List<int> getLanguagesCode = [
    for (var index in AppLanguages.values) index.code,
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
