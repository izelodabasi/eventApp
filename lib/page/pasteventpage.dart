import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/user.dart';
import 'package:event/service/database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PastEventPage extends StatefulWidget {
  @override
  _PastEventPageState createState() => _PastEventPageState();
}

class _PastEventPageState extends State<PastEventPage> {
  List owners = new List();

  getOwnerList(List events) async {
    List users = new List();
    for (int i = 0; i < events.length; i++) {
      users.add(await DatabaseService().getUserData(events[i].createdBy));
    }
    setState(() {
      owners = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    final DatabaseService db = DatabaseService();
    double height;
    if (MediaQuery.of(context).size.width > 600) {
      height = 300;
    } else {
      height = 200;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: new IconThemeData(color: Theme.of(context).buttonColor),
        title: Text('Past Events'),
      ),
      body: FutureBuilder<List>(
        future: db.getPastEvents(userData.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
          }
          if (snapshot.hasError) {
            // return: show error widget
          }
          List events = snapshot.data ?? [];
          events.sort((a, b) => a.date.compareTo(b.date));
          events = events.reversed.toList();
          events.sort((a, b) => a.time.compareTo(b.time));

          owners.length == 0 ? getOwnerList(events) : null;

          return Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  for (int i = 0; i < events.length; i++)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PastEvent(
                              event: events[i],
                              owner: owners[i],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.only(
                            left: 15, right: 15, bottom: 15, top: 15),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: new Column(
                          children: <Widget>[
                            Container(
                              height: height,
                              alignment: Alignment(0.9, 0.7),
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: new DecorationImage(
                                  image: NetworkImage(events[i].photoUrl),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  owners.length != 0
                                      ? Positioned(
                                          bottom: 35,
                                          left: 10,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    owners[i].photoUrl),
                                                radius: 12.0,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                owners[i].username,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Text("Loading"),
                                  Positioned(
                                    bottom: 5,
                                    left: 10,
                                    child: Text(
                                      events[i].name,
                                      style: TextStyle(
                                        color: Theme.of(context).cardColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //Divider(),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class PastEvent extends StatefulWidget {
  final event;
  final owner;
  const PastEvent({Key key, this.event, this.owner}) : super(key: key);

  @override
  _PastEventState createState() => _PastEventState();
}

class _PastEventState extends State<PastEvent> {
  int _givenRate = 0;
  double _rate;
  int _rateCount;
  bool clicked = false;
  bool saved = false;

  File _image;
  String _uploadedFileURL;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService().streamUserData(user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _rate = widget.event.rate;
              _rateCount = widget.event.rateCount;
            });
          });

          int month = int.parse(widget.event.date.split('-')[1]);
          int day = int.parse(widget.event.date.split('-')[2]);
          int year = int.parse(widget.event.date.split('-')[0]);
          var date = new DateTime.utc(year, month, day);
          String weekDay = DateFormat('MMMMEEEEd').format(date);
          String time = widget.event.time;
          double height;
          if (MediaQuery.of(context).size.width > 600) {
            height = 300;
          } else {
            height = 200;
          }
          return Scaffold(
            appBar: new AppBar(
              title: new Text(widget.event.name),
              iconTheme:
                  new IconThemeData(color: Theme.of(context).buttonColor),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  new Container(
                    height: height,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image: NetworkImage(widget.event.photoUrl),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      widget.event.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  (widget.event.ratedUsers.contains(userData.uid))
                      ? Container()
                      : saved == false
                          ? Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.sentiment_very_dissatisfied,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _givenRate = 1;
                                          });
                                        }),
                                    IconButton(
                                        icon: Icon(
                                          Icons.sentiment_dissatisfied,
                                          color: Colors.redAccent,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _givenRate = 2;
                                          });
                                        }),
                                    IconButton(
                                        icon: Icon(
                                          Icons.sentiment_neutral,
                                          color: Colors.amber,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _givenRate = 3;
                                          });
                                        }),
                                    IconButton(
                                        icon: Icon(
                                          Icons.sentiment_satisfied,
                                          color: Colors.lightGreen,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _givenRate = 4;
                                          });
                                        }),
                                    IconButton(
                                        icon: Icon(
                                          Icons.sentiment_very_satisfied,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _givenRate = 5;
                                          });
                                        }),
                                  ],
                                ),
                                ButtonTheme(
                                  minWidth: 100.0,
                                  height: 20.0,
                                  child: RaisedButton(
                                    color: Theme.of(context).buttonColor,
                                    textColor: Colors.white,
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(15.0),
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    child: Text('Save'),
                                    onPressed: () {
                                      var newRate =
                                          (_rate * _rateCount + _givenRate) /
                                              (_rateCount + 1);
                                      var newCount = _rateCount + 1;
                                      setState(() {
                                        _rate = newRate;
                                        _rateCount = newCount;
                                      });
                                      Firestore.instance
                                          .collection('events')
                                          .document(widget.event.eventid)
                                          .updateData(
                                        {
                                          'rate': _rate,
                                          'rateCount': _rateCount
                                        },
                                      );
                                      Firestore.instance
                                          .collection("events")
                                          .document(widget.event.eventid)
                                          .updateData({
                                        'ratedUsers': FieldValue.arrayUnion(
                                            [userData.uid]),
                                      });
                                      setState(() {
                                        saved = true;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.owner.photoUrl),
                          radius: 20.0,
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15.0, 10, 10, 10),
                          height: 40,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.owner.username,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 20),
                        child: Row(
                          children: [
                            Icon(Icons.star),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                              height: 20,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                saved == false
                                    ? (_rateCount == 0
                                        ? "No rate"
                                        : _rate.toString())
                                    : ((_rate * _rateCount + _givenRate) /
                                            (_rateCount + 1))
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 20),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                          height: 20,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            weekDay + ", " + time,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 20),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 0, 20, 0),
                          child: Icon(Icons.location_on),
                        ),
                        Expanded(
                          child: Text(
                            widget.event.location,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  (_uploadedFileURL != null && clicked == false)
                      ? Column(
                          children: [
                            Container(
                              height: height,
                              decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: NetworkImage(_uploadedFileURL),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            ButtonTheme(
                              minWidth: 200.0,
                              height: 20.0,
                              child: RaisedButton(
                                color: Theme.of(context).buttonColor,
                                textColor: Colors.white,
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.all(10.0),
                                child: Text('Add photo'),
                                onPressed: () {
                                  setState(() {
                                    clicked = true;
                                  });
                                  Firestore.instance
                                      .collection("events")
                                      .document(widget.event.eventid)
                                      .updateData({
                                    'eventPhotos': FieldValue.arrayUnion(
                                        [_uploadedFileURL]),
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      : ButtonTheme(
                          minWidth: 200.0,
                          height: 20.0,
                          child: RaisedButton(
                            color: Theme.of(context).buttonColor,
                            textColor: Colors.white,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child: Text('Choose a photo'),
                            onPressed: () {
                              print(clicked);
                              chooseFileFromGallery();
                              setState(() {
                                clicked = false;
                              });
                              print(clicked);
                            },
                          ),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                    height: 20,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Photos of event:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  for (int i = 0; i < widget.event.eventPhotos.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: height,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: NetworkImage(widget.event.eventPhotos[i]),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  (_uploadedFileURL != null && clicked == true)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: height,
                            decoration: new BoxDecoration(
                              image: new DecorationImage(
                                image: NetworkImage(_uploadedFileURL),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          );
        } else {
          return Column();
        }
      },
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
    });
  }
}
