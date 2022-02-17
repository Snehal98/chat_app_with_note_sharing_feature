import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class Display extends StatefulWidget {
  // const Display({Key? key}) : super(key: key);
  final Map data;
  final String time;
  final DocumentReference ref;

  Display(this.data, this.time, this.ref);

  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  late String title;
  late String des;

  bool edit = false;
  @override
  Widget build(BuildContext context) {
    title = widget.data['title'];
    des = widget.data['description'];
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontFamily: "lato",
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  //
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 24.0,
                    ),
                    child: Text(
                      widget.time,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "lato",
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  //

                  Text(
                    des,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: "lato",
                      color: Colors.black87,
                    ),
                  ),
                ]
       ),
      ),
      color: Colors.amberAccent,
      elevation: 10,
      margin: EdgeInsets.fromLTRB(100.0, 100.0, 10.0, 100.0),
    );
  }
}







