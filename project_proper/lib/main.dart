import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/wrapper.dart';
import 'package:log_in/services/auth.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'NUSOCIAL',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: Wrapper(),
      ),
    );
  }
}


