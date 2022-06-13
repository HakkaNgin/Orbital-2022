import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/home/home.dart';
import 'package:log_in/shared/progress.dart';

import 'package:log_in/screens/widgets/button_widget.dart';
import 'package:log_in/screens/page/edit_profile_page.dart';
import 'package:log_in/screens/widgets/numbers_widget.dart';
import 'package:log_in/screens/widgets/profile_widget.dart';
import 'package:log_in/services/user_preferences.dart';
import '../widgets/appbar_widget.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class ProfilePage extends StatefulWidget {
  // String profileId;
  final TheUser currentUser;

  ProfilePage({required this.currentUser});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final String currentUserID = homeCurrentUser.userID;

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  editProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditProfile(currentUser: widget.currentUser),
      ),
    ).then((value) => setState(() {}));
  }

  buildButton({required String text, required VoidCallback function}) {
    return Container(
      padding: EdgeInsets.only(top: 2.0),
      child: FlatButton(
        onPressed: function,
        child: Container(
          width: 250.0,
          height: 27.0,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.blue
            ),
              borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = currentUserID == widget.currentUser.userID;
    if (isProfileOwner) {
      return buildButton (
        text: "Edit Profile",
        function: editProfile,
      );
    }
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.doc(widget.currentUser.userID).get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        // type casting
        DocumentSnapshot dataFromSnapShot = snapshot.data as DocumentSnapshot;
        TheUser user = TheUser.fromDocument(dataFromSnapShot);
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.grey,
                    // TODO: Need to specify image URL
                    // backgroundImage: CachedNetworkImageProvider(user.imagePath),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildCountColumn("posts", 0),
                            buildCountColumn("followers", 0),
                            buildCountColumn("following", 0),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildProfileButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  user.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  user.username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 2.0),
                child: Text(
                  user.bio,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Profile"),
      ),
      body: ListView(
        children: <Widget>[buildProfileHeader()],
      ),
    );
  }
}

// class _ProfilePageState extends State<ProfilePage> {
//
//   @override
//   Widget build(BuildContext context) {
//     final user = UserPreferences.getUser();
//
//     return Scaffold(
//       appBar: buildAppBar(context),
//       body: ListView(
//         physics: BouncingScrollPhysics(),
//         children: [
//           ProfileWidget(
//             imagePath: user.imagePath,
//             onClicked: () async {
//               await Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) => EditProfilePage()),
//               );
//               setState(() {});
//             },
//           ),
//           const SizedBox(height: 24),
//           buildName(user),
//           const SizedBox(height: 24),
//           Center(child: buildUpgradeButton()),
//           const SizedBox(height: 24),
//           NumbersWidget(),
//           const SizedBox(height: 48),
//           buildAbout(user),
//         ],
//       ),
//     );
//   }
//
//   Widget buildName(TheUser user) => Column(
//     children: [
//       Text(
//         user.name,
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//       ),
//       const SizedBox(height: 4),
//       Text(
//         user.email,
//         style: TextStyle(color: Colors.grey),
//       )
//     ],
//   );
//
//   Widget buildUpgradeButton() => ButtonWidget(
//     text: 'Upgrade To PRO',
//     onClicked: () {},
//   );
//
//   Widget buildAbout(TheUser user) => Container(
//     padding: EdgeInsets.symmetric(horizontal: 48),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'About',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         Text(
//           user.about,
//           style: TextStyle(fontSize: 16, height: 1.4),
//         ),
//       ],
//     ),
//   );
// }