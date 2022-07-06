import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;

class UploadProfilePicture extends StatefulWidget {
  final String profileUserID;

  UploadProfilePicture({required String this.profileUserID});

  @override
  _UploadProfilePictureState createState() => _UploadProfilePictureState();
}

class _UploadProfilePictureState extends State<UploadProfilePicture> {
  late File image;
  late String mediaUrl;
  final ImagePicker _picker = ImagePicker();
  final Reference storageRef = FirebaseStorage.instance.ref();

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

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Upload Profile Image"),
      ),
      body: Column(
        // Center alignment
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          Padding(
            padding: EdgeInsets.fromLTRB(0,10,0,10),
            child: GestureDetector(
              onTap: () {
                // print("WHO PRESSED ME");
                selectImage(context);
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

          Padding(
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
              if (this.image != null) {
                  // print("WHO PRESSED MEEEEEEEE");
                  handleSubmit();
                }
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(7.0),
                ),
                child: Text( "SUBMIT",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
      ],
    ));
  }

  handleSubmit() async {
    // setState(() {
    //   isUploading = true;
    // });
    print("111111");
    await compressImage(this.image);
    print("222222");
    mediaUrl = await uploadImage(this.image);
    print("333333");
    Timer(Duration(seconds: 1), () {
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

  @override
  Widget build(BuildContext context) {
    return buildUploadForm();
  }
}