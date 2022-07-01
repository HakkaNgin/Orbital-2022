import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';
import '../chat/chats_screen.dart';
import '../profile/profile_screen.dart';
import '../search/search_screen.dart';

late String homeCurrentUserID;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.theCurrentUserID}) : super(key: key);
  final String theCurrentUserID;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  int index = 0;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final followersRef = FirebaseFirestore.instance.collection('followers');
  final followingRef = FirebaseFirestore.instance.collection('following');
  List<dynamic> users = [];

  changePage(int pageIndex) {
    if (pageIndex == 0)    return ChatPage(ID: widget.theCurrentUserID);
    if (pageIndex == 1)    return Search();
    if (pageIndex == 2) {
      return ProfilePage(
        profileUserID: widget.theCurrentUserID,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Profile",
          style: TextStyle(
            color:Colors.white,
            fontSize: 24),
          ),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT!!
    homeCurrentUserID = widget.theCurrentUserID;
    return Scaffold(
      body: changePage(index),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: Colors.blue.shade100,
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Color(0xFFf1f5fb),
          selectedIndex: index,
          onDestinationSelected: (int index) =>
            setState(() => this.index = index),

          destinations: [
            NavigationDestination(
              icon: Icon(Icons.chat_bubble),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'Message',
            ),
            NavigationDestination(
              icon: Icon(Icons.search),
              selectedIcon: Icon(Icons.search),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
