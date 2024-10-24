import 'package:home_widget/home_widget.dart';

class InterfaceVisualizer {
  // ==================================================
  final String _headlineTitle;
  final String _headlineSubtitle;
  final String? _headlineImage;

  // ==================================================
  InterfaceVisualizer({
    required String headlineTitle,
    required String headlineSubtitle,
    String? headlineImage,
  })  : _headlineTitle = headlineTitle,
        _headlineSubtitle = headlineSubtitle,
        _headlineImage = headlineImage;

  // ==================================================
  void updateHeadline() {
    HomeWidget.saveWidgetData<String>(
      'headline_title',
      _headlineTitle,
    );
    HomeWidget.saveWidgetData<String>(
      'headline_subtitle',
      _headlineSubtitle,
    );
    if (_headlineImage != null) {
      HomeWidget.saveWidgetData<String>(
        'headline_image',
        _headlineImage,
      );
    }
    HomeWidget.updateWidget(
      name: 'InterfaceVisualizer',
      androidName: 'InterfaceVisualizer',
    );
  }
}
