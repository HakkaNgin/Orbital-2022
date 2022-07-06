import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/profile/profile_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // 'like',
  final Timestamp timestamp;
  final String profileImagePath;

  // late Widget mediaPreview;
  late String activityItemText;

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

  configureMediaPreview(context) {
    if (type == 'follow') {
      activityItemText = "is following you";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);
    // TheUser activityFeedUser = retrieveUserInFirestore(userId);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => showProfile(context, profileId: userId),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' $activityItemText',
                    ),
                  ]),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage: profileImagePath == ""
                ? Image.asset('assets/images/default_profile.webp').image
                : CachedNetworkImageProvider(profileImagePath),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          // trailing: mediaPreview,
        ),
      ),
    );
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
}

AppBar buildSearchAppBar(BuildContext context) {
  return AppBar(
    leading: BackButton(),
    title: Text("Profile"),
  );
}