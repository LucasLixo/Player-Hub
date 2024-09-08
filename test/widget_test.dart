import 'package:playerhub/app/app_wait.dart';
import 'package:playerhub/app/app_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Teste Widget', (WidgetTester tester) async {
    await tester.pumpWidget(const AppWait(error: false));
    await tester.pumpWidget(const AppWidget());
    await tester.pumpWidget(const AppWait(error: true));
  });
}
