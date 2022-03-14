import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'Methods.dart';
import '../Screens/HomeScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _userexists = false;
  bool _isObscure = true;
  CollectionReference userReference = FirebaseFirestore.instance.collection('users');

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
                      height: size.height / 8,
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
                        "Create Account to Continue!",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _name,
                          validator: (_name) {
                            // add your custom validation here.
                            if (_name!.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_box),
                              labelText: 'Name',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        // child: email_field(size, "Email", Icons.account_box, _email),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.center,
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _email,
                          validator: (_email) {

                            // userReference.get().then((value) {
                            //   // print(value.docs[0].data());
                            //   value.docs.forEach((element) {
                            //     final thisUser = element.data() as Map<String, dynamic>;
                            //     print(thisUser);
                            //     if (thisUser.isNotEmpty) {
                            //       final userUid = thisUser['uid'];
                            //       final userName = thisUser['name'];
                            //       final userEmail = thisUser['email'];
                            //       final userStatus = thisUser['status'];
                            //
                            //       if (userName != null && userEmail != null) {
                            //         allUsers.add({'uid': userUid, 'name': userName, 'email': userEmail, 'status': userStatus});
                            //       }
                            //     }
                            //   });
                            // });

                            // add your custom validation here.
                            if (_email!.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(_email)) {
                              return 'Enter a valid email!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_box),
                              labelText: 'Email',
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        // child: username_field(size, "Name", Icons.account_box, _name),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 18.0),
                    //   child: Container(
                    //     width: size.width,
                    //     alignment: Alignment.center,
                    //     child: field(size, "Password", Icons.lock, _password),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                        height: size.height / 14,
                        width: size.width / 1.1,
                        child: Align(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _password,
                            obscureText: _isObscure,
                            validator: (_password) {
                              // add your custom validation here.
                              if (_password!.isEmpty) {
                                return 'Please enter some text';
                              }
                              if (_password.length < 7) {
                                return 'Must be more than 6 charater';
                              }
                            },
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                labelText: 'Password',
                                contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                                )),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    // customButton(size),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: GestureDetector(
                    //     onTap: () => Navigator.pop(context),
                    //     child: Text(
                    //       "Login",
                    //       style: TextStyle(
                    //         color: Colors.redAccent,
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w500,
                    //       ),
                    //     ),
                    //   ),
                    // )
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Container(
                      height: size.height / 14,
                      width: size.width / 1.2,
                      child: ElevatedButton(
                          onPressed: () {

                            // Validate returns true if the form is valid, or false otherwise.
                            if (_name.text.isNotEmpty &&
                                _email.text.isNotEmpty &&
                                _password.text.isNotEmpty &&
                                _formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });

                              createAccount(
                                      _name.text, _email.text, _password.text)
                                  .then((user) {
                                print('Create account execute zalya nantar');
                                if (user != null) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomeScreen()));
                                  print("Account Created Sucessfully");
                                  Fluttertoast.showToast(
                                    msg: "Account Created Sucessfully",
                                  );
                                } else {
                                  print("Login Failed");
                                  setState(() {
                                    isLoading = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text('User already exists')),
                                        );
                                    _email.clear();
                                    _name.clear();
                                    _password.clear();
                                    // _userexists = true;
                                    // // Navigator.pop(context);
                                  });
                                }
                                // if (_userexists && _formKey.currentState!.validate()){
                                //   return "This user already exists";
                                // }
                              });
                            } else {
                              print("Please enter Fields");
                            }
                          },
                          style: ButtonStyle(
                            alignment: Alignment.center,
                            backgroundColor: MaterialStateProperty.all(
                              Colors.redAccent,
                            ),
                          ),
                          child: Container(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                          // child: Container(
                          //     height: size.height / 14,
                          //     width: size.width / 1.2,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(5),
                          //       color: Colors.redAccent,
                          //     ),
                          //     alignment: Alignment.center,
                          //     child: Text(
                          //       "Create Account",
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 18,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     )
                          // ),
                          ),
                      )
                    ),
                  ],
                ),
              )),
    );
  }

  Widget customButton(Size size) {
    return GestureDetector(
      onTap: () {
        if (_name.text.isNotEmpty &&
            _email.text.isNotEmpty &&
            _password.text.isNotEmpty &&
            _formKey.currentState!.validate()) {
          setState(() {
            isLoading = true;
          });

          createAccount(_name.text, _email.text, _password.text).then((user) {
            print('Create account execute zalya nantar');
            if (user != null) {
              setState(() {
                isLoading = false;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomeScreen()));
              print("Account Created Sucessfully");
              Fluttertoast.showToast(
                msg: "Account Created Sucessfully",
              );
            } else {
              print("Login Failed");
              setState(() {
                isLoading = false;
                // Navigator.pop(context);
              });
            }
          });
        } else {
          print("Please enter Fields");
        }
        // child: const Text('Show toast')
      },
      child: Container(
          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.redAccent,
          ),
          alignment: Alignment.center,
          child: Text(
            "Create Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }

// Widget email_field(
//     Size size, String hintText, IconData icon, TextEditingController cont) {
//   return Container(
//     height: size.height / 10,
//     width: size.width / 1.1,
//     child: TextField(
//       controller: cont,
//       decoration: InputDecoration(
//         // errorStyle: emailError ? TextStyle(color: Colors.red) : null,
//         // errorBorder: InputBorder(borderSide: BorderSide.none),
//         // errorStyle: emailError ? TextStyle(color: Colors.red) : TextStyle(color: Colors.black) ,
//         border: new OutlineInputBorder(
//             borderSide: new BorderSide(color: Colors.grey),
//             borderRadius: BorderRadius.circular(10),
//         ),
//         errorText: emailError ? "Email already exists!" : ' ',
//         errorStyle: emailError ? TextStyle(color: Colors.red) : TextStyle(height: 0, color: Colors.transparent),
//         prefixIcon: Icon(icon),
//         labelText: hintText,
//         contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//         hintStyle: TextStyle(color: Colors.grey),
//         // border: OutlineInputBorder(
//         //   borderRadius: BorderRadius.circular(10),
//         // ),
//       ),
//     ),
//   );
// }

//   Widget username_field(
//       Size size, String hintText, IconData icon, TextEditingController cont) {
//     return Container(
//       height: size.height / 10,
//       width: size.width / 1.1,
//       child: TextField(
//         controller: cont,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           labelText: hintText,
//           contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//           hintStyle: TextStyle(color: Colors.grey),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//     );
//   }
// }
}

// This is the correct code till the end
// import 'package:flutter/material.dart';
// import 'package:flutter/painting.dart';
// import 'Methods.dart';
// import '../Screens/HomeScreen.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class CreateAccount extends StatefulWidget {
//   @override
//   _CreateAccountState createState() => _CreateAccountState();
// }
//
// class _CreateAccountState extends State<CreateAccount> {
//   final TextEditingController _name = TextEditingController();
//   final TextEditingController _email = TextEditingController();
//   final TextEditingController _password = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//   bool emailError = false;
//   bool _isObscure = true;
//   bool _buttonActive = false;
//
//   String validatePassword(String value) {
//     if (!(value.length > 6) && value.isNotEmpty) {
//       return "Password should contain more than 6 characters";
//     }
//     return '';
//   }
//
//
//   void updateButtonState(String text){
//     // if text field has a value and button is inactive
//     if(text != null && text.length > 0 && !_buttonActive){
//       setState(() {
//         _buttonActive = true;
//       });
//     }else if((text == null || text.length == 0) && _buttonActive){
//       setState(() {
//         _buttonActive = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//
//
//     return Scaffold(
//       body: isLoading
//           ? Center(
//         child: Container(
//           height: size.height / 20,
//           width: size.height / 20,
//           child: CircularProgressIndicator(),
//         ),
//       )
//           : Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: size.height / 8,
//                 ),
//                 Container(
//                   width: size.width / 1.1,
//                   child: Text(
//                     "Welcome",
//                     style: TextStyle(
//                       fontSize: 34,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   width: size.width / 1.1,
//                   child: Text(
//                     "Create Account to Continue!",
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 // TextFormField(
//                 //   // The validator receives the text that the user has entered.
//                 //   validator: (value) {
//                 //     if (value == null || value.isEmpty) {
//                 //       return 'Please enter some text';
//                 //     }
//                 //     return null;
//                 //   },
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 18.0),
//                   child: Container(
//                     width: size.width,
//                     alignment: Alignment.center,
//                     child: username_field(size, "Name", Icons.account_box, _name),
//                   ),
//                 ),
//                 Container(
//                   width: size.width,
//                   alignment: Alignment.center,
//                   child: email_field(size, "Email", Icons.account_box, _email),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(vertical: 18.0),
//                 //   child: Container(
//                 //     width: size.width,
//                 //     alignment: Alignment.center,
//                 //     child: field(size, "Password", Icons.lock, _password),
//                 //   ),
//                 // ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//                   child: Container(
//                     height: size.height / 14,
//                     width: size.width / 1.1,
//                     child: Align(
//                       // child: field(size, "Password", Icons.lock, _password, isObscure = true),
//                       // child: TextField(
//                       //   keyboardType: TextInputType.text,
//                       //   controller: _password,
//                       //   obscureText: _isObscure,
//                       //   onChanged:  (value) => updateButtonState(value),
//                       // validator: (text) {
//                       //   print('\n\nPASSWORD TEXT\n\n');
//                       //   print(text);
//                       //   if (text != null) {
//                       //     if (!(text.length > 5) && text.isNotEmpty) {
//                       //       return "Enter valid name of more then 5 characters!";
//                       //     }
//                       //     return null;
//                       //   }
//                       //   else {
//                       //     return "NULL TEXT";
//                       //   }
//                       // },
//                       child: TextFormField(
//                         keyboardType: TextInputType.text,
//                         controller: _password,
//                         obscureText: _isObscure,
//                         validator: (value) {
//                           // add your custom validation here.
//                           if (value!.isEmpty) {
//                             return 'Please enter some text';
//                           }
//                           if (value.length < 3) {
//                             return 'Must be more than 2 charater';
//                           }
//                         },
//                         decoration: InputDecoration(
//                             prefixIcon: Icon(Icons.lock),
//                             // labelText: 'Password',
//                             // hintText: 'Password',
//                             labelText: 'Password',
//                             // errorText: validatePassword(_password.text),
//                             contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _isObscure
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _isObscure = !_isObscure;
//                                 });
//                               },
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             )
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: size.height / 20,
//                 ),
//                 customButton(size),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: GestureDetector(
//                 //     onTap: () => Navigator.pop(context),
//                 //     child: Text(
//                 //       "Login",
//                 //       style: TextStyle(
//                 //         color: Colors.redAccent,
//                 //         fontSize: 16,
//                 //         fontWeight: FontWeight.w500,
//                 //       ),
//                 //     ),
//                 //   ),
//                 // )
//               ],
//             ),
//           )
//       ),
//     );
//   }
//
//
//   Widget customButton(Size size) {
//     return GestureDetector(
//       onTap: () {
//         if (_name.text.isNotEmpty &&
//             _email.text.isNotEmpty &&
//             _password.text.isNotEmpty) {
//           setState(() {
//             isLoading = true;
//           });
//
//           createAccount(_name.text, _email.text, _password.text).then((user) {
//             print('Create account execute zalya nantar');
//             if (user != null) {
//               setState(() {
//                 isLoading = false;
//               });
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (_) => HomeScreen()));
//               print("Account Created Sucessfully");
//               Fluttertoast.showToast(
//                 msg: "Account Created Sucessfully",
//               );
//
//             } else {
//               print("Login Failed");
//               setState(() {
//                 isLoading = false;
//                 emailError = true;
//                 // Navigator.pop(context);
//               });
//             }
//           });
//         } else {
//           print("Please enter Fields");
//         }
//         // child: const Text('Show toast')
//       },
//       child: Container(
//           height: size.height / 14,
//           width: size.width / 1.2,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             color: Colors.redAccent,
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             "Create Account",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           )),
//     );
//   }
//
//   Widget email_field(
//       Size size, String hintText, IconData icon, TextEditingController cont) {
//     return Container(
//       height: size.height / 10,
//       width: size.width / 1.1,
//       child: TextField(
//         controller: cont,
//         decoration: InputDecoration(
//           // errorStyle: emailError ? TextStyle(color: Colors.red) : null,
//           // errorBorder: InputBorder(borderSide: BorderSide.none),
//           // errorStyle: emailError ? TextStyle(color: Colors.red) : TextStyle(color: Colors.black) ,
//           border: new OutlineInputBorder(
//             borderSide: new BorderSide(color: Colors.grey),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           errorText: emailError ? "Email already exists!" : ' ',
//           errorStyle: emailError ? TextStyle(color: Colors.red) : TextStyle(height: 0, color: Colors.transparent),
//           prefixIcon: Icon(icon),
//           labelText: hintText,
//           contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//           hintStyle: TextStyle(color: Colors.grey),
//           // border: OutlineInputBorder(
//           //   borderRadius: BorderRadius.circular(10),
//           // ),
//         ),
//       ),
//     );
//   }
//
//   Widget username_field(
//       Size size, String hintText, IconData icon, TextEditingController cont) {
//     return Container(
//       height: size.height / 10,
//       width: size.width / 1.1,
//       child: TextField(
//         controller: cont,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           labelText: hintText,
//           contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//           hintStyle: TextStyle(color: Colors.grey),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//       ),
//     );
//   }
// }
