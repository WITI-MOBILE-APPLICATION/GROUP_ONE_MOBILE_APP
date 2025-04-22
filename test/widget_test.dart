import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:group_one_mobile_app/main.dart';
import 'package:group_one_mobile_app/providers/movie_provider.dart';
import 'package:provider/provider.dart';

// ignore: depend_on_referenced_packages
// import 'package:my_app/main.dart';
// import 'package:my_app/providers/movie_provider.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Wrap the app inside a provider to avoid missing dependencies
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MovieProvider()),
        ],
        child: MyApp(),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
