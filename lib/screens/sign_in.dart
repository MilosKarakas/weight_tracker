import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:weight_tracker/helpers/modals_helper.dart';
import 'package:weight_tracker/screens/home.dart';
import 'package:weight_tracker/screens/sign_up.dart';
import 'package:weight_tracker/services/auth_service.dart';
import 'package:weight_tracker/service_locator.dart';
import 'package:weight_tracker/widgets/wt_input_field.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> _signInForm = GlobalKey<FormState>();
  TextEditingController _signInEmailController = TextEditingController();
  TextEditingController _signInPasswordController = TextEditingController();
  FocusNode _signInPasswordNode = FocusNode();
  bool _signInOrSignUpUnderOngoing = false;

  @override
  void dispose() {
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    _signInPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Form(
        key: _signInForm,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            Padding(
              padding: EdgeInsets.only(top: 64.0, bottom: 48.0),
              child: Text(
                'Welcome to Weight Tracker.',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 32.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                'Sign In',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
            WTInputField(
              controller: _signInEmailController,
              label: 'Email',
              textInputAction: TextInputAction.next,
              validator: (text) {
                if (text != null && text.isEmpty) {
                  return 'Please enter an email address.';
                }
                return null;
              },
              onEditingComplete: () {
                _signInPasswordNode.requestFocus();
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            WTInputField(
              controller: _signInPasswordController,
              focusNode: _signInPasswordNode,
              label: 'Password',
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: (text) {
                if (text != null && text.isEmpty) {
                  return 'Please enter a password.';
                }
                return null;
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
                onPressed: () => signIn(context),
                child: Center(
                  child: Text('Submit'),
                )),
            SizedBox(
              height: 32.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(bottom: 32.0),
                child: RichText(
                    text: TextSpan(text: "Don't have an account? ", children: [
                  TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                          color: Colors.deepOrange,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        }),
                  TextSpan(
                    text: ' / ',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                      text: 'Sign In Anonymously',
                      style: TextStyle(
                          color: Colors.deepOrange,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => signInAnonymosuly(context))
                ])),
              ),
            )
          ],
        ),
      ),
    );
  }

  void changeSignInSignUpOngoing() {
    setState(() {
      _signInOrSignUpUnderOngoing = !_signInOrSignUpUnderOngoing;
    });
  }

  void signIn(BuildContext context) async {
    if (_signInForm.currentState != null &&
        _signInForm.currentState!.validate() &&
        !_signInOrSignUpUnderOngoing) {
      changeSignInSignUpOngoing();
      final auth = serviceLocator<AuthService>();
      final credential = await auth.signIn(
          context, _signInEmailController.text, _signInPasswordController.text);
      changeSignInSignUpOngoing();
      if (credential != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      }
    } else if (_signInOrSignUpUnderOngoing) {
      ModalsHelper.snackbar(
          context, 'Wait until the previous operation is completed.');
    }
  }

  void signInAnonymosuly(BuildContext context) async {
    if (!_signInOrSignUpUnderOngoing) {
      changeSignInSignUpOngoing();
      final auth = serviceLocator<AuthService>();
      final credential = await auth.signInAnonymously(context);
      changeSignInSignUpOngoing();
      if (credential != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      }
    } else {
      ModalsHelper.snackbar(
          context, 'Wait until the previous operation is completed.');
    }
  }
}
