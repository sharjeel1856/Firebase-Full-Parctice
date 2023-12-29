import 'package:firebase_1/Widgets/round_button.dart';
import 'package:firebase_1/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordcontroller = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordcontroller.dispose();
  }

  void signup() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordcontroller.text.toString())
        .then((value) {
          setState(() {
            loading = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        })
        .then((value) => {
              setState(() {
                loading = false;
              }),
              Utils().toastMessage("Sign Up Completed")
            })
        .onError((error, stackTrace) => {
              setState(() {
                loading = false;
              }),
              Utils().toastMessage("Sign Up Completed")
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Signup')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: const InputDecoration(
                          hintText: 'Password', prefixIcon: Icon(Icons.lock)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            SizedBox(
              height: 50,
            ),
            RoundButton(
              title: 'Sign up',
              loading: loading,
              onTap: () {
                if (_formkey.currentState!.validate()) {
                  signup(); //calling signin function which contain loading indicator
                }
              },
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                    onPressed: () {
                      //when user click signup it will go to the next screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: Text('Login'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
