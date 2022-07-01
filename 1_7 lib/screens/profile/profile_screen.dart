import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../shared/progress.dart';
import '../edit_profile/edit_profile.dart';
import '../home/home.dart';
import 'package:url_launcher/url_launcher.dart';


final usersRef = FirebaseFirestore.instance.collection('users');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');

class ProfilePage extends StatefulWidget {
  final String profileUserID;
  final AppBar appBar;
  ProfilePage({required this.profileUserID, required this.appBar});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;
  final String currentUserID = homeCurrentUserID;
  var linkText = TextStyle(color: Colors.blue);

  @override
  void initState() {
    super.initState();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: ListView(
        children: <Widget>[buildProfileHeader()],
      ),
    );
  }

  checkIfFollowing() async {
    // check if the current user is under the followers of the profile user
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileUserID)
        .collection('userFollowers')
        .doc(currentUserID)
        .get();
    setState(() {
      isFollowing = doc.exists; // whether CURRENT user IS a follower of PROFILE USER
    });
  }

  getFollowers() async { // get followers of profile user
    QuerySnapshot snapshot = await followersRef
        .doc(widget.profileUserID)
        .collection('userFollowers')
        .get();
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async { // get the users which profile user is following
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileUserID)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

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
          builder: (context) => EditProfile(profileUserID: widget.profileUserID),
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
              color: isFollowing ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing ? Colors.white : Colors.blue,
            border: Border.all(
              color: isFollowing ? Colors.grey : Colors.blue
            ),
              borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = currentUserID == widget.profileUserID;
    if (isProfileOwner) {
      return buildButton (
        text: "Edit Profile",
        function: editProfile,
      );
    } else if (isFollowing){
      return buildButton (
        text: "Unfollow",
        function: handleUnfollowUser,
      );
    } else if (!isFollowing) {
      return buildButton (
        text: "Follow",
        function: handleFollowUser,
      );
    }
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });
    // Make current user follow ANOTHER user and update THEIR followers collection
    followersRef
        .doc(widget.profileUserID) // ID of the OTHER user
        .collection('userFollowers')
        .doc(currentUserID) // YOUR OWN ID
        .set({});
    // Put THAT user o  `n YOUR following collection (update your following collection)
    followingRef
        .doc(currentUserID) // ID of YOURSELF
        .collection("userFollowing")
        .doc(widget.profileUserID)
        .set({});// ID of the OTHER user
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });
    // REMOVE current user from ANOTHER user's followers
    followersRef
        .doc(widget.profileUserID) // ID of the OTHER user
        .collection('userFollowers')
        .doc(currentUserID) // YOUR OWN ID
        .get().then((doc) => {
          if (doc.exists) {
            doc.reference.delete()
          }
        });
    // REMOVE THAT user from YOUR following collection
    followingRef
        .doc(currentUserID) // ID of YOURSELF
        .collection("userFollowing")
        .doc(widget.profileUserID) // ID of the OTHER user
        .get().then((doc) => {
          if (doc.exists) {
            doc.reference.delete()
          }
        });
  }

  buildProfileHeader() {
    return FutureBuilder(
      future: usersRef.doc(widget.profileUserID).get(),
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
                            // buildCountColumn("posts", 0),
                            buildCountColumn("followers", followerCount),
                            buildCountColumn("following", followingCount),
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
                    fontSize: 20.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 6.0),
                child: Text(
                  user.acadInfo,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 6.0),
                child: Text(
                  user.tag1 + " | " + user.tag2 + " | " + user.tag3,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Visibility(
                visible: user.link1 == "" ? false : true,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 6.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          style: linkText,
                          text: user.link1,
                          recognizer: TapGestureRecognizer()..onTap = () async {
                            var url = Uri.parse(user.link1);
                            if (await canLaunchUrl(url)) {
                              await launchUrl(url);
                            } else {
                              throw "Cannot load URL";
                            }
                          }
                        ),
                      ]
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: user.link2 == "" ? false : true,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 6.0),
                  child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              style: linkText,
                              text: user.link2,
                              recognizer: TapGestureRecognizer()..onTap = () async {
                                var url = Uri.parse(user.link2);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw "Cannot load URL";
                                }
                              }
                          ),
                        ]
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: user.link3 == "" ? false : true,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 6.0),
                  child: RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                              style: linkText,
                              text: user.link3,
                              recognizer: TapGestureRecognizer()..onTap = () async {
                                var url = Uri.parse(user.link3);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw "Cannot load URL";
                                }
                              }
                          ),
                        ]
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  user.bio,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}