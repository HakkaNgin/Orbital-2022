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
  TextEditingController tag1Controller = TextEditingController();
  TextEditingController tag2Controller = TextEditingController();
  TextEditingController tag3Controller = TextEditingController();
  TextEditingController link1Controller = TextEditingController();
  TextEditingController link2Controller = TextEditingController();
  TextEditingController link3Controller = TextEditingController();

  bool isLoading = false;
  late TheUser user;
  bool _displaynameValid = true;
  bool _acadInfoValid = true;
  bool _bioValid = true;
  // bool _tag1Valid = true;
  // bool _tag2Valid = true;
  // bool _tag3Valid = true;
  // bool _link1Valid = true;
  // bool _link2Valid = true;
  // bool _link3Valid = true;

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
    tag1Controller.text = user.tag1;
    tag2Controller.text = user.tag2;
    tag3Controller.text = user.tag3;
    link1Controller.text = user.link1;
    link2Controller.text = user.link2;
    link3Controller.text = user.link3;
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

  Column buildTagOneNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Tag1",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: tag1Controller,
          decoration: InputDecoration(
            hintText: "Update Tag 1",
            // errorText: _displaynameValid ? null : "Display name too short",
          ),
        )
      ],
    );
  }

  Column buildTagTwoNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Tag 2",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: tag2Controller,
          decoration: InputDecoration(
            hintText: "Update Tag 2",
            // errorText: _displaynameValid ? null : "Display name too short",
          ),
        )
      ],
    );
  }

  Column buildTagThreeNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Tag 3",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: tag3Controller,
          decoration: InputDecoration(
            hintText: "Update Tag 3",
            // errorText: _displaynameValid ? null : "Display name too short",
          ),
        )
      ],
    );
  }

  Column buildLinkOneNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Link 1",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: link1Controller,
          decoration: InputDecoration(
            hintText: "Update Link 1",
            // errorText: _displaynameValid ? null : "Display name too short",
          ),
        )
      ],
    );
  }

  Column buildLinkTwoNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Link 2",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: link2Controller,
          decoration: InputDecoration(
            hintText: "Update Link 2",
            // errorText: _displaynameValid ? null : "Display name too short",
          ),
        )
      ],
    );
  }

  Column buildLinkThreeNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Text(
              "Link 3",
              style: TextStyle(color: Colors.grey),
            )),
        TextField(
          controller: link3Controller,
          decoration: InputDecoration(
            hintText: "Update Link 3",
            // errorText: _displaynameValid ? null : "Display name too short",
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
        "tag1": tag1Controller.text == null ? "" : tag1Controller.text,
        "tag1_lowercase": tag1Controller.text == null ? "" : tag1Controller.text.toLowerCase(),
        "tag2": tag2Controller.text == null ? "" : tag2Controller.text,
        "tag2_lowercase": tag2Controller.text == null ? "" : tag2Controller.text.toLowerCase(),
        "tag3": tag3Controller.text == null ? "" : tag3Controller.text,
        "tag3_lowercase": tag3Controller.text == null ? "" : tag3Controller.text.toLowerCase(),
        "link1": link1Controller.text == null ? "" : link1Controller.text,
        "link2": link2Controller.text == null ? "" : link2Controller.text,
        "link3": link3Controller.text == null ? "" : link3Controller.text,
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
                      buildTagOneNameField(),
                      buildTagTwoNameField(),
                      buildTagThreeNameField(),
                      buildLinkOneNameField(),
                      buildLinkTwoNameField(),
                      buildLinkThreeNameField(),
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