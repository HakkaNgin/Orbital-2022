import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:log_in/models/firebase_login_user.dart';
import 'package:log_in/screens/authenticate/log_in.dart';
import 'package:log_in/screens/home/home.dart';
import 'package:log_in/screens/wrapper.dart';
import 'package:log_in/services/auth.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'mock.dart';

Future<T> neverEndingFuture<T>() async {
  // ignore: literal_only_boolean_expressions
  while (true) {
    await Future.delayed(const Duration(minutes: 5));
  }
}

class MockAuth extends Mock implements BaseAuth {}
class MockFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseCore extends Mock implements Firebase {}

void main() async {


  // IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // setupFirebaseAuthMocks();
  //
  // setUpAll(() async {
  //   await Firebase.initializeApp();
  // });

  // MockFirestore mockFirestore;
  // MockFirebaseCore.initializeApp();
  //
  // setUp(() {
  //   mockFirestore = MockFirestore();
  // });

  // MockFirebaseCore

  // testWidgets('Your Test', (WidgetTester tester) async {
  //   final YourFirebaseAuthClass authService = YourFirebaseAuthClass();
  //   // Tests to write
  // });


  // TestWidgetsFlutterBinding.ensureInitialized(); // to prevent bugs
  // Firebase.ini

  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (tester) async {

    // arrange

    // act

    // assert


    // Test code goes here.
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(LogInPage());

    // Create the Finders.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });

  // testWidgets("add a todo", (WidgetTester tester) async {
  //   //find all widgets needed
  //   final addField = find.byKey(ValueKey("addField"));
  //   final addButton = find.byKey(ValueKey("addButton"));
  //
  //   //execute the actual test
  //   await tester.pumpWidget(MaterialApp(home: HomeScreen()));
  //   await tester.enterText(addField, "Make Widget Testing Video");
  //   await tester.tap(addButton);
  //   await tester.pump(); //rebuilds your widget
  //
  //   //check outputs
  //   expect(find.text("Make Widget Testing Video"), findsOneWidget);
  // });
  //
  // testWidgets("add from database", (WidgetTester tester) async {
  //   //find all widgets needed
  //   final loadFromDatabase = find.byKey(ValueKey("loadFromDatabase"));
  //
  //   //execute the actual test
  //   await tester.pumpWidget(MaterialApp(home: HomeScreen()));
  //   await tester.tap(loadFromDatabase);
  //   await tester.pump(Duration(seconds: 2)); //rebuilds your widget
  //
  //   //check outputs
  //   expect(find.text("From Database"), findsOneWidget);
  // });

  Widget makeTestableWidget({required Widget child, required BaseAuth auth}) {
    // to imitate the sign in process
    return StreamProvider<LoginUser?>.value(
      initialData: null,
      value: auth.user,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('email or password is empty, does not sign in', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();

   // bool didSignIn = false;
    LogInPage page = LogInPage();
    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth)); // build the login page

    // tester presses the log in button
    final logIn = find.byKey(const Key('Log In'));
    await tester.tap(logIn);

    verifyNever(mockAuth.loginWithEmailAndPassword('', ''));
    // expect(didSignIn, false);
  });

  /*testWidgets('non-empty email and password, valid account, call sign in, succeed', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();
    when(mockAuth.loginWithEmailAndPassword('email', 'password')).thenAnswer((invocation) => Future.value('uid'));

    bool didSignIn = false;
    LogInPage page = LogInPage();

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    Finder emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(Key('password'));
    await tester.enterText(passwordField, 'password');

    await tester.tap(find.byKey(Key('signIn')));

    verify(mockAuth.loginWithEmailAndPassword('email', 'password')).called(1);
    expect(didSignIn, true);

  });

  testWidgets('non-empty email and password, valid account, call sign in, fails', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();
    when(mockAuth.loginWithEmailAndPassword('email', 'password')).thenThrow(StateError('invalid credentials'));

    bool didSignIn = false;
    LogInPage page = LogInPage();

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    Finder emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(Key('password'));
    await tester.enterText(passwordField, 'password');

    await tester.tap(find.byKey(Key('signIn')));

    verify(mockAuth.loginWithEmailAndPassword('email', 'password')).called(1);
    expect(didSignIn, false);*/

  // });

}