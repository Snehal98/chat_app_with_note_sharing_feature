import 'dart:convert';
import 'dart:math';

import 'package:chat_app_va/Screens/ChatRoom.dart';

// import 'package:chat_app_va/Screens/displaynote.dart';
import 'package:chat_app_va/Screens/viewnote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'addnote.dart';
import 'display.dart';
import './ChatRoom.dart';

class NotesScreen extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String time;
  final String chatRoomId;

  // late final String chatRoomId;

  // NotesScreen(this.chatRoomId);
  // String roomId = '';

  // NotesScreen(this.roomId);
  // final Function onSendNote;
  // NotesScreen(this.onSendNote);
  // late final Map data;

  // NotesScreen(this.data);

  NotesScreen(this.chatRoomId, this.time, this.userMap);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  // Map<String, dynamic>? userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late bool isshared;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // final TextEditingController _message = TextEditingController();

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');

  // CollectionReference ref = FirebaseFirestore.instance
  //     .collection('chatroom')
  //     .doc(widget.chatRoomId)
  //     .collection('notes');
  //

  List<Color> myColors = [
    Colors.blue,
    Colors.amber,
    Colors.pink,
    Colors.green,
    Colors.lightBlueAccent,
    Colors.lightGreenAccent,
    Colors.amberAccent,
    Colors.pinkAccent,
    Colors.white54,
    Colors.purpleAccent,
    Colors.red,
    Colors.teal,
    Colors.tealAccent,
    Colors.cyan
  ];

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  Widget build(BuildContext context) {
/*
    CollectionReference ref = FirebaseFirestore.instance
    // await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('notes');

        Correct code
 */

    //
    // CollectionReference ref = FirebaseFirestore.instance
    //     .collection('chatroom')
    //     .doc(widget.chatRoomId)
    //     .collection('notes');

    // refe.add(data);

    // CollectionReference ref = FirebaseFirestore.instance
    //     .collection('chatroom')
    //     .doc(widget.chatRoomId)
    //     .collection('notes');
    //
    //
    // var data = {
    //   'title': title,
    //   'description': des,
    //   'created': DateTime.now(),
    // };
    //
    // ref.add(data);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddNote(),
            ),
          )
              .then((value) {
            print("Calling Set State !");
            setState(() {});
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white70,
        ),
        backgroundColor: Colors.grey[700],
      ),
      //

      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(
            fontSize: 32.0,
            fontFamily: "lato",
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        elevation: 0.0,
        backgroundColor: Color(0xff070706),
      ),
      //
      body: FutureBuilder<QuerySnapshot>(
        future: ref.get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.length == 0) {
              return Center(
                child: Text(
                  "You have no saved Notes !",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              );
            }
            // bool shared = true?
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Random random = new Random();

                Map? data = snapshot.data!.docs[index].data() as Map?;
                DateTime mydateTime = data!['created'].toDate();
                // isshared = data['isshared'];
                print('\n\nPrinting data\n\n');
                print(data);
                var myReference = snapshot.data!.docs[index].reference;
                print('\n\nPrinting reference\n\n');
                print(myReference);
                isshared = data['isshared'] ?? false;
                late Color bg;
                if (isshared)
                  bg = Colors.grey;
                else
                  bg = myColors[random.nextInt(6)];
                // String roomId = chatRoomId(
                //       _auth.currentUser!.displayName!,
                //       userMap!['name']);
                // final String title;
                // final String des;
                // late final Map data;
                // final String time;
                String formattedTime =
                    DateFormat.yMMMd().add_jm().format(mydateTime);
                // String sharednote = _message.text;
                // String title = 'mytitle';
                // String description = 'mydes';

                // String roomId = chatRoomId(
                //     _auth.currentUser!.displayName!,
                //     userMap?['name']);

                return InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => ViewNote(
                            data,
                            formattedTime,
                            snapshot.data!.docs[index].reference,
                          ),
                        ),
                      )
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: Column(
                      children: [
                        // Container(
                        //   child: Text(
                        //     sharednote
                        //   ),
                        // ),
                        Container(
                          child: Card(
                            color: bg,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${data['title']}",
                                    // sharednote,
                                    style: TextStyle(
                                      fontSize: 24.0,
                                      fontFamily: "lato",
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  //
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      formattedTime,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "lato",
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  // userMap != null?
                                  Container(
                                    // child: ElevatedButton(
                                    //   // onPressed: () {widget.onSendNote(noteMap: {"title": data['title'],
                                    //   //                                         "des": data['description']});},
                                    //
                                    //   // Below is the working onPressedFunction
                                    //   onPressed: () {
                                    //     print('Reference below:\n');
                                    //     print(snapshot
                                    //         .data!.docs[index].reference);
                                    //     snapshot.data!.docs[index].reference
                                    //         .update({'isshared': true});
                                    //     // data['isshared'] = true;
                                    //       Map<String, dynamic> myNote = {
                                    //         "sendby": _auth.currentUser!.displayName,
                                    //         "message": "${data['title']}\n\n${data['description']}\n",
                                    //         "type": "text",
                                    //         "time": FieldValue.serverTimestamp(),
                                    //       };
                                    //
                                    //       _firestore
                                    //           .collection('chatroom')
                                    //           .doc(widget.chatRoomId)
                                    //           .collection('chats')
                                    //           .add(myNote);
                                    //
                                    //     Navigator.of(context).push(
                                    //       MaterialPageRoute(
                                    //         builder: (context) => ChatRoom(
                                    //           widget.chatRoomId,
                                    //           widget.time,
                                    //           widget.userMap,
                                    //           title: data['title'] ?? 'BLANK',
                                    //           description:
                                    //               data['description'] ??
                                    //                   'BLANK',
                                    //           isshared: true,
                                    //         ),
                                    //       ),
                                    //       // MaterialPageRoute(
                                    //       //   builder: (context) => ChatRoom(
                                    //       //     // "31",
                                    //       //       roomId,
                                    //       //       '',
                                    //       //       userMap!,
                                    //       //       title: data['title'] ?? 'BLANK',
                                    //       //       description: data['description'] ?? 'BLANK'
                                    //       //   ),
                                    //       // )
                                    //     );
                                    //   },
                                    //
                                    //   // It ends here
                                    //
                                    //   // onPressed: () {
                                    //   //   Navigator.of(context).push(
                                    //   //     MaterialPageRoute(
                                    //   //       builder: (context) => widget.onSendNote(noteMap: {"title": data['title'],
                                    //   //               "des": data['description']}),
                                    //   //     ),
                                    //   //   );
                                    //   // },
                                    //
                                    //   // onPressed: () {
                                    //   //   // this is the button for sharing notes
                                    //   //   Navigator.of(context)
                                    //   //       .push(
                                    //   //     MaterialPageRoute(
                                    //   //       builder: (context) => Display(
                                    //   //         data,
                                    //   //         formattedTime,
                                    //   //         snapshot.data!.docs[index].reference,
                                    //   //       ),
                                    //   //     ),
                                    //   //   )
                                    //   //       .then((value) {
                                    //   //     setState(() {});
                                    //   //   });
                                    //   //   // Navigator.of(context).pop();
                                    //   // },
                                    //
                                    //   // onPressed: () {
                                    //   //   // this is the button for sharing notes
                                    //   //   Navigator.of(context)
                                    //   //       .push(
                                    //   //     MaterialPageRoute(
                                    //   //       builder: (context) => Display(
                                    //   //         data,
                                    //   //         formattedTime,
                                    //   //         snapshot.data!.docs[index].reference,
                                    //   //       ),
                                    //   //     ),
                                    //   //   )
                                    //   //       .then((value) {
                                    //   //     setState(() {});
                                    //   //   });
                                    //   //   // Navigator.of(context).pop();
                                    //   // },
                                    //
                                    //   child: Icon(
                                    //     Icons.arrow_forward_ios_outlined,
                                    //     size: 24.0,
                                    //   ),
                                    //   style: ButtonStyle(
                                    //     backgroundColor:
                                    //         MaterialStateProperty.all(
                                    //       Colors.purple,
                                    //     ),
                                    //     padding: MaterialStateProperty.all(
                                    //       EdgeInsets.symmetric(
                                    //         horizontal: 10.0,
                                    //         vertical: 4.0,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    child: IconButton(
                                        onPressed: () {
                                          print('Reference below:\n');
                                          print(snapshot
                                              .data!.docs[index].reference);
                                          snapshot.data!.docs[index].reference
                                              .update({'isshared': true});
                                          // data['isshared'] = true;

                                          //trial starts

                                          print('\n\nUSERMAP DETAILS\n\n');
                                          print(widget.userMap);

                                          var noteData = {
                                            'title': data['title'],
                                            'description':  data['description'],
                                            'created': DateTime.now(),
                                            'isshared': true,
                                          };

                                          CollectionReference ref = FirebaseFirestore.instance
                                          // await _firestore
                                              .collection('users')
                                              // .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .doc(widget.userMap['uid'])
                                              .collection('notes');

                                          ref.add(noteData);

                                          //trial ends



                                          Map<String, dynamic> myNote = {
                                            "sendby": _auth.currentUser!.displayName,
                                            "message": "${data['title']}\n\n${data['description']}\n",
                                            "type": "text",
                                            "time": FieldValue.serverTimestamp(),
                                          };

                                          _firestore
                                              .collection('chatroom')
                                              .doc(widget.chatRoomId)
                                              .collection('chats')
                                              .add(myNote);

                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ChatRoom(
                                                widget.chatRoomId,
                                                widget.time,
                                                widget.userMap,
                                                // title: data['title'] ?? 'BLANK',
                                                // description:
                                                // data['description'] ??
                                                //     'BLANK',
                                                isshared: true,
                                              ),
                                            ),
                                            // MaterialPageRoute(
                                            //   builder: (context) => ChatRoom(
                                            //     // "31",
                                            //       roomId,
                                            //       '',
                                            //       userMap!,
                                            //       title: data['title'] ?? 'BLANK',
                                            //       description: data['description'] ?? 'BLANK'
                                            //   ),
                                            // )
                                          );
                                        },
                                        icon: Icon(Icons.arrow_forward_ios)),
                                  ),
                                  // : Container(),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ));
              },
            );
          } else {
            return Center(
              child: Text("Loading..."),
            );
          }
        },
      ),
    );
  }
}
