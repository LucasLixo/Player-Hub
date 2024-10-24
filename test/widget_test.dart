import 'package:player_hub/app/app_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Teste Widget', (WidgetTester tester) async {
    await tester.pumpWidget(const AppWidget());
  });
}
