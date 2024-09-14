import 'package:home_widget/home_widget.dart';

class VisualizerMusic {
  final String headlineTitle;
  final String? headlineImage;

  VisualizerMusic({
    required this.headlineTitle,
    this.headlineImage,
  });
}

void updateHeadline(VisualizerMusic visualizerMusic) {
  HomeWidget.saveWidgetData<String>(
    'headline_title',
    visualizerMusic.headlineTitle,
  );
  if (visualizerMusic.headlineImage != null) {
    HomeWidget.saveWidgetData<String>(
      'headline_image',
      visualizerMusic.headlineImage,
    );
  }
  HomeWidget.updateWidget(
    name: 'VisualizerMusic',
    androidName: 'VisualizerMusic',
  );
}
