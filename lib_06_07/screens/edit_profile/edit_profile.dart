import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user.dart';
import '../../services/auth.dart';
import '../../shared/progress.dart';
import '../authenticate/register.dart';
import '../initial_screen/initial_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

////////////////////////////////////////////////////////
/// Widget defines external parameters
////////////////////////////////////////////////////////
class EditProfile extends StatefulWidget {
  final String profileUserID;

  const EditProfile({required this.profileUserID});

  @override
  _EditProfileController createState() => _EditProfileController();
}

////////////////////////////////////////////////////////
/// Controller holds state, and all business logic
////////////////////////////////////////////////////////
class _EditProfileController extends State<EditProfile> {
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

  File? image;
  String? mediaUrl;
  final ImagePicker _picker = ImagePicker();
  final Reference storageRef = FirebaseStorage.instance.ref();

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

  handleTakePhoto() async {
    Navigator.pop(context);
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      // maxHeight: 675,
      // maxWidth: 960,
    );
    setState(() {
      this.image = File(image!.path);
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = File(image!.path);
    });
  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create Post"),
            children: <Widget>[
              SimpleDialogOption(
                  child: Text("Photo with Camera"),
                  onPressed: handleTakePhoto),
              SimpleDialogOption(
                  child: Text("Image from Gallery"),
                  onPressed: handleChooseFromGallery),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        }
    );
  }

  buildImageUploadForm() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0,10,0,10),
          child: GestureDetector(
            onTap: () async {
              print("TAPPED");
              await selectImage(context);
              print("IMAGE SELECTED");
              if (this.image != null) {
                await handleSubmit();
                print("SUBMITTED");
                setState(() {
                  usersRef.doc(widget.profileUserID).update({
                    "imagePath": mediaUrl,
                  });
                });
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(7.0),
              ),
              child: Text( "Edit Display Image",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  handleSubmit() async {
    // setState(() {
    //   isUploading = true;
    // });
    if (this.image != null) {
      print("111111");
      await compressImage(this.image);
      print("222222");
      mediaUrl = await uploadImage(this.image);
      print("333333");
      // update the image in the user profile
      // .then((value) {
      // getFollowers();
      // })
      setState(() {});
    }
  }

  compressImage(image) async {
    String userID = widget.profileUserID;
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(await image.readAsBytes()) as Im.Image;
    final compressedImageFile = File('$path/img_$userID.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    setState(() {
      this.image = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {
    // saves image to firebase storage
    UploadTask uploadTask = storageRef.child(widget.profileUserID).putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
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
    return _EditProfileView(this);
  }

  // ImageProvider getImage() {
  //   return user.imagePath == ""
  //     ? Image.asset('assets/images/default_profile.webp').image
  //     : CachedNetworkImageProvider(user.imagePath!);
  // }

}

////////////////////////////////////////////////////////
/// View is dumb, and purely declarative.
/// Easily references values on the controller and widget
////////////////////////////////////////////////////////
class _EditProfileView extends StatelessWidget {
  final _EditProfileController state;
  const _EditProfileView(this.state);

  Column buildEditDisplayPictureField() {
    return state.buildImageUploadForm();
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
          controller: state.displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: state._displaynameValid ? null : "Display name too short",
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
          controller: state.acadInfoController,
          decoration: InputDecoration(
            hintText: "Update Academic Info",
            errorText: state._acadInfoValid ? null : "Academic info too short",
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
          controller: state.bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
            errorText: state._bioValid ? null : "Bio is too long",
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
          controller: state.tag1Controller,
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
          controller: state.tag2Controller,
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
          controller: state.tag3Controller,
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
          controller: state.link1Controller,
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
          controller: state.link2Controller,
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
          controller: state.link3Controller,
          decoration: InputDecoration(
            hintText: "Update Link 3",
            // errorText: _displaynameValid ? null : "Display name too short",
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: state._scaffoldKey,
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
      body: state.isLoading
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
                    backgroundImage: state.user.imagePath == ""
                        ? Image.asset('assets/images/default_profile.webp').image
                        : CachedNetworkImageProvider(state.user.imagePath!),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     top: 8.0,
                //     bottom: 8.0,
                //   ),
                //   child: EditProfilePicture(profileUserID: widget.profileUserID),
                // ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      // edit display name and bio
                      buildEditDisplayPictureField(),
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
                  onPressed: state.updateProfileData,
                  child: Text(
                    "Update Profile Fields",
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
                    onPressed: state.logout,
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