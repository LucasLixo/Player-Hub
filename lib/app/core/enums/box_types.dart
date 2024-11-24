enum BoxTypes {
  // ==================================================
  app,
  storage,
  others;

  // ==================================================
  @override
  String toString() {
    switch (this) {
      case BoxTypes.app:
        return 'BoxApp';
      case BoxTypes.storage:
        return 'BoxStorage';
      case BoxTypes.others:
        return 'BoxOther';
    }
  }
}
