import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/user.dart';
import 'package:event/page/pasteventpage.dart';
import 'package:event/service/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'eventpage.dart';

class OtherUserPage extends StatefulWidget {
  final UserData userData;
  OtherUserPage({Key key, @required this.userData}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  _OtherUserPageState createState() => _OtherUserPageState();
}

class _OtherUserPageState extends State<OtherUserPage> {
  bool clicked = false;
  var docID;
  Future<QuerySnapshot> requestDocs;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    UserData userData = widget.userData;
    double _width;
    if (MediaQuery.of(context).size.width > 600) {
      _width = 600;
    } else {
      _width = MediaQuery.of(context).size.width;
    }
    double height;
    if (MediaQuery.of(context).size.width > 600) {
      height = 300;
    } else {
      height = 200;
    }
    print(_width);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Profile'),
        iconTheme: new IconThemeData(color: Theme.of(context).buttonColor),
      ),
      body: userData.uid == user.uid
          ? SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                        child: Container(
                      width: _width,
                      height: 350.0,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(userData.photoUrl),
                              radius: 50.0,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              userData.username,
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Theme.of(context).textSelectionColor,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Card(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 20.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Events",
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5.0,
                                          ),
                                          Text(
                                            userData.eventsOfUser.length
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 20.0,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowerPage(
                                                uid: userData.uid,
                                                type: 1,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "Followers",
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              userData.followers.length
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowerPage(
                                                uid: userData.uid,
                                                type: 2,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              "Follows",
                                              style: TextStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5.0,
                                            ),
                                            Text(
                                              userData.following.length
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 20.0,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                    SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                      child: Container(
                    width: _width,
                    height: 350.0,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: NetworkImage(userData.photoUrl),
                            radius: 50.0,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            userData.username,
                            style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Card(
                            color: Theme.of(context).focusColor,
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 20.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Events",
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          userData.eventsOfUser.length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 20.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  userData.followers.contains(user.uid) == false
                                      ? Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Followers",
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                userData.followers.length
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowerPage(
                                                    uid: userData.uid,
                                                    type: 1,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  "Followers",
                                                  style: TextStyle(
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  userData.followers.length
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                  userData.followers.contains(user.uid) == false
                                      ? Expanded(
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Follows",
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5.0,
                                              ),
                                              Text(
                                                userData.following.length
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FollowerPage(
                                                    uid: userData.uid,
                                                    type: 2,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Column(
                                              children: <Widget>[
                                                Text(
                                                  "Follows",
                                                  style: TextStyle(
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text(
                                                  userData.following.length
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20.0,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                  userData.followers.contains(user.uid) == false
                      ? Container(
                          width: 150.00,
                          child: RaisedButton(
                            onPressed: () async {
                              if (clicked == false) {
                                var res =
                                    await sendRequest(user.uid, userData.uid);
                                setState(() {
                                  clicked = true;
                                  docID = res;
                                });
                                print(docID);
                              } else {
                                print(docID);
                                Firestore.instance
                                    .collection('relation')
                                    .document(docID)
                                    .delete();
                                setState(() {
                                  clicked = false;
                                });
                              }
                            },
                            color: Theme.of(context).buttonColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            elevation: 0.0,
                            padding: EdgeInsets.all(0.0),
                            child: Text(
                                clicked == false ? 'Follow' : 'Cancel Request'),
                          ),
                        )
                      : Container(
                          width: 150.00,
                          child: RaisedButton(
                            onPressed: () {
                              Firestore.instance
                                  .collection('users')
                                  .document(user.uid)
                                  .updateData({
                                'following': FieldValue.arrayRemove(
                                    [widget.userData.uid]),
                              });
                              Firestore.instance
                                  .collection('users')
                                  .document(widget.userData.uid)
                                  .updateData({
                                'followers': FieldValue.arrayRemove([user.uid]),
                              });
                              setState(() {
                                clicked = true;
                              });
                            },
                            color: Theme.of(context).buttonColor,
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0)),
                            elevation: 0.0,
                            padding: EdgeInsets.all(0.0),
                            child:
                                Text(clicked == false ? 'UNFOLLOW' : 'FOLLOW'),
                          ),
                        ),
                  userData.followers.contains(user.uid) == true
                      ? FutureBuilder<List>(
                          future: DatabaseService()
                              .getCurrentUserEvents(userData.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return Container();
                            }
                            if (snapshot.hasError) {
                              // return: show error widget
                            }
                            List events = snapshot.data ?? [];
                            events.sort((a, b) => a.date.compareTo(b.date));

                            return Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    for (int i = 0; i < events.length; i++)
                                      GestureDetector(
                                        onTap: events[i].isCompleted == false
                                            ? () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EventPage(
                                                      event: events[i],
                                                      owner: userData,
                                                    ),
                                                  ),
                                                );
                                              }
                                            : () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PastEvent(
                                                      event: events[i],
                                                      owner: userData,
                                                    ),
                                                  ),
                                                );
                                              },
                                        child: Card(
                                          color: Theme.of(context).focusColor,
                                          elevation: 5,
                                          margin: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              bottom: 15,
                                              top: 15),
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: new Column(
                                            children: <Widget>[
                                              Container(
                                                height: height,
                                                alignment: Alignment(0.9, 0.7),
                                                decoration: new BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  image: new DecorationImage(
                                                    image: NetworkImage(
                                                        events[i].photoUrl),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    userData.uid != ""
                                                        ? Positioned(
                                                            bottom: 35,
                                                            left: 10,
                                                            child: Row(
                                                              children: [
                                                                CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          userData
                                                                              .photoUrl),
                                                                  radius: 12.0,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                  userData
                                                                      .username,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .cardColor,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
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
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      right: 5,
                                                      child: Container(
                                                        alignment: Alignment
                                                            .bottomLeft,
                                                        height: 40,
                                                        width: 100,
                                                        decoration:
                                                            new BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          color: Colors.white30,
                                                        ),
                                                        child: (events[i]
                                                                    .isCompleted ==
                                                                false)
                                                            ? Center(
                                                                child: Text(
                                                                  "COMING",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                ),
                                                              )
                                                            : Center(
                                                                child: Text(
                                                                  'PASSED',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ],
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
                          },
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }
}

Future<String> sendRequest(String followerID, String followingID) async {
  DocumentReference documentReference =
      await Firestore.instance.collection('relation').add({
    'followerID': followerID,
    'followingID': followingID,
    'isPending': true,
    'isAccepted': false,
  });

  Firestore.instance
      .collection('relation')
      .document(documentReference.documentID)
      .updateData({'relationID': documentReference.documentID});
  return documentReference.documentID;
}

class FollowerPage extends StatefulWidget {
  final uid;
  final type;
  const FollowerPage({Key key, this.uid, this.type}) : super(key: key);

  @override
  _FollowerPageState createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          elevation: 0,
          iconTheme:
              new IconThemeData(color: Theme.of(context).textSelectionColor),
          title: widget.type == 1 ? Text('Followers') : Text('Follows')),
      body: widget.type == 1
          ? FutureBuilder<List>(
              future: DatabaseService().getFollowingList(widget.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  // return: show loading widget
                }
                if (snapshot.hasError) {
                  // return: show error widget
                }
                List users = snapshot.data ?? [];

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
                                      title: Text(users[i].username),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OtherUserPage(
                                              userData: users[i],
                                            ),
                                          ),
                                        );
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
                  ],
                );
              },
            )
          : FutureBuilder<List>(
              future: DatabaseService().getFollowersList(widget.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  // return: show loading widget
                }
                if (snapshot.hasError) {
                  // return: show error widget
                }
                List users = snapshot.data ?? [];

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
                                      title: Text(users[i].username),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OtherUserPage(
                                              userData: users[i],
                                            ),
                                          ),
                                        );
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
                  ],
                );
              },
            ),
    );
  }
}
