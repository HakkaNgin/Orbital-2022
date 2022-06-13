import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/page/chats_screen.dart';
import 'package:log_in/screens/page/profile_page.dart';
import 'package:log_in/screens/page/search.dart';
import 'package:log_in/services/auth.dart';
import 'package:log_in/shared/loading.dart';

late TheUser homeCurrentUser;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.theCurrentUser}) : super(key: key);

  final TheUser theCurrentUser;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int index = 0;
  // final screens = [Search()];
  final AuthService _auth = AuthService();

  final usersRef = FirebaseFirestore.instance.collection('users');
  List<dynamic> users = [];

  // TODO version 2 stuff
  // int pageIndex = 0;
  // PageController pageController = PageController();

  @override
  void initState() {
    // retrieves data from firebase collection of users
    // getUsers();
    getUserById();
    super.initState();
  }

  getUserById() async {
    final String tempID = 'sssss';
    final DocumentSnapshot doc = await usersRef.doc(tempID).get();
    print(doc.data());
    print(doc.id);
    print(doc.exists);
  }

  getUsers() async {
    // from users, get every individual user that is stored in a document
    final QuerySnapshot snapshot = await usersRef.get();
    setState(() {
      users = snapshot.docs ;
    });
    // snapshot.docs.forEach((DocumentSnapshot doc) {
    //
    // });
    // usersRef.get().then((QuerySnapshot snapshot) {
    //   snapshot.docs.forEach((DocumentSnapshot doc) {
    //     print(doc.data());
    //     print(doc.id);
    //     print(doc.exists);
    //   });
    // });
  }

  // TODO version 2 stuff
  // onPageChanged(int pageIndex) {
  //   setState(() {
  //     this.pageIndex = pageIndex;
  //   });
  // }
  //
  // onTap(int pageIndex) {
  //   pageController.animateToPage(
  //     pageIndex,
  //     duration: Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }
  //
  // logout() async {
  //   await _auth.authSignOut();
  //   Navigator.push(context, MaterialPageRoute(builder: (context) => InitialPage()));
  // }

  changePage(int pageIndex) {
    if (pageIndex == 0) {
      return ChatPage();
    }
    if (pageIndex == 1) {
      return Search();
    }
    if (pageIndex == 2) {
      return ProfilePage(currentUser: widget.theCurrentUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT!!
    homeCurrentUser = widget.theCurrentUser;
    return Scaffold(
      backgroundColor: Colors.blue[50],
      // appBar: AppBar(
      //   title: Text('HOME PAGE'),
      //   backgroundColor: Colors.brown[400],
      //   elevation: 0,
      //   actions: <Widget>[
      //     FlatButton.icon(
      //       icon: Icon(Icons.person),
      //       label: Text('LOG OUT'),
      //       onPressed: () async {
      //         await _auth.authSignOut();
      //         Navigator.of(context).pushReplacement(
      //             MaterialPageRoute(builder: (context) => InitialPage())
      //         );
      //       },
      //     ),
      //   ],
      // ),

      body: changePage(index),

      // TODO version 2 stuff
      // body: PageView(
      //   children: <Widget>[
      //     // Timeline(),
      //     RaisedButton(
      //       child: Text('Logout'),
      //       onPressed: logout,
      //     ),
      //     Search(),
      //     ProfilePage(currentUser: widget.theCurrentUser,),
      //   ],
      //   controller: pageController,
      //   onPageChanged: onPageChanged,
      //   physics: NeverScrollableScrollPhysics(),
      // ),
      //
      // bottomNavigationBar: CupertinoTabBar(
      //     currentIndex: pageIndex,
      //     onTap: onTap,
      //     activeColor: Theme.of(context).primaryColor,
      //     items: [
      //       BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
      //       BottomNavigationBarItem(icon: Icon(Icons.search)),
      //       BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
      //     ]),


      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
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
            // NavigationDestination(
            //   icon: Icon(Icons.group),
            //   selectedIcon: Icon(Icons.videocam),
            //   label: 'NFC',
            // ),
          ],
        ),
      ),
    );
  }
}
