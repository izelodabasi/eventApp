import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/event.dart';
import 'package:event/model/user.dart';
//import com.facebook.FacebookSdk;
//import com.facebook.appevents.AppEventsLogger;

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final String uid;
  DatabaseService({this.uid});

  Future<UserData> getUserData(String uid) async {
    var snap = await _db.collection('users').document(uid).get();
    return UserData.fromMap(snap.data);
  }

  Stream<UserData> streamUserData(String uid) {
    return _db
        .collection('users')
        .document(uid)
        .snapshots()
        .map((snap) => UserData.fromMap(snap.data));
  }

  Future<List> getCurrentUserEvents(uid) async {
    var list = _db
        .collection('events')
        .where('createdBy', isEqualTo: uid)
        .getDocuments()
        .then((value) =>
            value.documents.map((e) => Event.fromFirestore(e)).toList());
    return list;
  }

  Future<List> getCurrentUserDatedEvents(uid, date) async {
    var list = _db
        .collection('events')
        .where('createdBy', isEqualTo: uid)
        .where('date', isEqualTo: date)
        .getDocuments()
        .then((value) =>
            value.documents.map((e) => Event.fromFirestore(e)).toList());
    return list;
  }

  Future<List> getPastEvents(uid) async {
    var list = _db
        .collection('events')
        .where('participants', arrayContains: uid)
        .where('isCompleted', isEqualTo: true)
        .getDocuments()
        .then((value) =>
            value.documents.map((e) => Event.fromFirestore(e)).toList());

    return list;
  }

  Future<List> getDateEvents(String date) async {
    var list = _db
        .collection('events')
        .where('date', isEqualTo: date)
        .getDocuments()
        .then((value) =>
            value.documents.map((e) => Event.fromFirestore(e)).toList());

    return list;
  }

  Future<List> getDates() async {
    var list = _db.collection('events').getDocuments().then((value) =>
        value.documents.map((e) => Event.fromFirestore(e).date).toList());

    return list;
  }

  Future<List> getUserList() async {
    var list = _db.collection('users').getDocuments().then((value) =>
        value.documents.map((e) => UserData.fromMap(e.data)).toList());

    return list;
  }

  Future<List> getFollowingList(uid) async {
    var list = Firestore.instance
        .collection('users')
        .where('following', arrayContains: uid)
        .getDocuments()
        .then((value) =>
            value.documents.map((e) => UserData.fromMap(e.data)).toList());

    return list;
  }

  Future<List> getFollowersList(uid) async {
    var list = Firestore.instance
        .collection('users')
        .where('followers', arrayContains: uid)
        .getDocuments()
        .then((value) =>
            value.documents.map((e) => UserData.fromMap(e.data)).toList());
    return list;
  }

  Future<List> getEventList(String id) async {
    List list = await Firestore.instance
        .collection("events")
        .where('isPublic', isEqualTo: true)
        .where('isCompleted', isEqualTo: false)
        .getDocuments()
        .then((value) =>
            value.documents.map((e) => Event.fromFirestore(e)).toList());

    List _list = await Firestore.instance
        .collection("events")
        .where('inviteList', arrayContains: id)
        .where('isCompleted', isEqualTo: false)
        .getDocuments()
        .then((value) =>
            value.documents.map((e) => Event.fromFirestore(e)).toList());
    return _list + list;
  }

  Future<void> addEvent(
      String uid,
      String name,
      String type,
      String location,
      String date,
      String time,
      String photoUrl,
      bool isPublic,
      bool isCompleted,
      double rate,
      int rateCount,
      List<String> inviteList,
      List<String> participants,
      List<String> ratedUsers,
      List<String> eventPhotos) async {
    if (photoUrl == null) {
      photoUrl =
          'https://firebasestorage.googleapis.com/v0/b/event-928da.appspot.com/o/chats%2Fstorage%2Femulated%2F0%2FAndroid%2Fdata%2Fcom.example.event%2Ffiles%2FPictures%2Fpexels-wendy-wei-1387174.jpg?alt=media&token=56e736f0-c361-49e1-999c-58970e152ae3';
    }
    DocumentReference documentReference = await _db.collection('events').add({
      'createdBy': uid,
      'name': name,
      'type': type,
      'location': location,
      'date': date,
      'time': time,
      'photoUrl': photoUrl,
      'isPublic': isPublic,
      'isCompleted': isCompleted,
      'rate': rate,
      'rateCount': rateCount,
      'inviteList': inviteList,
      'participants': participants,
      'ratedUsers': ratedUsers,
      'eventPhotos': eventPhotos
    });

    _db.collection('users').document(uid).updateData({
      'eventsOfUser': FieldValue.arrayUnion([documentReference.documentID]),
    });
    return (documentReference.documentID);
  }

  //works
  Future<void> addUser(
      String uid,
      String email,
      String username,
      String photoUrl,
      String androidNotificationToken,
      List<String> eventsOfUser,
      List<String> selectedEvents,
      List<String> followers,
      List<String> following) async {
    if (photoUrl == null) {
      photoUrl =
          'https://firebasestorage.googleapis.com/v0/b/event-928da.appspot.com/o/chats%2Fstorage%2Femulated%2F0%2FAndroid%2Fdata%2Fcom.example.event%2Ffiles%2FPictures%2Fprofile_pic.png?alt=media&token=c720c3fb-29a2-445c-9aa6-23281efed7bd';
    }
    return await Firestore.instance.collection('users').document(uid).setData({
      'uid': uid,
      'email': email,
      'username': username,
      'photoUrl': photoUrl,
      'androidNotificationToken': androidNotificationToken,
      'eventsOfUser': eventsOfUser,
      'selectedEvents': selectedEvents,
      'followers': followers,
      'following': following,
    });
  }

  //works
  Stream<List<Event>> streamEvent(User user) {
    var ref = _db.collection('users').document(user.uid).collection('events');

    return ref.snapshots().map((list) =>
        list.documents.map((doc) => Event.fromFirestore(doc)).toList());
  }
}
