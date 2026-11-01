import 'package:flutter_test/flutter_test.dart';
import 'package:movie_discovery/main.dart';

void main() {
  testWidgets('StreamFlix app displays its title', (WidgetTester tester) async {
    await tester.pumpWidget(const HilwaFlixApp());

    expect(find.text('STREAMFLIX'), findsOneWidget);
    expect(find.text('Temukan Film Favorit'), findsOneWidget);
  });
}
