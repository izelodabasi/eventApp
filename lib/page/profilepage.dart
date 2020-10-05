import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/user.dart';
import 'package:event/page/editprofilpage.dart';
import 'package:event/page/otheruserpage.dart';
import 'package:event/service/authentication.dart';
import 'package:event/service/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<QuerySnapshot> userDocs;
  Future<QuerySnapshot> requestDocs;

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<UserData>(context);
    var _auth = AuthService();

    _getRequest(userData.uid);
    double _width;
    if (MediaQuery.of(context).size.width > 600) {
      _width = 600;
    } else {
      _width = MediaQuery.of(context).size.width;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: new IconThemeData(color: Theme.of(context).buttonColor),
        title: Text('Profile'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            color: Theme.of(context).buttonColor,
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: UserSearch(username: userData.username));
            },
          ),
          requestDocs == null
              ? Text("")
              : FutureBuilder<QuerySnapshot>(
                  future: requestDocs,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return IconButton(
                        icon: Icon(Icons.favorite),
                        color: Theme.of(context).buttonColor,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RequestPage(docs: snapshot.data.documents),
                            ),
                          );
                        },
                      );
                    } else {
                      return Container(
                          alignment: FractionalOffset.center,
                          child: CircularProgressIndicator());
                    }
                  }),
          /* FlatButton(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    await _auth.signOut();
                  },
                ), */
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(children: [
                SizedBox(
                  height: 5.0,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(userData.photoUrl),
                  radius: 20.0,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  userData.username,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ]),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
              ),
            ),
            ListTile(
              title: Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilPage(user: userData),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              onTap: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
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
                        color: Theme.of(context).focusColor,
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
                                        color: Theme.of(context)
                                            .textSelectionColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Text(
                                      userData.eventsOfUser.length.toString(),
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
                                        builder: (context) => FollowerPage(
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
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        userData.followers.length.toString(),
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
                                        builder: (context) => FollowerPage(
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
                                          color: Theme.of(context)
                                              .textSelectionColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        userData.following.length.toString(),
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
      ),
    );
  }

  void _getRequest(String uid) async {
    Future<QuerySnapshot> requests = Firestore.instance
        .collection("relation")
        .where('followingID', isEqualTo: uid)
        .where('isPending', isEqualTo: true)
        .getDocuments();
    setState(() {
      requestDocs = requests;
    });
  }
}

class UserSearchItem extends StatelessWidget {
  final UserData searchedUser;
  const UserSearchItem(this.searchedUser);

  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    return GestureDetector(
      child: ListTile(
        title: Text(searchedUser.username, style: boldStyle),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtherUserPage(
              userData: searchedUser,
            ),
          ),
        );
      },
    );
  }
}

//waiting list
class RequestPage extends StatefulWidget {
  final docs;
  const RequestPage({Key key, this.docs}) : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  var clicked = [];
  var choosen = [];
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        for (int i = 0; i < widget.docs.length; i++) {
          clicked.add(false);
          choosen.add(0);
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Requests'),
        iconTheme:
            new IconThemeData(color: Theme.of(context).textSelectionColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (int i = 0; i < widget.docs.length; i++)
              FutureBuilder(
                future: DatabaseService()
                    .getUserData(widget.docs[i].data['followerID']),
                builder: (context, snapshot) {
                  UserData userData = snapshot.data;

                  if (snapshot.connectionState != ConnectionState.done) {
                    // return: show loading widget
                  }
                  if (snapshot.hasError) {
                    // return: show error widget
                  }
                  return Column(
                    children: <Widget>[
                      Card(
                        color: Theme.of(context).focusColor,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          height: 65,
                          child: new Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              Text(userData.username),
                              clicked[i] == false
                                  ? ButtonBar(
                                      children: <Widget>[
                                        FlatButton(
                                          child: const Text('Accept'),
                                          onPressed: () async {
                                            Firestore.instance
                                                .collection('users')
                                                .document(widget.docs[i]
                                                    .data['followingID'])
                                                .updateData({
                                              'followers':
                                                  FieldValue.arrayUnion([
                                                widget
                                                    .docs[i].data['followerID']
                                              ]),
                                            });
                                            Firestore.instance
                                                .collection('users')
                                                .document(widget
                                                    .docs[i].data['followerID'])
                                                .updateData({
                                              'following':
                                                  FieldValue.arrayUnion([
                                                widget
                                                    .docs[i].data['followingID']
                                              ]),
                                            });
                                            Firestore.instance
                                                .collection('relation')
                                                .document(widget
                                                    .docs[i].data['relationID'])
                                                .updateData({
                                              'isPending': false,
                                              'isAccepted': true
                                            });
                                            print(clicked[i]);
                                            setState(() {
                                              clicked[i] = true;
                                              choosen[i] = 1;
                                            });
                                            print(choosen[i]);
                                          },
                                        ),
                                        FlatButton(
                                          child: const Text('Decline'),
                                          onPressed: () {
                                            Firestore.instance
                                                .collection('relation')
                                                .document(widget
                                                    .docs[i].data['relationID'])
                                                .delete();
                                            setState(() {
                                              clicked[i] = true;
                                              choosen[i] = 2;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        choosen[i] == 1
                                            ? Text("Accepted")
                                            : Text("Declined"),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

class UserSearch extends SearchDelegate<String> {
  final String username;
  UserSearch({Key key, @required this.username});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    Future<QuerySnapshot> users = Firestore.instance
        .collection("users")
        .where('username', isGreaterThanOrEqualTo: query)
        .getDocuments();

    return FutureBuilder<QuerySnapshot>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return buildSearchResults(snapshot.data.documents, username);
          } else {
            return Container(
                alignment: FractionalOffset.center,
                child: CircularProgressIndicator());
          }
        });
  }

  ListView buildSearchResults(
      List<DocumentSnapshot> docs, String avoidUsername) {
    List<UserSearchItem> userSearchItems = [];

    docs.forEach((DocumentSnapshot doc) {
      UserData user = UserData.fromMap(doc.data);
      UserSearchItem searchItem = UserSearchItem(user);

      if (avoidUsername != user.username) {
        userSearchItems.add(searchItem);
      }
      //userSearchItems.add(searchItem);
    });

    return ListView(
      shrinkWrap: true,
      children: userSearchItems,
    );
  }
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
                                                userData: users[i]),
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
