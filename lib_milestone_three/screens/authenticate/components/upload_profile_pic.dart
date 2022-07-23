import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:log_in/shared/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class UploadProfilePicture extends StatefulWidget {
  final String profileUserID;

  UploadProfilePicture({required String this.profileUserID});

  @override
  _UploadProfilePictureState createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {
  File? image;
  String? mediaUrl;
  final ImagePicker _picker = ImagePicker();
  final Reference storageRef = FirebaseStorage.instance.ref();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool loading = false;

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Upload Image"),
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

  handleTakePhoto() async {
    Navigator.pop(context);
    XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      // maxHeight: 675,
      // maxWidth: 960,
    );
    setState(() {
      this.image = File(image!.path);
      SnackBar snackbar = SnackBar(content: Text("New Image Selected! Press Submit to Upload"));
      _scaffoldKey.currentState!.showSnackBar(snackbar);
    });
  }

  handleChooseFromGallery() async {
    Navigator.pop(context);
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.image = File(image!.path);
      SnackBar snackbar = SnackBar(content: Text("New Image Selected! Press Submit to Upload"));
      _scaffoldKey.currentState!.showSnackBar(snackbar);
    });
  }

  handleSubmit() async {
    loading = true;
    // setState(() {
    //   isUploading = true;
    // });
    if (image == null) {
      mediaUrl = "";
      print("asfadfadfadas");
    } else {
      print("111111");
      await compressImage(this.image);
      print("222222");
      mediaUrl = await uploadImage(this.image);
      print("333333");
    }
    Timer(Duration(seconds: 1), () {
      loading = false;
      Navigator.pop(context, mediaUrl);
    });
    // setState(() {});
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
    // final tempDir = await getTemporaryDirectory();
    // // final path = tempDir.path;
    // Im.Image imageFile = Im.decodeImage(await image.readAsBytes()) as Im.Image;
    // final compressedImageFile = File(widget.profileUserID)
    //   ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
    // setState(() {
    //   this.image = compressedImageFile;
    // });
  }

  Future<String> uploadImage(imageFile) async {
    // saves image to firebase storage
    UploadTask uploadTask = storageRef.child(widget.profileUserID).putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Upload Profile Image"),
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          // Center alignment
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Padding(
              padding: EdgeInsets.fromLTRB(10,10,10,10),
              child: GestureDetector(
                onTap: () async {
                  // print("WHO PRESSED ME");
                  await selectImage(context);
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  child: Text( "SELECT IMAGE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            Visibility(
              visible: this.image != null,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0,10,0,10),
                child: GestureDetector(
                  onTap: () {
                    // print("WHO PRESSED ME");
                    // if (this.image == null) { // if no profile pic uploaded
                    //   Timer(Duration(seconds: 2), () {
                    //     Navigator.pop(context, "");
                    //   });
                    // }
                    // else { // if profile pic uploaded
                    handleSubmit();
                    SnackBar snackbar = SnackBar(content: Text("Profile picture submitted!"));
                    _scaffoldKey.currentState!.showSnackBar(snackbar);
                    // if (this.image != null) {
                    //   // print("WHO PRESSED MEEEEEEEE");
                    //
                    // }
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Text( "SUBMIT IMAGE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),

            Visibility(
              visible: this.image == null,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0,10,0,10),
                child: GestureDetector(
                  onTap: () {
                    // print("WHO PRESSED ME");
                    // if (this.image == null) { // if no profile pic uploaded
                    //   Timer(Duration(seconds: 2), () {
                    //     Navigator.pop(context, "");
                    //   });
                    // }
                    // else { // if profile pic uploaded
                    handleSubmit();
                    SnackBar snackbar = SnackBar(content: Text("Proceeding without image!"));
                    _scaffoldKey.currentState!.showSnackBar(snackbar);
                    // if (this.image != null) {
                    //   // print("WHO PRESSED MEEEEEEEE");
                    //
                    // }
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    child: Text( "PROCEED WITHOUT IMAGE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() 
        : WillPopScope(
        onWillPop: () async => false,
        child: buildUploadForm()
    );
  }
}