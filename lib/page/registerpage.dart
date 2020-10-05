import 'package:event/page/loginpage.dart';
import 'package:event/service/authentication.dart';
import 'package:event/service/database.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

enum UploadOption { camera, gallery }

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();

  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _username;

  @override
  Widget build(BuildContext context) {
    double _width;
    if (MediaQuery.of(context).size.width > 600) {
      _width = 600;
    } else {
      _width = MediaQuery.of(context).size.width;
    }
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        elevation: 0,
        iconTheme: new IconThemeData(color: Theme.of(context).buttonColor),
      ),
      body: FutureBuilder<List>(
        future: DatabaseService().getUserList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // return: show loading widget
          }
          if (snapshot.hasError) {
            // return: show error widget
          }
          List users = snapshot.data ?? [];
          return SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: _height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 60, 0, 0),
                        width: _width,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Theme.of(context).textSelectionColor,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: _width,
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Provide an username';
                              }
                              for (int i = 0; i < users.length; i++) {
                                if (input == users[i].username) {
                                  return 'Choose different username';
                                }
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Username',
                              filled: true,
                              fillColor: Theme.of(context).focusColor,
                              contentPadding: const EdgeInsets.all(15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              focusColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            onChanged: (input) => _username = input,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Provide an email';
                              }
                              for (int i = 0; i < users.length; i++) {
                                if (input == users[i].email) {
                                  return 'Choose different email';
                                }
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.alternate_email),
                              labelText: 'Email',
                              filled: true,
                              fillColor: Theme.of(context).focusColor,
                              contentPadding: const EdgeInsets.all(15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              focusColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            onChanged: (input) => _email = input,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (input) {
                              if (input.length < 6) {
                                return 'Longer password please';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline),
                              labelText: 'Password',
                              filled: true,
                              fillColor: Theme.of(context).focusColor,
                              contentPadding: const EdgeInsets.all(15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              focusColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            onChanged: (input) => _password = input,
                            obscureText: true,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            validator: (input) {
                              print(_password);
                              print(input);
                              if (_password != input) {
                                return 'Password not matching';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline),
                              labelText: 'Confirm Password',
                              filled: true,
                              fillColor: Theme.of(context).focusColor,
                              contentPadding: const EdgeInsets.all(15),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              focusColor: Colors.black,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1,
                                ),
                              ),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 20),
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
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  dynamic result = await _auth.signUp(
                                      _email, _password, _username);
                                  print(result);

                                  Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                }
                              },
                              child: Text('SIGN UP'),
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
