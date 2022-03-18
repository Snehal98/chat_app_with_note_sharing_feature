import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AddNote extends StatefulWidget {


  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late String title;
  late String des;
  final _formKey = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
              12.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        size: 24.0,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[700],
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                    //
                    ElevatedButton(
                      // onPressed: add,
                      onPressed: () {
                        add();
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                          });
                        } else {
                          Fluttertoast.showToast(
                            msg: "Note Created Sucessfully",
                          );
                          setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                          content: Text('Note Unsuccessfull')),
                          );
                        });
                      }
                        },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: "lato",
                          color: Colors.white,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey[700],
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 25.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //
                SizedBox(
                  height: 12.0,
                ),
                //
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Title",
                        ),
                        validator: (title) {
                          // add your custom validation here.
                          if (title!.isEmpty) {
                            return 'Title cannot be empty';
                          }
                        },
                        style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: "lato",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        onChanged: (_val) {
                          title = _val;
                        },
                      ),
                      //
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        padding: const EdgeInsets.only(top: 12.0),
                        child: TextFormField(
                          decoration: InputDecoration.collapsed(
                            hintText: "Note Description",
                          ),
                          validator: (des) {
                            // add your custom validation here.
                            if (des!.isEmpty) {
                              return 'Description cannot be empty';
                            }
                          },
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "lato",
                            color: Colors.grey,
                          ),
                          onChanged: (_val) {
                            des = _val;
                          },
                          maxLines: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void add() async {

    var data = {
      'title': title,
      'description': des,
      'created': DateTime.now(),
      'isshared': false,
      'myself': true,
    };



    CollectionReference ref = FirebaseFirestore.instance
    // await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes');

    ref.add(data);


    // save to db
    // CollectionReference ref = FirebaseFirestore.instance
    //     .collection('chatroom')
    //     .doc(widget.chatRoomId)
    //     .collection('notes');

    // var data = {
    //   'title': title,
    //   'description': des,
    //   'created': DateTime.now(),
    // };

    // ref.add(data);


    // await _firestore
    //     .collection('chatroom')
    //     .doc(widget.chatRoomId)
    //     .collection('notes')
    //     .set({'title': title,
    //   'description': des,
    //   'created': DateTime.now(),
    // });

    Navigator.pop(context);
  }
}
