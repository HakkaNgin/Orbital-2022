import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/chat/components/database.dart';
import 'package:log_in/screens/profile/components/follower_following_result.dart';
import 'package:log_in/screens/profile/components/follower_following_user.dart';
import 'package:log_in/screens/profile/components/show_followers.dart';
import 'package:log_in/screens/profile/components/show_following.dart';
import '../../models/user.dart';
import '../../shared/progress.dart';
import '../chat/components/chat.dart';
import '../edit_profile/edit_profile.dart';
import '../home/home.dart';
import 'package:url_launcher/url_launcher.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');
final activityFeedRef = FirebaseFirestore.instance.collection('Activity Feed');

// Widget defines external parameters
class ProfilePage extends StatefulWidget {
  final String profileUserID;
  final AppBar appBar;
  const ProfilePage({required this.profileUserID, required this.appBar});

  @override
  _ProfilePageController createState() => _ProfilePageController();
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////
class _ProfilePageController extends State<ProfilePage> {
  bool isFollowing = false;
  bool followsBack = false;
  int followerCount = 0;
  int followingCount = 0;
  final String currentUserID = homeCurrentUser.userID;
  var linkText = TextStyle(color: Colors.blue);
  Future<QuerySnapshot>? followersFuture;
  Future<QuerySnapshot>? followingFuture;

  @override
  void initState() {
    super.initState();
    getFollowers();
    getFollowing();
    checkIfFollowing();
    checkIfFollowsBack();
  }

  @override
  Widget build(BuildContext context) {
    followersRef
        .doc(widget.profileUserID)
        .set({
      "id" : widget.profileUserID,
    }); // set the id of the profile user in firestore database

    followingRef
        .doc(widget.profileUserID)
        .set({
      "id" : widget.profileUserID,
    });

    return _ProfilePageView(this);
  }

  checkIfFollowing() async {
    // check if the current user follows the profile user
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileUserID)
        .collection('userFollowers')
        .doc(currentUserID)
        .get();
    setState(() {
      isFollowing = doc.exists; // whether CURRENT user IS a follower of PROFILE USER
    });
  }

  checkIfFollowsBack() async {
    // check if the profile user follows back the current user
    DocumentSnapshot doc = await followingRef
        .doc(widget.profileUserID)
        .collection('userFollowing')
        .doc(currentUserID)
        .get();
    setState(() {
      followsBack = doc.exists; // whether PROFILE user IS a follower of CURRENT user
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

  Future<TheUser> retrieveUserInFirestore(String userID) async {
    // You know that the new user doesn't exist, so you can  create a new one
    // check if user exists in users collection in database according to their ID
    final DocumentSnapshot doc = await usersRef.doc(userID).get();
    return TheUser.fromDocument(doc);
    // get username from create account, use it to make new user document in users collection
  }

  handleSearch(String hint) {

    if (hint == "followers") {
      Future<QuerySnapshot> followers = followersRef
          .doc(widget.profileUserID)
          .collection('userFollowers')
          .get(); // find all the followers of the profile user

      setState(() {
        followersFuture = followers;
      });

    } else if (hint == "following") {
      Future<QuerySnapshot> following = followingRef
          .doc(widget.profileUserID)
          .collection('userFollowing')
          .get(); // find the profile user

      setState(() {
        followingFuture = following;
      });
    }
  }

  bool dataEmpty(AsyncSnapshot<QuerySnapshot> snapshot) {
    bool dataEmpty = true;

    if(snapshot.data?.docs != null) {
      dataEmpty = false;
    }
    return dataEmpty;
  }

  convertSnapShotToUsers(Future<QuerySnapshot>? inputFuture) async {
    List<FollowerFollowingResult> listOfUsers = [];
    return FutureBuilder(
      future: inputFuture,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(!snapshot.hasData || dataEmpty(snapshot)) {
          return circularProgress();
        }
        print(snapshot.data?.docs.length);
        print(snapshot.data?.docs.toString());
        // snapshot is the profile user
        snapshot.data?.docs.forEach((userDoc) {
          FollowerFollowingUser user = FollowerFollowingUser.fromDocument(userDoc);
          FollowerFollowingResult outputUser = FollowerFollowingResult(user);
          listOfUsers.add(outputUser);
        });
        return ListView( // convert list of userID to widget
          children: listOfUsers,
        );
      },
    );
  }

  editProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfile(profileUserID: widget.profileUserID),
      ),
    ).then((value) => setState(() {}));
  }

  handleFollowUser() async {

    TheUser currentUser = await retrieveUserInFirestore(currentUserID);
    TheUser profileUser = await retrieveUserInFirestore(widget.profileUserID);

    setState(() {
      isFollowing = true;
    });
    // Make current user follow ANOTHER user and update THEIR followers collection
    followersRef
        .doc(widget.profileUserID) // ID of the OTHER user
        .collection('userFollowers')
        .doc(currentUserID) // YOUR OWN ID
        .set({
      "id" : currentUser.userID,
      "username" : currentUser.username,
      "imagePath" : currentUser.imagePath,
    }).then((value) {
      getFollowers();
    });
    // Put THAT user o  `n YOUR following collection (update your following collection)
    followingRef
        .doc(currentUserID) // ID of YOURSELF
        .collection("userFollowing")
        .doc(widget.profileUserID)
        .set({
      "id" : profileUser.userID,
      "username" : profileUser.username,
      "imagePath" : profileUser.imagePath,
    });// ID of the OTHER user

    // add activity feed item for that user to notify about new follower (us)
    // ASYNC PART
    activityFeedRef
        .doc(widget.profileUserID)
        .collection('feedItems')
        .doc(currentUserID)
        .set({
      "type": "follow",
      "ownerID": widget.profileUserID, // id of the user receiving notification
      "username": currentUser.username,
      "userID": currentUserID, // id of us (i.e. person following)
      "imagePath": currentUser.imagePath,
      "timestamp": DateTime.now(), // TIMESTAMP
    });
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
    }).then((value) {
      getFollowers();
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
    // delete activity feed item for them
    activityFeedRef
        .doc(widget.profileUserID)
        .collection('feedItems')
        .doc(currentUserID)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  sendMessage() async {
    TheUser profileUser = await retrieveUserInFirestore(widget.profileUserID);
    String chatRoomId1 = homeCurrentUser.userID + "_" + widget.profileUserID;
    String chatRoomId2 = widget.profileUserID + "_" + homeCurrentUser.userID;
    bool chatRoomOneExists = await DatabaseMethods().chatExists(chatRoomId1);
    bool chatRoomTwoExists = await DatabaseMethods().chatExists(chatRoomId2);

    if (chatRoomOneExists) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Chat(chatRoomId: chatRoomId1),
        ),
      ).then((value) => setState(() {}));

    } else if (chatRoomTwoExists) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Chat(chatRoomId: chatRoomId2),
        ),
      ).then((value) => setState(() {}));

    } else {
      await DatabaseMethods().addChatRoom(widget.profileUserID, profileUser.username, profileUser.imagePath);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Chat(chatRoomId: chatRoomId1),
        ),
      ).then((value) => setState(() {}));
    }
  }
}

// View is dumb, and purely declarative.
// Easily references values on the controller and widget
class _ProfilePageView extends StatelessWidget {
  final _ProfilePageController state;
  const _ProfilePageView(this.state);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: state.widget.appBar,
      body: ListView(
        children: <Widget>[buildProfileHeader()],
      ),
    );
  }

  buildProfileHeader() {
    bool isProfileOwner = state.currentUserID == state.widget.profileUserID;
    // print(!isProfileOwner && state.isFollowing && true);
    return FutureBuilder(
      future: usersRef.doc(state.widget.profileUserID).get(),
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
                    radius: 52.0,
                    backgroundColor: Colors.grey,
                    // TODO: Need to specify image URL
                    backgroundImage: user.imagePath == ""
                        ? Image.asset('assets/images/default_profile.webp').image
                        : CachedNetworkImageProvider(user.imagePath),
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
                            buildCountColumn("followers", state.followerCount),
                            buildCountColumn("following", state.followingCount),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            buildProfileButton(),
                          ],
                        ),
                        Visibility(
                          visible: (!isProfileOwner && state.isFollowing && state.followsBack),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildChatButton(),
                            ],
                          ),
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
                  user.username + " (" + user.email + ")",
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
                              style: state.linkText,
                              text: user.link1,
                              recognizer: TapGestureRecognizer()..onTap = () async {
                                var url = Uri.parse(user.link1);
                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url);
                                } else {
                                  throw "Cannot load URL";
                                  print("SASDSADASDFADA");
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
                              style: state.linkText,
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
                              style: state.linkText,
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

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = state.currentUserID == state.widget.profileUserID;
    print(state.currentUserID);
    print(state.widget.profileUserID);
    if (isProfileOwner) {
      return buildButton (
        text: "Edit Profile",
        function: state.editProfile,
      );
    } else if (state.isFollowing){
      return buildButton (
        text: "Unfollow",
        function: state.handleUnfollowUser,
      );
    } else if (!state.isFollowing) {
      return buildButton (
        text: "Follow",
        function: state.handleFollowUser,
      );
    }
  }

  buildChatButton() {
    return RawMaterialButton(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
      constraints: BoxConstraints(),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: state.sendMessage,
      child: Container(
        width: 200.0,
        height: 27.0,
        child: Text(
          "Message",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.grey
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  buildButton({required String text, required VoidCallback function}) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      onPressed: function,
      child: Container(
        width: 200.0,
        height: 27.0,
        child: Text(
          text,
          style: TextStyle(
            color: state.isFollowing ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: state.isFollowing ? Colors.white : Colors.blue,
          border: Border.all(
              color: state.isFollowing ? Colors.grey : Colors.blue
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }

  Column buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlatButton(
          onPressed: () async {
            await state.handleSearch(label);
            if (label == "followers") {
              Widget followers = await state.convertSnapShotToUsers(state.followersFuture);
              Navigator.push(state.context, MaterialPageRoute(
                  builder: (context) => ShowFollowers(followers: followers)));
            } else if (label == "following") {
              Widget following = await state.convertSnapShotToUsers(state.followingFuture);
              Navigator.push(state.context, MaterialPageRoute(
                  builder: (context) => ShowFollowing(following: following)));
            }
          },
          child: Text(
            count.toString(),
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
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
}