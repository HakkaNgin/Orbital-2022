import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:log_in/models/user.dart';
import 'package:log_in/screens/authenticate/InitialPage.dart';
import 'package:log_in/screens/page/profile_page.dart';
import 'package:log_in/screens/widgets/appbar_widget.dart';
import 'package:log_in/screens/widgets/button_widget.dart';
import 'package:log_in/screens/widgets/profile_widget.dart';
import 'package:log_in/screens/widgets/textfield_widget.dart';
import 'package:log_in/services/auth.dart';
import 'package:log_in/services/user_preferences.dart';
import 'package:log_in/shared/progress.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfile extends StatefulWidget {
  final TheUser currentUser;

  EditProfile({required this.currentUser});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  late TheUser user;
  bool _displaynameValid = true;
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
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    DocumentSnapshot doc = await usersRef.doc(widget.currentUser.userID).get();
    user = TheUser.fromDocument(doc);
    displayNameController.text = user.username;
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
      displayNameController.text.trim().length < 3 ||
      displayNameController.text.isEmpty ? _displaynameValid = false :
          _displaynameValid = true;

      bioController.text.trim().length > 100 ? _bioValid = false : _bioValid= true;
    });

    if (_displaynameValid && _bioValid) {
      usersRef.doc(widget.currentUser.userID).update({
        "username": displayNameController.text,
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
              // Navigator.push(context,
              //     MaterialPageRoute(builder:
              //         (context) => ProfilePage(currentUser: widget.currentUser))
              // );
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

// class EditProfilePage extends StatefulWidget {
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   late TheUser user;
//
//   @override
//   void initState() {
//     super.initState();
//
//     user = UserPreferences.getUser();
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: buildAppBar(context),
//     body: ListView(
//       padding: EdgeInsets.symmetric(horizontal: 32),
//       physics: BouncingScrollPhysics(),
//       children: [
//         ProfileWidget(
//           imagePath: user.imagePath,
//           isEdit: true,
//           onClicked: () async {
//             final image = await ImagePicker()
//                 .getImage(source: ImageSource.gallery);
//
//             if (image == null) return;
//
//             final directory = await getApplicationDocumentsDirectory();
//             final name = basename(image.path);
//             final imageFile = File('${directory.path}/$name');
//             // copy chosen image to imageFile
//             final newImage = await File(image.path).copy(imageFile.path);
//
//             setState(() => user = user.copy(imagePath: newImage.path));
//           },
//         ),
//         const SizedBox(height: 24),
//         TextFieldWidget(
//           label: 'Full Name',
//           text: user.name,
//           onChanged: (name) => user = user.copy(name: name),
//         ),
//         const SizedBox(height: 24),
//         TextFieldWidget(
//           label: 'Email',
//           text: user.email,
//           onChanged: (email) => user = user.copy(email: email),
//         ),
//         const SizedBox(height: 24),
//         TextFieldWidget(
//           label: 'About',
//           text: user.about,
//           maxLines: 5,
//           onChanged: (about) => user = user.copy(about: about),
//         ),
//         ButtonWidget(
//           text: 'Save',
//           onClicked: () {
//             UserPreferences.setUser(user);
//             Navigator.of(context).pop(); // returns to previous page
//           },
//         ),
//       ],
//     ),
//   );
// }