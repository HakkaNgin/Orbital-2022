import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../services/auth.dart';
import '../screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'models/firebase_login_user.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamProvider<LoginUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'NUSOCIAL',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: Wrapper(),
      ),
    );
  }
}


