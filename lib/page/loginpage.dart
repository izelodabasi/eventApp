import 'package:event/page/registerpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import '../service/authentication.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();

  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    double _width;
    if (MediaQuery.of(context).size.width > 600) {
      _width = 600;
    } else {
      _width = MediaQuery.of(context).size.width;
    }
    final _height = MediaQuery.of(context).size.height;

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: _height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20, 150, 0, 0),
                  width: _width,
                  child: Text(
                    'Welcome',
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
                    TextFormField(
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Provide an email';
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
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
                          return 'Password or email is not correct';
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 1,
                          ),
                        ),
                      ),
                      onChanged: (input) => _password = input,
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 20,
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
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            await _auth.signIn(_email, _password);
                          }
                        },
                        child: Text('LOGIN'),
                      ),
                    ),
                    SizedBox(height: 50),
                    SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        await _auth.signInWithGoogle();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SignInButton(
                      Buttons.Facebook,
                      onPressed: () async {
                        await _auth.signInWithFacebook();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment(0.2, 0.6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dont have an account',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      focusColor: Theme.of(context).buttonColor,
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          color: Theme.of(context).buttonColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
