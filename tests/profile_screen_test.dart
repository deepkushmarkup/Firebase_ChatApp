import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/profile_screen.dart';

void main() {
  // Dummy ChatUser for test
  final dummyUser = ChatUser(
    id: '123',
    name: 'Test User',
    email: 'test@example.com',
    about: 'Test About',
    image: '',
    createdAt: '',
    isOnline: false,
    lastActive: '',
    pushToken: '',
  );

  testWidgets('ProfileScreen loads and displays user info', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProfileScreen(user: dummyUser)));

    expect(find.text('Profile Screen'), findsOneWidget);
    expect(find.text(dummyUser.email), findsOneWidget);
    expect(find.text('UPDATE'), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });

  testWidgets('ProfileScreen shows bottom sheet when editing image', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProfileScreen(user: dummyUser)));

    final editButton = find.byIcon(Icons.edit).last;
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    expect(find.text('Pick Profile Picture'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('ProfileScreen validates and saves form', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProfileScreen(user: dummyUser)));

    final nameField = find.widgetWithText(TextFormField, 'Name');
    final aboutField = find.widgetWithText(TextFormField, 'About');

    await tester.enterText(nameField, 'Updated Name');
    await tester.enterText(aboutField, 'Updated About');
    await tester.tap(find.text('UPDATE'));
    await tester.pump(); // process validation and snackbar

    // Check if snackbar shows up
    expect(find.text('Profile Updated Successfully!'), findsOneWidget);
  });

  testWidgets('Logout button triggers logout flow', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ProfileScreen(user: dummyUser)));

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pump(const Duration(milliseconds: 500)); // simulate dialog animation

    // You should mock and verify navigation or state here.
    // For now, this just ensures the button can be tapped without crashing.
    expect(find.byType(ProfileScreen), findsOneWidget); // still on same screen for now
  });
}
