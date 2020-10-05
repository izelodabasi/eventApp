import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String eventid;
  final String createdBy;
  final String name;
  final String type;
  final String location;
  final String date;
  final String time;
  final String photoUrl;
  final bool isPublic;
  final bool isCompleted;
  final double rate;
  final int rateCount;
  final List<String> inviteList;
  final List<String> participants;
  final List<String> ratedUsers;
  final List<String> eventPhotos;

  Event(
      {this.eventid,
      this.createdBy,
      this.name,
      this.type,
      this.location,
      this.date,
      this.time,
      this.photoUrl,
      this.isPublic,
      this.isCompleted,
      this.rate,
      this.rateCount,
      this.inviteList,
      this.participants,
      this.ratedUsers,
      this.eventPhotos});

  factory Event.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Event(
      eventid: doc.documentID,
      createdBy: data['createdBy'] ?? '',
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      location: data['location'] ?? '',
      date: data['date'] ?? '',
      time: data['time'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      isPublic: data['isPublic'] ?? true,
      isCompleted: data['isCompleted'] ?? false,
      rate: data['rate'] ?? 0.0,
      rateCount: data['rateCount'] ?? 0,
      inviteList: data['inviteList'].cast<String>() ?? '',
      participants: data['participants'].cast<String>() ?? '',
      ratedUsers: data['ratedUsers'].cast<String>() ?? '',
      eventPhotos: data['eventPhotos'].cast<String>() ?? '',
    );
  }
}
