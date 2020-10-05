import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/page/profilepage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilPage extends StatefulWidget {
  final user;
  const EditProfilPage({Key key, this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

enum UploadOption { camera, gallery }

class _EditProfilePageState extends State<EditProfilPage> {
  File _image;
  String _uploadedFileURL;

  final _formKey = new GlobalKey<FormState>();
  String _password;
  String _username;
  @override
  Widget build(BuildContext context) {
    setState(() {
      _username = widget.user.username;
    });
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        elevation: 0,
        title: new Text('Edit Profile'),
        iconTheme: new IconThemeData(color: Theme.of(context).buttonColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _uploadedFileURL != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(_uploadedFileURL),
                            radius: 50.0,
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(widget.user.photoUrl),
                            radius: 50.0,
                          ),
                    IconButton(
                      icon: Icon(Icons.photo_camera),
                      onPressed: _askedToLead,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: widget.user.username,
                        filled: true,
                        fillColor: Theme.of(context).focusColor,
                        contentPadding: const EdgeInsets.all(15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      onChanged: (input) => _username = input,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (input) {
                        if (input != '' && input.length < 6) {
                          return 'Longer password please';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        labelText: 'New Password',
                        filled: true,
                        fillColor: Theme.of(context).focusColor,
                        contentPadding: const EdgeInsets.all(15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      onChanged: (input) {
                        _password = input;
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      validator: (input) {
                        if (input != '' && _password != input) {
                          return 'Password not matching';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        labelText: 'Confirm Password',
                        filled: true,
                        fillColor: Theme.of(context).focusColor,
                        contentPadding: const EdgeInsets.all(15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ButtonTheme(
                      minWidth: 100.0,
                      height: 20.0,
                      child: RaisedButton(
                        color: Theme.of(context).buttonColor,
                        textColor: Colors.white,
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                        ),
                        padding: EdgeInsets.all(20.0),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            uploadFile();
                            Firestore.instance
                                .collection("users")
                                .document(widget.user.uid)
                                .updateData({
                              'username': _username,
                              'photoUrl': _uploadedFileURL,
                            });
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(),
                              ),
                            );
                          }
                        },
                        child: Text('EDIT'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future chooseFileFromGallery() async {
    ImagePicker img = new ImagePicker();
    var image = await img.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image.path);
    });
    uploadFile();
  }

  Future chooseFileFromCamera() async {
    ImagePicker img = new ImagePicker();
    var image = await img.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
    uploadFile();
  }

  Future uploadFile() async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('chats/${_image.path}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');

    storageReference.getDownloadURL().then((url) {
      setState(() {
        _uploadedFileURL = url;
      });
      print(_uploadedFileURL);
    });
  }

  Future<void> _askedToLead() async {
    switch (await showDialog<UploadOption>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            //title: const Text('Select assignment'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, UploadOption.camera);
                },
                child: const Text('Camera'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, UploadOption.gallery);
                },
                child: const Text('Gallery'),
              ),
            ],
          );
        })) {
      case UploadOption.camera:
        chooseFileFromCamera();
        break;
      case UploadOption.gallery:
        chooseFileFromGallery();
        break;
    }
  }
}
