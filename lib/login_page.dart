import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seeder/main.dart';
import 'package:seeder/theme.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  Future<UserCredential> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Row(children: [
      Container(
        width: 800,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(right: 270),
                child: Text(
                  'Log in',
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: LoginStyle.titleStyle,
                )),
            SizedBox(height: 50),
            ElevatedButton(
                style: LoginStyle.buttonStyle,
                onPressed: () {
                  signInWithGoogle().whenComplete(() {
                    //ref.read(isLogedIn.notifier).value = true;
                  });
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 50,
                    height: 50,
                    margin: EdgeInsets.only(right: 70),
                    decoration: LoginStyle.containerStyle,
                    child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child:
                            Image.asset("search.png", width: 30, height: 30)),
                  ),
                  Container(
                      width: 180,
                      child: Text(
                        "Log in with Google",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                      )),
                ])),
            SizedBox(height: 50),
            ElevatedButton(
                style: LoginStyle.buttonStyle,
                onPressed: () async {
                  ref.read(isLoading.notifier).value = true;
                  await FirebaseAuth.instance.signInAnonymously().then((a) => {
                        ref.read(isLoggedIn.notifier).value = true,
                        ref.read(isLoading.notifier).value = false,
                      });
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                        color: Color.fromARGB(255, 208, 208, 208),
                      ))),
                      margin: EdgeInsets.only(right: 75),
                      child: Container(
                          margin: EdgeInsets.only(right: 18),
                          child: Image.asset("github-logo.png",
                              width: 30, height: 30))),
                  Container(
                      width: 180,
                      child: Text(
                        'Log in with Github',
                        style: LoginStyle.buttontextStyle,
                      ))
                ])),
            SizedBox(height: 50),
            ElevatedButton(
                style: LoginStyle.buttonStyle,
                onPressed: () {},
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      height: 50,
                      width: 50,
                      decoration: LoginStyle.containerStyle,
                      margin: EdgeInsets.only(right: 70),
                      child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.key,
                            size: 30,
                            color: Colors.black,
                          ))),
                  Container(
                      width: 180,
                      child: Text(
                        'Log in with SSO',
                        style: LoginStyle.buttontextStyle,
                      ))
                ])),
            SizedBox(height: 50),
            ElevatedButton(
                style: LoginStyle.buttonStyle,
                onPressed: () {},
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      height: 50,
                      width: 50,
                      decoration: LoginStyle.containerStyle,
                      margin: EdgeInsets.only(right: 70),
                      child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Icon(
                            Icons.mail,
                            size: 30,
                            color: Colors.black,
                          ))),
                  Container(
                      width: 180,
                      child: Text('Log in with Email',
                          style: LoginStyle.buttontextStyle))
                ])),
            SizedBox(height: 50),
            ElevatedButton(
                style: LoginStyle.buttonStyle,
                onPressed: () async {
                  ref.read(isLoading.notifier).value = true;
                  await FirebaseAuth.instance.signInAnonymously().then((a) => {
                        ref.read(isLoggedIn.notifier).value = true,
                        ref.read(isLoading.notifier).value = false,
                      });
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                      height: 50,
                      width: 50,
                      decoration: LoginStyle.containerStyle,
                      margin: EdgeInsets.only(right: 70),
                      child: Container(
                          margin: EdgeInsets.only(right: 20),
                          child: Image.asset("anonymous.png",
                              width: 30, height: 30))),
                  Container(
                      width: 180,
                      child: Text(
                        'Log in Anonymous',
                        style: LoginStyle.buttontextStyle,
                      ))
                ])),
            SizedBox(height: 50),
            Container(
                width: 350,
                decoration: LoginStyle.seperatedLine,
                child: Container(
                    width: 50,
                    margin: EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account ? ",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18)),
                        InkWell(
                            onTap: () => {Navigator.push},
                            child: Text(" Sign up.",
                                textAlign: TextAlign.center,
                                style: LoginStyle.linkStyle))
                      ],
                    ))),
          ],
        ),
      ),
      Container(
        width: 735,
        alignment: Alignment.center,
        child: Text("AML Cloud"),
      )
    ]));
  }
}





// void signOutGoogle() async{
//   await googleSignIn.signOut();
// }
