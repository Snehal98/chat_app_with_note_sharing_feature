import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'CreateAccount.dart';
import 'Methods.dart';
import '../Screens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isObscure = true;
  bool loginfail = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 10,
                  ),
                  // Container(
                  //   alignment: Alignment.centerLeft,
                  //   width: size.width / 0.5,
                  //   child: IconButton(
                  //       icon: Icon(Icons.arrow_back_ios), onPressed: () {}),
                  // ),
                  SizedBox(
                    height: size.height / 50,
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width / 1.1,
                    child: Text(
                      "Sign In to Continue!",
                      // textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  // child: field(size, "Email", Icons.account_box, _email,
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Container(
                      alignment: Alignment.centerRight,
                      height: size.height / 11,
                      width: size.width / 1.1,
                      child: Align(
                        // child: field(size, "Password", Icons.lock, _password, isObscure = true),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          controller: _email,
                          // obscureText: _isObscure,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_box),
                              // labelText: 'Password',
                              hintText: 'Email',
                              errorText: loginfail ? 'Email does not match' : null,
                              // suffixIcon: IconButton(
                              //   icon: Icon(
                              //     _isObscure
                              //         ? Icons.visibility
                              //         : Icons.visibility_off,
                              //   ),
                              //   onPressed: () {
                              //     setState(() {
                              //       _isObscure = !_isObscure;
                              //     });
                              //   },
                              // ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
                    child: Container(
                      height: size.height / 11,
                      width: size.width / 1.1,
                      child: Align(
                      // child: field(size, "Password", Icons.lock, _password, isObscure = true),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        controller: _password,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          // labelText: 'Password',
                          hintText: 'Password',
                          errorText: loginfail ? 'Password does not match' : null,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isObscure = !_isObscure;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                        ),
                      ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height / 10,
                  ),
                  customButton(size),
                  SizedBox(
                    height: size.height / 40,
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // login();
                  //   },
                  //   child: Text('Submit'),
                  // ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => CreateAccount())),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
      ),
    );
  }

  // Future<void> login() async {
  //   final formState = _formKey.currentState;
  //   if (formState!.validate()) {
  //     formState.save();
  //     try {
  //       // final FirebaseUser user = (await FirebaseAuth.instance.
  //       // signInWithEmailAndPassword(
  //           logIn(email: _email.text, password: _password.text))
  //           .user;
  //       if (!user.uid.isEmpty()) {
  //         Navigator.push(
  //             context, MaterialPageRoute(builder: (context) => CreateAccount()));
  //       } else {
  //         setState(() {
  //           loginfail = true; //loginfail is bool
  //         });
  //       }
  //     } catch (e) {
  //       print(e.toString());
  //     }
  //   }



  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        final formState = _formKey.currentState;
        if (_email.text.isNotEmpty && _password.text.isNotEmpty && formState!.validate()) {
          setState(() {
            isLoading = true;
          });

          logIn(_email.text, _password.text).then((user) {
            if (user != null) {
              print("Login Sucessfull");
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
            } else {
              print("Login Failed");
              setState(() {
                isLoading = false;
                loginfail = true;
                _email.clear();
                _password.clear();
              });
            }
          });
        } else {
          print("Please fill form correctly");
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
        child: Container(
            height: size.height / 14,
            width: size.width / 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.redAccent,
            ),
            alignment: Alignment.center,
            child: Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )),
      ),
    );
  }

//   Widget field(
//       Size size, String hintText, IconData icon, TextEditingController cont, {bool obscureText = true}) {
//     return Container(
//       height: size.height / 14,
//       width: size.width / 1.1,
//       child: TextField(
//         controller: cont,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//     );
//   }
// }

  Widget field(Size size, String hintText, IconData icon,
      TextEditingController cont, bool isObscure) {
    return Container(
        height: size.height / 14,
        width: size.width / 1.1,
        child: Align(
          // alignment: Alignment.bottomRight,
          child: TextField(
            obscureText: isObscure,
            controller: cont,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: hintText,
              contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              // suffixIcon: IconButton(
              //   icon: Icon(
              //     _isObscure ? Icons.visibility : Icons.visibility_off,
              //   ),
              //   onPressed: () {
              //     setState(() {
              //       _isObscure = !_isObscure;
              //     });
              //   },
              // ),
            ),
          ),
        ));
  }
}

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   bool isLoading = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       body: isLoading
//           ? Center(
//         child: Container(
//           height: size.height / 20,
//           width: size.width / 20,
//           child: CircularProgressIndicator(),
//         ),
//       )
//           : SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: size.height / 20,
//             ),
//             Container(
//                 alignment: Alignment.centerLeft,
//                 width: size.width / 0.5,
//                 child: IconButton(
//                     icon: Icon(Icons.arrow_back_ios), onPressed: () {})),
//             SizedBox(
//               height: size.height / 50,
//             ),
//             Container(
//               width: size.width / 1.1,
//               child: Text(
//                 "Welcome",
//                 style: TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Container(
//               width: size.width / 1.1,
//               child: Text(
//                 "Sign In to Continue",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: 22,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: size.height / 10,
//             ),
//             Container(
//               width: size.width,
//               alignment: Alignment.center,
//               child: field(size, "email", Icons.account_box, _email),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 18.0),
//               child: Container(
//                 width: size.width,
//                 alignment: Alignment.center,
//                 child: field(size, "password", Icons.lock, _password),
//               ),
//             ),
//             SizedBox(
//               height: size.height / 10,
//             ),
//             customButton(size),
//             SizedBox(
//               height: size.height / 40,
//             ),
//             GestureDetector(
//               onTap: () => Navigator.of(context).push(
//                   MaterialPageRoute(builder: (_) => CreateAccount())),
//               child: Text(
//                 "Create Account",
//                 style: TextStyle(
//                   color: Colors.redAccent,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget customButton(Size size) {
//     return GestureDetector(
//         onTap: () {
//           if (_email.text.isNotEmpty && _password.text.isNotEmpty) {
//             setState(() {
//               isLoading = true;
//             });
//
//             logIn(_email.text, _password.text).then((user) {
//               if (user != null) {
//                 print("Login Successfull");
//                 setState(() {
//                   isLoading = false;
//                 });
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (_) => HomeScreen()));
//               } else {
//                 print("Login Failed");
//               }
//             });
//           } else {
//             print("Please fill form correctly");
//           }
//         },
//         child: Container(
//             height: size.height / 14,
//             width: size.width / 1.2,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               color: Colors.redAccent,
//             ),
//             alignment: Alignment.center,
//             child: Text(
//               "Login",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             )));
//   }
//
//   Widget field(
//       Size size, String hintText, IconData icon, TextEditingController cont) {
//     return Container(
//       height: size.height / 15,
//       width: size.width / 1.1,
//       child: TextField(
//         controller: cont,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           hintText: hintText,
//           hintStyle: TextStyle(color: Colors.grey),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//     );
//   }
// }


