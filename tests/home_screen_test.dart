import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_chat/screens/home_screen.dart';
import 'package:we_chat/screens/profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(); // Firebase must be initialized
  });

  testWidgets('HomeScreen shows search and profile icon', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Check if app bar title is correct
    expect(find.text('Firebase Chat'), findsOneWidget);

    // Check for search and add user buttons
    expect(find.byIcon(Icons.search), findsNothing); // CupertinoIcons.search is used
    expect(find.byIcon(CupertinoIcons.search), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.person_add), findsOneWidget);
  });

  testWidgets('Tapping search toggles TextField', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Tap on the search icon
    await tester.tap(find.byIcon(CupertinoIcons.search));
    await tester.pumpAndSettle();

    // TextField should appear
    expect(find.byType(TextField), findsOneWidget);

    // Tap on the clear search icon
    await tester.tap(find.byIcon(CupertinoIcons.clear_circled_solid));
    await tester.pumpAndSettle();

    // App title should return
    expect(find.text('Firebase Chat'), findsOneWidget);
  });

  testWidgets('Tapping profile button navigates to ProfileScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    final profileButton = find.byType(IconButton).first;
    await tester.tap(profileButton);
    await tester.pumpAndSettle();

    expect(find.byType(ProfileScreen), findsOneWidget);
  });
}
