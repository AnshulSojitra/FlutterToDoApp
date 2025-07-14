import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/component/ThButton.dart';
import 'package:untitled1/component/ThErrorCard.dart';
import 'package:untitled1/component/ThTextbox.dart';
import 'package:untitled1/pages/Home.dart';

import 'NoteStore.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernamecontroller=TextEditingController();
  final TextEditingController passwordcontroller=TextEditingController();
  final TextEditingController loginusernamecontroller=TextEditingController();
  final TextEditingController loginpasswordcontroller=TextEditingController();
  final FocusNode passwordfocusNode = FocusNode();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool isLogin = true;
  bool isloginerror = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    NoteStore.username = usernamecontroller.text;
  }

  Future<void> createUser() async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: usernamecontroller.text.trim(),
            password: passwordcontroller.text.trim()
        ).then((res) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        });;
      } on FirebaseAuthException catch (e) {
        print(e.message);
        setState(() {
          isloginerror = true;
          if(e.message=="The email address is badly formatted.") {
            errorMessage = '*Please enter a valid email address.';
          }
          else if(e.message=="Password should be at least 6 characters"){
            errorMessage= '*Password must be at least 6 characters long.';
          }
          else if(e.message=="A network error (such as timeout, interrupted connection or unreachable host) has occurred."){
            errorMessage = '*Network error. Please check your internet connection.';
          }
          else if(e.message=="The email address is already in use by another account."){
            errorMessage = '*This email address is already registered.';
          }
          else{
            errorMessage = e.message!;
          }
        });
      }
  }

  Future<void> loginUser() async {
    try {
      isloginerror = false;
      errorMessage= '';
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginusernamecontroller.text.trim(),
          password: loginpasswordcontroller.text.trim()
      ).then((res) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      });;

      setState(() {});
    } on FirebaseAuthException catch (e) {
      print(e.message);
      setState(() {
        isloginerror = true;
        if(e.message=="The email address is badly formatted.") {
          errorMessage = '*Please enter a valid email address.';
        }
        else if(e.message=="There is no user record corresponding to this identifier. The user may have been deleted."){
          errorMessage= '*No user found with this email address.';
        }
        else if(e.message=="The password is invalid or the user does not have a password."){
          errorMessage= '*Incorrect password. Please try again.';
        }
        else if(e.message=="A network error (such as timeout, interrupted connection or unreachable host) has occurred."){
          errorMessage = '*Network error. Please check your internet connection.';
        }
        else if(e.message=="The user account has been disabled by an administrator."){
          errorMessage = '*This account has been disabled. Please contact support.';
        }
        else if(e.message=="The user is not found."){
          errorMessage = '*User not found. Please sign up.';
        }
        else{
          errorMessage = e.message!;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: NoteStore.isDarkMode?Colors.grey.shade900:Colors.grey,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: NoteStore.isDarkMode?Colors.black26:Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(2, 2),
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(
            minWidth: screenWidth<426?250:400,
            minHeight: screenWidth<426?450:500
          ),
          width: 0,
          height: 0,
          child:isLogin? Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: NoteStore.isDarkMode?Colors.white:Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  ThTextbox(
                    variant: 'text',
                    text: 'Enter Email',
                    height: 60,
                    controller: loginusernamecontroller,
                    onSubmitted: (value){
                      FocusScope.of(context).requestFocus(passwordfocusNode);
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20),
                  ThTextbox(
                    variant: 'password',
                    text: 'Enter Password',
                    controller: loginpasswordcontroller,
                    focusNode: passwordfocusNode,
                    onSubmitted: (value)async{
                      await loginUser();
                    },
                  ),
                  SizedBox(height: 20),
                  ThButton(
                    text: 'Login',
                    variant: 'primary',
                    width: 400,
                    height: 40,
                    onPress: () async {
                      await loginUser();
                    },
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Don't have an account?",
                          style: TextStyle(
                            color: NoteStore.isDarkMode?Colors.white70:Colors.black87,
                          )
                      ),
                      GestureDetector(
                        onTap: (){
                          isLogin=false;
                          setState(() {});
                        },
                        child: Text(' Sign up.',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                        )
                        ),
                      )
                    ],
                  ),
                  if (isloginerror)
                    ThErrorCard(errorMessage: errorMessage,)
                ],
              ),
            ),
          ):

              // Sign Up Form

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Sign Up',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color:NoteStore.isDarkMode?Colors.white: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                ThTextbox(
                  variant: 'text',
                  text: 'Create Username',
                  controller: usernamecontroller,
                ),
                SizedBox(height: 20),
                ThTextbox(
                  variant: 'password',
                  text: 'Create Password',
                  controller: passwordcontroller,
                ),
                SizedBox(height: 20),
                ThButton(
                  text: 'Create Account',
                  variant: 'primary',
                  width: 400,
                  height: 40,
                  onPress: ()async {
                    await createUser();
                  },
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Already have an account?",
                        style: TextStyle(
                          color: NoteStore.isDarkMode?Colors.white70:Colors.black87,
                        )
                    ),
                    GestureDetector(
                      onTap: (){
                        isLogin=true;
                        setState(() {});
                      },
                      child: Text(' Login.',
                          style: TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold,
                          )
                      ),
                    )
                  ],
                ),
                if (isloginerror)
                  ThErrorCard(errorMessage: errorMessage,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
