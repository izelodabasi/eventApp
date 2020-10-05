import 'dart:io';
import 'package:event/model/user.dart';
import 'package:event/page/homepage.dart';
import 'package:event/service/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewEvent extends StatefulWidget {
  @override
  _NewEventState createState() => new _NewEventState();
}

enum UploadOption { camera, gallery }

class _NewEventState extends State<NewEvent> {
  final DatabaseService db = DatabaseService();
  List<String> inviteList = [];
  File _image;
  String _uploadedFileURL;

  final _formKey = new GlobalKey<FormState>();
  String _name;
  String _type;
  String _location = 'Location';
  String _date;
  String _time;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime24Hour = TimeOfDay.now();
  int group = 1;
  bool isPublic = true;
  bool isCompleted = false;
  String today = "${DateTime.now().toLocal()}".split(' ')[0];

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        elevation: 0,
        iconTheme: new IconThemeData(color: Theme.of(context).buttonColor),
        title: Text(
          'Add New Event',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _uploadedFileURL != null
                        ? new Container(
                            height: 150,
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: NetworkImage(_uploadedFileURL),
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        : new Container(
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Theme.of(context).textSelectionColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Align(
                              alignment: Alignment.center,
                              child: Text('Add a photo'),
                            ),
                          ),
                    SizedBox(
                      height: 10,
                    ),
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
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Name cant be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
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
                        validator: (input) {
                          if (input.isEmpty) {
                            return 'Explanation cant be empty';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Explanation',
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Theme.of(context).focusColor,
                            ),
                            child: Text(
                              _location,
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                    Theme.of(context).textSelectionHandleColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          IconButton(
                            icon: Icon(Icons.map),
                            onPressed: () async {
                              _location = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapPage(),
                                ),
                              );
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Theme.of(context).focusColor,
                            ),
                            child: Text(
                              "${selectedDate.toLocal()}".split(' ')[0],
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                    Theme.of(context).textSelectionHandleColor,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Theme.of(context).focusColor,
                            ),
                            child: Text(
                              selectedTime24Hour.format(context),
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                    Theme.of(context).textSelectionHandleColor,
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
                                isPublic = true;
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
                                isPublic = false;
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
                                          inviteList: inviteList,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
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
                          _date = "${selectedDate.toLocal()}".split(' ')[0];
                          _time = selectedTime24Hour.format(context);
                          if (_formKey.currentState.validate()) {
                            await db.addEvent(
                                user.uid,
                                _name,
                                _type,
                                _location,
                                _date,
                                _time,
                                _uploadedFileURL,
                                isPublic,
                                isCompleted,
                                0.1,
                                0,
                                inviteList, [], [], []);
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomePage(),
                              ),
                            );
                          }
                        },
                        child: Text('Add Event'),
                        color: Theme.of(context).buttonColor,
                      ),
                    ),
                    SizedBox(
                      height: 10,
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
      appBar: new AppBar(
        elevation: 0,
        iconTheme:
            new IconThemeData(color: Theme.of(context).textSelectionColor),
        title: Text(
          'Invite People',
        ),
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
          inviteList = widget.inviteList;

          if (snapshot.hasData) {
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
                                  title: Text(
                                    users[i].username,
                                  ),
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
                SizedBox(
                  height: 10,
                ),
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
              ],
            );
          }
        },
      ),
    );
  }
}

class MapPage extends StatefulWidget {
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
                        iconSize: 30.0)),
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
