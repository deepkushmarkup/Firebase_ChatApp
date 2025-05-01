import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:we_chat/models/chat_user.dart';
import 'package:we_chat/screens/chat_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MockChatUser extends Mock implements ChatUser {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(); // Ensure Firebase is initialized
  });

  testWidgets('ChatScreen displays message input and emoji button', (WidgetTester tester) async {
    // Mock ChatUser data
    final mockUser = ChatUser(
      id: '123',
      name: 'Test User',
      email: 'test@example.com',
      about: 'Testing',
      image: '',
      createdAt: '',
      isOnline: false,
      lastActive: DateTime.now().toString(),
      pushToken: '',
    );

    await tester.pumpWidget(MaterialApp(
      home: ChatScreen(user: mockUser),
    ));

    // Check for the input field
    expect(find.byType(TextField), findsOneWidget);

    // Check for the send button
    expect(find.byIcon(Icons.send), findsOneWidget);

    // Check for the emoji button
    expect(find.byIcon(Icons.emoji_emotions), findsOneWidget);
  });
}
