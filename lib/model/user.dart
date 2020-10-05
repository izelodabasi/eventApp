class User {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final List<String> eventsOfUser;

  User({this.uid, this.username, this.email, this.photoUrl, this.eventsOfUser});

  factory User.fromMap(Map data) {
    return User(
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      eventsOfUser: data['eventsOfUser'] ?? '',
    );
  }
}

class UserData {
  final String uid;
  final String username;
  final String email;
  final String photoUrl;
  final String androidNotificationToken;
  final List<String> eventsOfUser;
  final List<String> selectedEvents;
  final List<String> followers;
  final List<String> following;

  UserData(
      {this.uid,
      this.username,
      this.email,
      this.photoUrl,
      this.androidNotificationToken,
      this.eventsOfUser,
      this.selectedEvents,
      this.followers,
      this.following});

  factory UserData.fromMap(Map data) {
    return UserData(
      uid: data['uid'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      androidNotificationToken: data['androidNotificationToken'] ?? '',
      eventsOfUser: data['eventsOfUser'].cast<String>() ?? '',
      selectedEvents: data['selectedEvents'].cast<String>() ?? '',
      followers: data['followers'].cast<String>() ?? '',
      following: data['following'].cast<String>() ?? '',
    );
  }
}
