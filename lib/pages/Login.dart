import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/component/ThButton.dart';
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
  bool isLogin = true;

  @override
  void initState() {
    super.initState();
    NoteStore.username = usernamecontroller.text;
  }

  Future<void> createUser() async {
    final userCredential = FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: usernamecontroller.text.trim(),
        password: passwordcontroller.text.trim()
    );
    print(userCredential);
  }

  Future<void> loginUser() async {
    final userCredential = FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginusernamecontroller.text.trim(),
        password: loginpasswordcontroller.text.trim()
    );
    print(userCredential);
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
            minHeight: screenWidth<426?352:500
          ),
          width: 0,
          height: 0,
          child:isLogin? Padding(
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
                  text: 'Enter Username',
                  controller: loginusernamecontroller,
                ),
                SizedBox(height: 20),
                ThTextbox(
                  variant: 'password',
                  text: 'Enter Password',
                  controller: loginpasswordcontroller,
                ),
                SizedBox(height: 20),
                ThButton(
                  text: 'Login',
                  variant: 'primary',
                  width: 400,
                  height: 40,
                  onPress: ()async{
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
                )
              ],
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
                ThTextbox(
                  variant: 'password',
                  text: 'Confirm Password',
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
