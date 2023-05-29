import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footbook/screens/home_page.dart';
import 'package:footbook/widgets/social_login_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:footbook/models/login_platform.dart';
import 'package:rive/rive.dart';

import '../utils/rive_utils.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.transparent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Positioned(
              right: 0,
              left: 0,
              bottom: -10,
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                ),

              )
            ),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                child: const SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico',
                          color: Colors.lightBlueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 48),
                      SignInForm(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  LoginPlatform _loginPlatform = LoginPlatform.none;

  late SMITrigger? check;
  late SMITrigger? error;
  late SMITrigger? reset;

  late SMITrigger? confetti;

  bool isShowLoading = false;
  bool isConffeti = false;

  StateMachineController getRiveController(Artboard artboard){
    StateMachineController? controller = StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);
    
    return controller;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      await signSuccess();
      print('name = ${googleUser.displayName}');
      print('email = ${googleUser.email}');
      print('id = ${googleUser.id}');

      setState(() {
        _loginPlatform = LoginPlatform.google;
      });

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      addUsertoFirestore(userCredential.user!);

      return userCredential;
    } else {
      signFail();
      throw Exception('Google 로그인 실패');
    }
  }

  Future addUsertoFirestore(User user) {
    return FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'name': user.displayName,
      'email': user.email,
      'loginPlatform': _loginPlatform.toString(),
    });
  }

  Future<void> signSuccess() async {
    setState(() {
      isShowLoading = true;
      isConffeti = true;
    });

    Future.delayed(
      Duration(seconds: 1),
      () {
        _formKey.currentState!.save();
        check!.fire();
        Future.delayed(
          Duration(seconds: 2),
              () {
            setState(() {
              isShowLoading = false;
            });
            confetti!.fire();
            Future.delayed(const Duration(seconds: 1), () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            });
          }
        );
      }
    );
  }

  Future<void> signFail() async {
    setState(() {
      isShowLoading = true;
      isConffeti = true;
    });
    Future.delayed(
      Duration(seconds: 1),
      () {
        error!.fire();

        Future.delayed(
          Duration(seconds: 2),
              () {
            setState(() {
              isShowLoading = false;
            });
            reset!.fire();
          }
        );
      }

    );
  }

  void signOut() async {
    switch (_loginPlatform) {
      case LoginPlatform.facebook:
      // await FacebookAuth.instance.logOut();
        break;
      case LoginPlatform.google:
      // 추가
        await GoogleSignIn().signOut();
        break;
      case LoginPlatform.kakao:
        break;
      case LoginPlatform.naver:
        break;
      case LoginPlatform.none:
        break;
    }

    setState(() {
      _loginPlatform = LoginPlatform.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              //fancy id input field 입력
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _emailController.text = value!;
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              //fancy password input field 입력
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _passwordController.text = value!;
                  },
                  decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              //fancy login button 입력
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      signSuccess();
                    } else {
                      signFail();
                    }
                  },
                  child: Text("Login", style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ),
              //fancy social login button 입력
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialLoginButton('google', signInWithGoogle),
                    SocialLoginButton('naver', () {}),
                    SocialLoginButton('kakao', () {}),
                  ],
                ),
              ),
              //fancy sign up button 입력
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {},
                      child: Text("Sign Up"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        isShowLoading ? CustomPositioned(
            child: RiveAnimation.asset(
              'assets/riveAsset/check.riv',
              onInit: (artboard) {
                StateMachineController? controller = RiveUtils.getRiveController(artboard);
                check = controller.findSMI("Check") as SMITrigger;
                error = controller.findSMI("Error") as SMITrigger;
                reset = controller.findSMI("Reset") as SMITrigger;
              },
            ),
        ) : const SizedBox(),

        isConffeti ? CustomPositioned(
          scale: 6,
          child: RiveAnimation.asset(
            fit: BoxFit.contain,
            'assets/riveAsset/confetti.riv',
            onInit: (artboard) {
              StateMachineController controller = RiveUtils.getRiveController(artboard);
              confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
            },
          )
        ) : const SizedBox(),
      ],
    );
  }
}

class CustomPositioned extends StatelessWidget {
  final Widget child;
  final double scale;

  const CustomPositioned({Key? key, required this.child, this.scale =1 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          Spacer(),
          SizedBox(
            width: 100,
            height: 100,
            child: Transform.scale(
              child: child,
              scale: scale,
            ),
          ),
          Spacer(flex:2),
        ],
      ),

    );
  }
}
