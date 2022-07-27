import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:log_in/screens/profile/components/follower_following_user.dart';
import 'package:log_in/screens/profile/profile_screen.dart';

class FollowerFollowingResult extends StatelessWidget {
  final FollowerFollowingUser user;
  FollowerFollowingResult(this.user);

  showProfile (BuildContext context, {required FollowerFollowingUser resultUser}) {
    Navigator.push(context,
        MaterialPageRoute(builder:
            (context) => ProfilePage(profileUserID: resultUser.userID, appBar: buildSearchAppBar(context))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              showProfile(context, resultUser: user);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                // Need null check for this one
                backgroundImage: user.imagePath == ""
                    ? Image.asset('assets/images/default_profile.webp').image
                    : CachedNetworkImageProvider(user.imagePath),
              ),
              title: Text(
                user.username,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }

  AppBar buildSearchAppBar(BuildContext context) {

    return AppBar(
      leading: BackButton(),
      title: Text("Profile"),
    );
  }
}