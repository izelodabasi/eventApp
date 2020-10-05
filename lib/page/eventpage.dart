import 'package:event/service/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:event/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  final owner;
  final event;
  const EventPage({Key key, this.event, this.owner}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String buttonText = 'JOIN';
  GoogleMapController mapController;
  LatLng _initialPosition = LatLng(38.42, 27.14);
  Location location = Location();
  List<Marker> locationMarkers = [];
  List locationlist = [];

  _onMapCreated(GoogleMapController controller) async {
    getLocation();
    setState(() {
      mapController = controller;
    });
  }

  getLocation() async {
    Geolocator().placemarkFromAddress(widget.event.location).then((result) {
      var point =
          LatLng(result[0].position.latitude, result[0].position.longitude);
      setState(
        () {
          locationMarkers.add(Marker(
            markerId: MarkerId(widget.event.name),
            position: point,
            infoWindow: InfoWindow(title: widget.event.name),
          ));
          _gotoLocation(
              result[0].position.latitude, result[0].position.longitude);
        },
      );
    });
  }

  _gotoLocation(double lat, double long) async {
    await mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, long), zoom: 14)));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    double height;
    if (MediaQuery.of(context).size.width > 600) {
      height = 300;
    } else {
      height = 200;
    }
    return StreamBuilder<UserData>(
      stream: DatabaseService().streamUserData(user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userData = snapshot.data ?? [];
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (userData.selectedEvents.contains(widget.event.eventid)) {
              setState(() {
                buttonText = 'CANCEL';
              });
            } else {
              setState(() {
                buttonText = 'JOIN';
              });
            }
          });

          int month = int.parse(widget.event.date.split('-')[1]);
          int day = int.parse(widget.event.date.split('-')[2]);
          int year = int.parse(widget.event.date.split('-')[0]);
          var date = new DateTime.utc(year, month, day);
          String weekDay = DateFormat('MMMMEEEEd').format(date);
          String time = widget.event.time;

          return Scaffold(
            appBar: new AppBar(
              title: new Text(widget.event.name),
              iconTheme:
                  new IconThemeData(color: Theme.of(context).buttonColor),
            ),
            body: SingleChildScrollView(
              child: new Container(
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 60,
                      alignment: Alignment.center,
                      child: Text(
                        widget.event.name,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.event.type,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.owner.photoUrl),
                            radius: 20.0,
                          ),
                          Container(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 10, 10, 10),
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
                    SizedBox(
                      width: 40,
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 5, 20, 20),
                      child: Container(
                        height: height,
                        width: MediaQuery.of(context).size.height - 40,
                        child: GoogleMap(
                          initialCameraPosition:
                              CameraPosition(target: _initialPosition, zoom: 9),
                          onMapCreated: _onMapCreated,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          rotateGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          markers: Set.from(locationMarkers),
                        ),
                      ),
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
                        child: Text(buttonText),
                        onPressed: () {
                          Firestore.instance
                              .collection("users")
                              .document(userData.uid)
                              .updateData({
                            'selectedEvents':
                                FieldValue.arrayUnion([widget.event.eventid]),
                          });
                          Firestore.instance
                              .collection("events")
                              .document(widget.event.eventid)
                              .updateData({
                            'participants':
                                FieldValue.arrayUnion([userData.uid]),
                          });
                          setState(() {
                            buttonText = 'CANCEL';
                          });

                          if (userData.selectedEvents
                              .contains(widget.event.eventid)) {
                            setState(() {
                              buttonText = 'JOIN';
                            });
                            Firestore.instance
                                .collection("users")
                                .document(userData.uid)
                                .updateData({
                              'selectedEvents': FieldValue.arrayRemove(
                                  [widget.event.eventid]),
                            });
                            Firestore.instance
                                .collection("events")
                                .document(widget.event.eventid)
                                .updateData({
                              'participants':
                                  FieldValue.arrayRemove([userData.uid]),
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Column();
        }
      },
    );
  }
}
