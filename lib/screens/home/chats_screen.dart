import 'package:flutter/material.dart';
import 'package:log_in/screens/authenticate/InitialPage.dart';
import 'package:log_in/services/auth.dart';
import 'body.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.orange,
        child: Icon(
            Icons.person_add_alt_1,
            color: Colors.white,
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: (value) {
        setState(() {
          _selectedIndex = value;
        }
        );
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.messenger), label: "Chats"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label:"Profile",)
      ]
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text('Chats'),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }
}
