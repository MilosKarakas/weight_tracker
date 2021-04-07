import 'package:flutter/material.dart';
import 'package:weight_tracker/screens/sign_in.dart';
import 'package:weight_tracker/services/auth_service.dart';
import 'package:weight_tracker/service_locator.dart';
import 'package:weight_tracker/widgets/wt_input_field.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  GlobalKey<FormState> _signInForm = GlobalKey<FormState>();
  TextEditingController _signUpEmailController = TextEditingController();
  TextEditingController _signUpPasswordController = TextEditingController();
  FocusNode _signUpPasswordNode = FocusNode();

  @override
  void dispose() {
    _signUpEmailController.dispose();
    _signUpPasswordController.dispose();
    _signUpPasswordNode.dispose();
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
                'Sign Up',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
            WTInputField(
              controller: _signUpEmailController,
              label: 'Email',
              textInputAction: TextInputAction.next,
              validator: (text) {
                if (text != null && text.isEmpty) {
                  return 'Please enter an email address.';
                }
                return null;
              },
              onEditingComplete: () {
                _signUpPasswordNode.requestFocus();
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            WTInputField(
              controller: _signUpPasswordController,
              focusNode: _signUpPasswordNode,
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
                onPressed: () => signUp(context),
                child: Center(
                  child: Text('Submit'),
                )),
          ],
        ),
      ),
    );
  }

  void signUp(BuildContext context) async {
    if (_signInForm.currentState != null &&
        _signInForm.currentState!.validate()) {
      final auth = serviceLocator<AuthService>();
      final credential = auth.signUp(
          context, _signUpEmailController.text, _signUpPasswordController.text);
      if (credential != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
            (route) => false);
      }
    }
  }
}
