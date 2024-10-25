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
  Future<void> updateHeadline() async {
    await HomeWidget.saveWidgetData<String>(
      'headline_title',
      _headlineTitle,
    );
    await HomeWidget.saveWidgetData<String>(
      'headline_subtitle',
      _headlineSubtitle,
    );
    if (_headlineImage != null) {
      await HomeWidget.saveWidgetData<String>(
        'headline_image',
        _headlineImage,
      );
    }
    await HomeWidget.updateWidget(
      name: 'VisualizerMusic',
      androidName: 'VisualizerMusic',
    );
  }
}
