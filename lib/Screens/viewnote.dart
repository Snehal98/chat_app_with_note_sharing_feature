import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'ChatRoom.dart';

class ViewNote extends StatefulWidget {
  final Map data;
  late final String time;
  final DocumentReference ref;
  final Map<String, dynamic> userMap;
  final String chatRoomId;

  ViewNote(this.data, this.time, this.ref, this.chatRoomId, this.userMap);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  late String title;
  late String des;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // late String newtime;

  bool edit = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    title = widget.data['title'];
    des = widget.data['description'];
    ValueNotifier<bool> isDialOpen = ValueNotifier(false);
    // newtime = DateTime.now();

    // floatingActionButton: edit
    //     ? FloatingActionButton(
    //   onPressed: save,
    //   child: Icon(
    //     Icons.save_rounded,
    //     color: Colors.white,
    //   ),
    //   backgroundColor: Colors.grey[700],
    // )
    //     : null;

    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },

      // return SafeArea(
      child: Scaffold(
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          openCloseDial: isDialOpen,
          backgroundColor: Colors.redAccent,
          overlayColor: Colors.grey,
          overlayOpacity: 0.5,
          spacing: 15,
          spaceBetweenChildren: 15,
          closeManually: false,
          children: widget.data['isshared'] ?
          [SpeedDialChild(
              child: Icon(Icons.share_rounded),
              label: 'Share',
              backgroundColor: Colors.blue,
              onTap: () {
                Map<String, dynamic> myNote = {
                  "sendby": _auth.currentUser!.displayName,
                  "message": "${widget.data['title']}\n\n${widget.data['description']}\n",
                  "type": "note",
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
                );
                print('Share Tapped');
              }),
          SpeedDialChild(
              child: Icon(Icons.delete),
              label: 'Delete',
              onTap: delete
            // print('Delete Tapped');
          )] : edit ? [
            SpeedDialChild(
              onTap: save,
              child: Icon(
                Icons.save_rounded,
                color: Colors.white,
              ),
              backgroundColor: Colors.grey[700],
              // resizeToAvoidBottomInset: false,
            )] :
          [SpeedDialChild(
                child: Icon(Icons.share_rounded),
                label: 'Share',
                backgroundColor: Colors.blue,
                onTap: () {
                  Map<String, dynamic> myNote = {
                    "sendby": _auth.currentUser!.displayName,
                    "message": "${widget.data['title']}\n\n${widget.data['description']}\n",
                    "type": "note",
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
                  );
                  print('Share Tapped');
                }),
            SpeedDialChild(
                child: Icon(Icons.edit),
                label: 'Edit',
                onTap: () {
                  setState(() {
                    edit = !edit;
                  });
                  print('Edit Tapped');
                }),
            SpeedDialChild(
                child: Icon(Icons.delete),
                label: 'Delete',
                onTap: delete
              // print('Delete Tapped');
            )
          ],
        ),
        //
        // floatingActionButton: edit
        //     ? FloatingActionButton(
        //   onPressed: save,
        //   child: Icon(
        //     Icons.save_rounded,
        //     color: Colors.white,
        //   ),
        //   backgroundColor: Colors.grey[700],
        // )
        //     : null,
        // //
        // resizeToAvoidBottomInset: false,
        //
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Notes",
            style: TextStyle(
              fontSize: 32.0,
              fontFamily: "lato",
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
              15.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // SizedBox(
                //   height: 10.0,
                // ),
                Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Title",
                        ),
                        style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: "lato",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['title'],
                        enabled: edit,
                        onChanged: (_val) {
                          title = _val;
                          print("Title " + title);
                          widget.data['title'] = title;
                          // DateTime newtime = DateTime.now();
                          // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(newtime);
                        },
                        validator: (_val) {
                          if (_val!.isEmpty) {
                            return "Can't be empty !";
                          } else {
                            return null;
                          }
                        },
                      ),

                      //
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 12.0,
                        ),
                        child: Text(
                          widget.time,
                          // newtime,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "lato",
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Note Description",
                        ),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "lato",
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['description'],
                        enabled: edit,
                        onChanged: (_val) {
                          des = _val;
                          widget.data['description'] = des;
                          // widget.time = DateTime.now() as String;
                        },
                        maxLines: 20,
                        validator: (_val) {
                          if (_val!.isEmpty) {
                            return "Can't be empty !";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),

                // PopupMenuButton(
                //             // Navigator.pop(context),
                //             // color: Colors.redAccent,
                //             // shape: RoundedRectangleBorder(
                //             //     borderRadius: BorderRadius.all(Radius.circular(15.0))
                //             // ),
                //             itemBuilder: (context) =>
                //             [
                //               PopupMenuItem(
                //                 child: Row(
                //                   children: [
                //                     ElevatedButton(
                //                       onPressed: () {
                //                         setState(() {
                //                           edit = !edit;
                //                         });
                //                       },
                //                       child: Icon(
                //                         Icons.edit,
                //                         size: 24.0,
                //                         color: Colors.redAccent,
                //                       ),
                //                       style: ButtonStyle(
                //                         backgroundColor: MaterialStateProperty.all(
                //                           Colors.white,
                //                         ),
                //                         padding: MaterialStateProperty.all(
                //                           EdgeInsets.symmetric(
                //                             horizontal: 15.0,
                //                             vertical: 8.0,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     SizedBox(
                //                       width: size.width / 30,
                //                     ),
                //                     InkWell(
                //                       child: Container(
                //                         child: Text("Edit"),
                //                       ),
                //                       onTap: () {
                //                         setState(() {
                //                           edit = !edit;
                //                         });
                //                         // Navigator.pop(context);
                //                       },
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //               PopupMenuItem(
                //                 child: Row(
                //                   children: [
                //                     ElevatedButton(
                //                       onPressed: delete,
                //                       child: Icon(
                //                         Icons.delete_forever,
                //                         size: 24.0,
                //                         color: Colors.redAccent,
                //                       ),
                //                       style: ButtonStyle(
                //                         backgroundColor: MaterialStateProperty.all(
                //                           Colors.white,
                //                         ),
                //                         padding: MaterialStateProperty.all(
                //                           EdgeInsets.symmetric(
                //                             horizontal: 15.0,
                //                             vertical: 8.0,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     SizedBox(
                //                       width: size.width / 30,
                //                     ),
                //                     InkWell(
                //                       child: Container(
                //                         child: Text("Delete"),
                //                       ),
                //                       onTap: () => delete(),
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //
                //             ]),
                //
                // SizedBox(
                //   height: 15.0,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void delete() async {
    // delete from db
    await widget.ref.delete();
    Navigator.pop(context);
  }

  void save() async {
    print("Inside save function");
    if (key.currentState!.validate()) {
      // TODo : showing any kind of alert that new changes have been saved
      print("Saving the changes...");
      print("Title inside save " + title);
      await widget.ref.update(
        {'title': title, 'description': des},
      );
      print("Changes saved!");
      edit = !edit;
      // Navigator.of(context).pop();
      Navigator.pop(context);
    }
  }
}
