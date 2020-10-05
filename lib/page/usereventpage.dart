import 'package:event/model/user.dart';
import 'package:event/page/editeventpage.dart';
import 'package:event/page/pasteventpage.dart';
import 'package:event/service/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserEventPage extends StatefulWidget {
  @override
  _UserEventPageState createState() => _UserEventPageState();
}

class _UserEventPageState extends State<UserEventPage> {
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
        title: Text('My Events'),
      ),
      body: FutureBuilder<List>(
        future: db.getCurrentUserEvents(userData.uid),
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
                                      EditEventPage(event: events[i]),
                                ),
                              );
                            }
                          : () {
                              print(events[i].isPublic);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PastEvent(
                                    event: events[i],
                                    owner: userData,
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
                                  userData.uid != ""
                                      ? Positioned(
                                          bottom: 35,
                                          left: 10,
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    userData.photoUrl),
                                                radius: 12.0,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                userData.username,
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
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      alignment: Alignment.bottomLeft,
                                      height: 40,
                                      width: 100,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.white30,
                                      ),
                                      child: (events[i].isCompleted == false)
                                          ? Center(
                                              child: Text(
                                                "COMING",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green,
                                                ),
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                'PASSED',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red,
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
      ),
    );
  }
}
