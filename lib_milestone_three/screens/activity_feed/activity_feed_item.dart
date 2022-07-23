import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/home/home.dart';
import 'package:log_in/screens/profile/profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedItem extends StatefulWidget {
  final String username;
  final String userId;
  final String type; // 'like',
  final Timestamp timestamp;
  final String profileImagePath;

  ActivityFeedItem({
    required this.username,
    required this.userId,
    required this.type,
    required this.timestamp,
    required this.profileImagePath,
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userID'],
      type: doc['type'],
      timestamp: doc['timestamp'],
      profileImagePath: doc['imagePath'],
    );
  }

  @override
  State<ActivityFeedItem> createState() => _ActivityFeedItemState();
}

class _ActivityFeedItemState extends State<ActivityFeedItem> {
  // late Widget mediaPreview;
  late String activityItemText;
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    checkIfFollowing();
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    // TheUser activityFeedUser = retrieveUserInFirestore(userId);
    String followingStatus = isFollowing ? " (Following)" : "";

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: GestureDetector(
            onTap: () => showProfile(context, profileId: widget.userId),
            child: ListTile(
              title: RichText(
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text: widget.username + followingStatus,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' $activityItemText',
                      ),
                    ]
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: widget.profileImagePath == ""
                    ? Image.asset('assets/images/default_profile.webp').image
                    : CachedNetworkImageProvider(widget.profileImagePath),
              ),
              subtitle: Text(
                timeago.format(widget.timestamp.toDate()),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          // trailing: mediaPreview,
      ),
    );
  }

  configureMediaPreview(context) {
    if (widget.type == 'follow') {
      activityItemText = "is following you";
    }
  }

  showProfile(BuildContext context, {required String profileId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          profileUserID: profileId, appBar: buildSearchAppBar(context),
        ),
      ),
    );
  }

  checkIfFollowing() async {
    // check if the current user follows the profile user
    DocumentSnapshot doc = await followersRef
        .doc(widget.userId)
        .collection('userFollowers')
        .doc(homeCurrentUser.userID)
        .get();
    setState(() {
      isFollowing = doc.exists; // whether CURRENT user IS a follower of PROFILE USER
    });
  }
}

AppBar buildSearchAppBar(BuildContext context) {
  return AppBar(
    leading: BackButton(),
    title: Text("Profile"),
  );
}