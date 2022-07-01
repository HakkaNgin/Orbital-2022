import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../shared/progress.dart';
import '../authenticate/register.dart';
import '../initial_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditProfile extends StatefulWidget {
  final String profileUserID;

  EditProfile({required this.profileUserID});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController acadInfoController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  late TheUser user;
  bool _displaynameValid = true;
  bool _acadInfoValid = true;
  bool _bioValid = true;

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.profileUserID).get();
    user = TheUser.fromDocument(doc);
    displayNameController.text = user.username;
    acadInfoController.text = user.acadInfo;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Display Name",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _displaynameValid ? null : "Display name too short",
          ),
        )
      ],
    );
  }

  Column buildAcadInfoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Academic Info",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: acadInfoController,
          decoration: InputDecoration(
            hintText: "Update Academic Info",
            errorText: _acadInfoValid ? null : "Academic info too short",
          ),
        )
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Bio",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
            errorText: _bioValid ? null : "Bio is too long",
          ),
        )
      ],
    );
  }

  updateProfileData() {
    setState(() {
      (displayNameController.text.trim().length < 3
          || displayNameController.text.trim().length > 30
          || displayNameController.text.isEmpty) ? _displaynameValid = false
          : _displaynameValid = true;

      acadInfoController.text.trim().length < 2 ? _acadInfoValid = false : _acadInfoValid = true;

      bioController.text.trim().length > 100 ? _bioValid = false : _bioValid = true;
    });

    if (_displaynameValid && _acadInfoValid && _bioValid) {
      usersRef.doc(widget.profileUserID).update({
        "username": displayNameController.text,
        "username_lowercase": displayNameController.text.toLowerCase(),
        "acad_info": acadInfoController.text,
        "bio": bioController.text,
      });
      SnackBar snackbar = SnackBar(content: Text("Profile updated!"));
      _scaffoldKey.currentState!.showSnackBar(snackbar);
    }
  }

  logout() async {
    await _auth.authSignOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => InitialPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            // return to profile page
            onPressed: () {
              Navigator.pop(context, true);
            },
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 16.0,
                    bottom: 8.0,
                  ),
                  child: CircleAvatar(
                    radius: 50.0,
                    // backgroundImage:
                    // CachedNetworkImageProvider(user.imagePath!),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      // edit display name and bio
                      buildDisplayNameField(),
                      buildAcadInfoField(),
                      buildBioField(),
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: updateProfileData,
                  child: Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: FlatButton.icon(
                    onPressed: logout,
                    icon: Icon(Icons.cancel, color: Colors.red),
                    label: Text(
                      "Logout",
                      style: TextStyle(color: Colors.red, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}