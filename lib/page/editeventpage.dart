import 'dart:io';
import 'package:event/page/usereventpage.dart';
import 'package:event/service/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:event/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditEventPage extends StatefulWidget {
  final event;
  const EditEventPage({Key key, this.event}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

enum UploadOption { camera, gallery }

class _EditEventPageState extends State<EditEventPage> {
  String _name;
  String _type;
  String _location;
  String _date;
  String _time;
  List<String> _inviteList;
  String _photoUrl;
  bool _isPublic;
  final _formKey = new GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime24Hour = TimeOfDay.now();
  int group;
  List<String> inviteList = [];
  File _image;
  String _uploadedFileURL;

  @override
  void initState() {
    _name = widget.event.name;
    _type = widget.event.type;
    _location = widget.event.location;
    _date = widget.event.date;
    _time = widget.event.time;
    _photoUrl = widget.event.photoUrl;
    _isPublic = widget.event.isPublic;
    _inviteList = widget.event.inviteList;

    if (_isPublic == true) {
      group = 1;
    } else {
      group = 2;
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double height;
    if (MediaQuery.of(context).size.width > 600) {
      height = 300;
    } else {
      height = 200;
    }
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        elevation: 0,
        title: new Text(_name),
        iconTheme:
            new IconThemeData(color: Theme.of(context).textSelectionColor),
      ),
      body: new SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: height,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: NetworkImage(_photoUrl),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned(
                    bottom: -20,
                    right: 0,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: IconButton(
                      alignment: Alignment.centerLeft,
                      icon: Icon(Icons.photo_camera),
                      onPressed: _askedToLead,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: _name,
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
                      onChanged: (input) => _name = input,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: _type,
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
                      onChanged: (input) => _type = input,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 110,
                          padding: EdgeInsets.all(15),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                              width: 1,
                              color: Colors.transparent,
                            ),
                            color: Theme.of(context).focusColor,
                          ),
                          child: Text(
                            _location,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        IconButton(
                          icon: Icon(Icons.map),
                          onPressed: () async {
                            var location = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapPage(),
                              ),
                            );
                            print(location);
                            if (location != null) {
                              setState(() {
                                _location = location;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 160,
                          padding: EdgeInsets.all(15),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            border: Border.all(
                              width: 1,
                              color: Colors.transparent,
                            ),
                            color: Theme.of(context).focusColor,
                          ),
                          child: Text(
                            _date,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        ButtonTheme(
                          minWidth: 50.0,
                          height: 20.0,
                          child: RaisedButton(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            onPressed: () => _selectDate(context),
                            child: Text(
                              'Select Date',
                            ),
                            color: Theme.of(context).buttonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width - 160,
                          padding: EdgeInsets.all(15),
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Theme.of(context).focusColor,
                          ),
                          child: Text(
                            _time,
                            style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).textSelectionHandleColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        ButtonTheme(
                          minWidth: 50.0,
                          height: 20.0,
                          child: RaisedButton(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            onPressed: () => _selectTime(context),
                            child: Text(
                              'Select Time',
                            ),
                            color: Theme.of(context).buttonColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 20, 0),
                    child: Row(
                      children: [
                        Text('Public:'),
                        Radio(
                          value: 1,
                          activeColor: Theme.of(context).buttonColor,
                          groupValue: group,
                          onChanged: (value) {
                            setState(() {
                              group = value;
                              _isPublic = true;
                            });
                          },
                        ),
                        Text('Private:'),
                        Radio(
                          value: 2,
                          activeColor: Theme.of(context).buttonColor,
                          groupValue: group,
                          onChanged: (value) {
                            setState(() {
                              group = value;
                              _isPublic = false;
                            });
                          },
                        ),
                        group == 2
                            ? IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () async {
                                  inviteList = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InvitePage(
                                        uid: user.uid,
                                        inviteList: _inviteList,
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    _inviteList = inviteList;
                                  });
                                },
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ButtonTheme(
                        minWidth: 50.0,
                        height: 20.0,
                        child: RaisedButton(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          onPressed: () async {
                            Firestore.instance
                                .collection("events")
                                .document(widget.event.eventid)
                                .updateData({
                              'name': _name,
                              'type': _type,
                              'location': _location,
                              'date': _date,
                              'time': _time,
                              'photoUrl': _photoUrl,
                              'isPublic': _isPublic,
                              'inviteList': _inviteList,
                            });
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserEventPage(),
                              ),
                            );
                          },
                          child: Text('Edit Event'),
                          color: Theme.of(context).buttonColor,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      ButtonTheme(
                        minWidth: 50.0,
                        height: 20.0,
                        child: RaisedButton(
                          textColor: Colors.white,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.all(20.0),
                          onPressed: () {
                            Firestore.instance
                                .collection("events")
                                .document(widget.event.eventid)
                                .delete();
                            Firestore.instance
                                .collection('users')
                                .document(widget.event.createdBy)
                                .updateData({
                              'eventsOfUser': FieldValue.arrayRemove(
                                  [widget.event.eventid]),
                            });
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserEventPage(),
                              ),
                            );
                          },
                          child: Text('Delete Event'),
                          color: Theme.of(context).buttonColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Theme.of(context).buttonColor,
              secondary: Theme.of(context).buttonColor,
            ),
          ),
          child: child,
        );
      },
    );

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _date = "${selectedDate}".split(' ')[0];
      });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
    );

    if (picked != null && picked != selectedTime24Hour)
      setState(() {
        selectedTime24Hour = picked;
        _time = selectedTime24Hour.format(context);
      });
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
        _photoUrl = _uploadedFileURL;
      });
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

class InvitePage extends StatefulWidget {
  final uid;
  final inviteList;
  const InvitePage({Key key, this.uid, this.inviteList}) : super(key: key);

  @override
  _InvitePageState createState() => _InvitePageState();
}

class _InvitePageState extends State<InvitePage> {
  @override
  List isSelected = [];
  List<String> inviteList = [];
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Theme.of(context).buttonColor),
      ),
      body: FutureBuilder<List>(
        future: DatabaseService().getFollowingList(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // return: show loading widget
          }
          if (snapshot.hasError) {
            // return: show error widget
          }
          List users = snapshot.data ?? [];
          inviteList = new List<String>.from(widget.inviteList);

          if (isSelected.length == 0) {
            for (int i = 0; i < users.length; i++) {
              if (inviteList.contains(users[i].uid)) {
                isSelected.add(true);
              } else {
                isSelected.add(false);
              }
            }
          }

          return Column(
            children: [
              users.length != 0
                  ? SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          for (int i = 0; i < users.length; i++)
                            Card(
                              color: Theme.of(context).focusColor,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(users[i].photoUrl),
                                  radius: 20.0,
                                ),
                                selected: isSelected[i],
                                title: Text(users[i].username),
                                onTap: () {
                                  if (isSelected[i] == true) {
                                    setState(() {
                                      isSelected[i] = false;
                                    });
                                  } else {
                                    setState(() {
                                      isSelected[i] = true;
                                    });
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    )
                  : Container(),
              ButtonTheme(
                minWidth: 250.0,
                height: 20.0,
                child: RaisedButton(
                  color: Theme.of(context).buttonColor,
                  textColor: Colors.white,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  onPressed: () {
                    for (int i = 0; i < isSelected.length; i++) {
                      if (isSelected[i] == true &&
                          inviteList.contains(users[i].uid) == false) {
                        inviteList.add(users[i].uid);
                      } else if (isSelected[i] == false) {
                        inviteList.remove(users[i].uid);
                      }
                    }
                    Navigator.pop(context, inviteList);
                  },
                  child: Text('INVITE'),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          );
        },
      ),
    );
  }
}

class MapPage extends StatefulWidget {
  final location;
  const MapPage({Key key, this.location}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  Position position;
  String searchAddr;
  String _selectedAddress;
  List<Marker> myMarker = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            padding: EdgeInsets.only(top: 20.0),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: onMapCreated,
            initialCameraPosition:
                CameraPosition(target: LatLng(45.48, 9.21), zoom: 14),
            onTap: (value) {
              _handleTap(value);
              _getAddressFromLatLng(myMarker[0]);
            },
            markers: Set.from(myMarker),
          ),
          Positioned(
            top: 30.0,
            right: 60.0,
            left: 15.0,
            child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Theme.of(context).focusColor),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Address',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 15.0, top: 15.0),
                  suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: searchandNavigate,
                      iconSize: 30.0),
                ),
                onChanged: (val) {
                  setState(() {
                    searchAddr = val;
                  });
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 60.0,
            child: ButtonTheme(
              minWidth: 50.0,
              height: 20.0,
              child: RaisedButton(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(15.0),
                ),
                textColor: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Text("Select Location"),
                onPressed: () {
                  print(_selectedAddress);
                  Navigator.pop(context, _selectedAddress);
                },
                color: Theme.of(context).buttonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  searchandNavigate() {
    Geolocator().placemarkFromAddress(searchAddr).then((result) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target:
              LatLng(result[0].position.latitude, result[0].position.longitude),
          zoom: 15.0)));
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  _handleTap(LatLng point) {
    print(point);
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
      ));
    });
  }

  _getAddressFromLatLng(point) async {
    try {
      List<Placemark> p = await Geolocator().placemarkFromCoordinates(
          point.position.latitude, point.position.longitude);

      Placemark place = p[0];

      setState(() {
        _selectedAddress =
            "${place.name}, ${place.thoroughfare}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}
