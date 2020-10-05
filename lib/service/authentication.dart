import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event/service/database.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FacebookLogin _facebookSignIn = new FacebookLogin();

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email) : null;
  }

  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  //sing in method
  Future<User> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return _userFromFirebaseUser(user);
  }

  //create new account and user data
  Future<String> signUp(
    String email,
    String password,
    String username,
  ) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    DatabaseService()
        .addUser(user.uid, email, username, user.photoUrl, '', [], [], [], []);

    return (user.uid);
  }

  //return current user
  Future getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  //return current user ID
  Future<String> getCurrentUserID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  /*Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }*/

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult =
        await _firebaseAuth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);

    var snap =
        await Firestore.instance.collection('users').document(user.uid).get();
    if (snap.data == null) {
      DatabaseService().addUser(user.uid, user.email, user.displayName,
          user.photoUrl, '', [], [], [], []);
    }
    return _userFromFirebaseUser(user);
  }

  void signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  Future<Null> signInWithFacebook() async {
    final FacebookLoginResult result = await _facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;

        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: accessToken.token,
        );

        final AuthResult authResult =
            await _firebaseAuth.signInWithCredential(credential);
        final FirebaseUser user = authResult.user;

        final FirebaseUser currentUser = await _firebaseAuth.currentUser();
        assert(user.uid == currentUser.uid);

        var snap = await Firestore.instance
            .collection('users')
            .document(user.uid)
            .get();
        if (snap.data == null) {
          DatabaseService().addUser(user.uid, user.email, user.displayName,
              user.photoUrl, '', [], [], [], []);
        }
        print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');

        return _userFromFirebaseUser(user);

        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        print('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }
}
