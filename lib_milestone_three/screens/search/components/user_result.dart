import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../profile/profile_screen.dart';

class UserResult extends StatelessWidget {
  final TheUser user;
  UserResult(this.user);

  showProfile (BuildContext context, {required TheUser resultUser}) {
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
                user.username + "  |  " + user.acadInfo,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.tag1 + " | " + user.tag2 + " | " + user.tag3,
                // user.username,
                style: TextStyle(color: Colors.white),
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