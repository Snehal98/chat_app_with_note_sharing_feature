// import 'dart:convert';
// import 'dart:convert';
import 'dart:io';

import 'package:chat_app_va/Screens/SharedNotesScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:intl/intl.dart';
import 'NotesScreen.dart';
import 'addnote.dart';

class ChatRoom extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String time;
  final String chatRoomId;
  bool isshared;

  ChatRoom(this.chatRoomId, this.time, this.userMap, {required this.isshared});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Map<String, dynamic>? userMap;
  late bool isshared;
  Map<String, dynamic>? map;

  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  var data;



  File? imageFile;

  // get myTime => null;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatroom')
        .doc(widget.chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": _auth.currentUser!.displayName,
      "message": "",
      "type": "img",
      "time": FieldValue.serverTimestamp(),
    });

    var ref =
    FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();


      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }


  void onSendMessage() async {
    // _message.text = "${widget.title}\n\n${widget.description}";
    if (_message.text.isNotEmpty) {
      // if (widget.title == 'BLANK') {
        Map<String, dynamic> messages = {
          "sendby": _auth.currentUser!.displayName,
          "message": _message.text,
          // "message": widget.myTime,
          "type": "text",
          "time": FieldValue.serverTimestamp(),
        };

        _message.clear();
        await _firestore
            .collection('chatroom')
            .doc(widget.chatRoomId)
            .collection('chats')
            .add(messages);
      }
      // else {
      //   _message.text = "${widget.title}\n\n${widget.description}";
      //   Map<String, dynamic> messages = {
      //     "sendby": _auth.currentUser!.displayName,
      //     "message": _message.text,
      //     // "message": widget.myTime,
      //     "type": "text",
      //     "time": FieldValue.serverTimestamp(),
      //   };
      //   _message.clear();
      //   await _firestore
      //       .collection('chatroom')
      //       .doc(widget.chatRoomId)
      //       .collection('chats')
      //       .add(messages);
      // }
    // }
    //   else {
      // CollectionReference ref = FirebaseFirestore.instance.collection('users');
      // ref
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .collection('notes');
      //
      // await _firestore
      //     .collection('users')
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .collection('notes')
      //     .where('isshared', isEqualTo: 'false');
      // setState(() {
      //   isshared = true;
      // });
      //
      // ref.add(data);
      //
    // }

     else{
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {

    // String roomId = chatRoomId(
    //     _auth.currentUser!.displayName!,
    //     userMap!['name']);



    // title = widget.data['title'];
    // des = widget.data['description'];
    // var date = DateTime.fromMillisecondsSinceEpoch(Timestamp * 1000);
    // final size = MediaQuery.of(context).size;
    // final noteMap = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    // onSendMessage(viaNote: true, title: noteMap['title'], description: noteMap['description']);
    // print(noteMap);
    // print(noteMap!['title']);
    // if (noteMap == null) {
    //   noteMap = {'title':'Title', 'description':'description'};
    //   _message.text = "${noteMap['title']}\n\n${noteMap['des']}";
    // }
    // var title = "${widget.title}";
    // var desscription = "${widget.desscription}";


    final size = MediaQuery.of(context).size;

    ScrollController _scrollController = ScrollController();



    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: StreamBuilder<DocumentSnapshot>(
          stream:
          _firestore.collection("users").doc(widget.userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Row(
                  children: [
                    Container(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/images/girl.jpg'),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Container(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.userMap['name']),
                            SizedBox(
                              width: size.width / 20,
                            ),
                            Text(
                              snapshot.data!['status'],
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                    ),
                  ],

                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width ,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(widget.chatRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        //trial
                        // DateTime mydateTime = map!['time'].toDate();
                        // String formattedTime =
                        // DateFormat.yMMMd().add_jm().format(mydateTime);

                        //trial ends
                        return messages(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Expanded(
                        child:
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.5,
                      child: TextField(
                        expands: true,
                        maxLines: null,
                        minLines: null,
                        controller: _message,
                        // autofocus: true,
                        // maxLines: 5,
                        decoration: InputDecoration(
                            // suffixIcon: IconButton(
                            //   onPressed: () => getImage(),
                            //   icon: Icon(Icons.photo),
                            // ),
                            hintText: "Type your message here...",
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                        ),
                        // maxLines: 5,
                      ),
                    ),
                    ),

                    //TODO: Adjust floating popupmenu button
                    //TODO: Add message type = note
                    //TODO: Return card for shared note
                    //TODO: Refine onsendmessage function


                      PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              // child: Text("First"),
                              child: Row(
                          children: [
                                    IconButton(
                                        onPressed: () {
                                          // Navigator.of(context).pop();
                                          // String roomId = chatRoomId(
                                          //     _auth.currentUser!.displayName!,
                                          //     userMap!['name']);
                                          Navigator.of(context)
                                          // Navigator.pop(context,false)
                                              .push(
                                            MaterialPageRoute(
                                              builder: (context) => NotesScreen(widget.chatRoomId, widget.time, widget.userMap),
                                            ),
                                          )
                                              .then((value) {
                                            print("Calling Set State !");
                                            setState(() {});
                                          });
                                        },
                                        icon: Icon(Icons.notes)),


                                  SizedBox(
                                    width: size.width / 30,
                                  ),
                            // Text("Notes"),
                                  InkWell(
                                    child: Container(
                                      child: Text("Notes"),
                                    ),
                                    onTap: () {
                                      // String roomId = chatRoomId(
                                      //     _auth.currentUser!.displayName!,
                                      //     userMap!['name']);
                                      // Navigator.popAndPushNamed(context, "/NotesScreen");
                                      Navigator.of(context)
                                          .push(
                                        MaterialPageRoute(
                                          builder: (context) => NotesScreen(widget.chatRoomId, widget.time, widget.userMap),
                                        ),
                                      )
                                          .then((value) {
                                        print("Calling Set State !");
                                        setState(() {});
                                      });
                                    },
                                  ),
                                ],
                              ),
                              value: 1,
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  IconButton(onPressed: getImage, icon: Icon(Icons.photo)),

                                  SizedBox(
                                    width: size.width / 30,
                                  ),
                                  InkWell(
                                    child: Container(
                                    child: Text("Photos"),
                                  ),
                                    onTap: () => getImage(),
                                  ),
                            ],
                          ),
                              value: 2,
                            ),
                          ]
                      ),
                    // : Container(
                    //   child: Text(
                    //     "Hello"
                    //   ),
                    // ),
                    // Container(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       // Navigator.of(context).pop();
                    //       Navigator.of(context)
                    //           .push(
                    //         MaterialPageRoute(
                    //           builder: (context) => NotesScreen(),
                    //         ),
                    //       )
                    //           .then((value) {
                    //         print("Calling Set State !");
                    //         setState(() {});
                    //       });
                    //     },
                    //     child: Icon(
                    //       Icons.add,
                    //       size: 20.0,
                    //     ),
                    //     style: ButtonStyle(
                    //       backgroundColor: MaterialStateProperty.all(
                    //         Colors.purple[700],
                    //       ),
                    //       padding: MaterialStateProperty.all(
                    //         EdgeInsets.symmetric(
                    //           horizontal: 10.0,
                    //           vertical: 4.0,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    IconButton(
                        icon: Icon(Icons.send), onPressed: onSendMessage,
                    )
                  ],
                ),
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    // DateTime now = DateTime. now();
    // String formattedTime = DateFormat. Hms(). format(now);
    // var time = map['time']?? false;
    // DateTime mydateTime = map['time'].toDate();




    DateTime mydateTime = map['time'].toDate();
    // print(map);

    String formattedTime =
    DateFormat("h:mma").format(mydateTime);




    return map['type'] == "text"
        ? Container(
      width: size.width,
      // height: size.height,
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.redAccent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          Container(
            child: Text(
            map['message'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          ),
            Container(
              child: Text(
                formattedTime,
                // widget.time,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
                // textAlign: TextAlign.right,
                ),
              ),

          ],
        ),
      ),
    )
        : Container(
      height: size.height / 2.5,
      width: size.width,
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ShowImage(
              imageUrl: map['message'],
            ),
          ),
        ),
        child: Container(
          height: size.height / 2.5,
          width: size.width / 2,
          decoration: BoxDecoration(border: Border.all()),
          alignment: map['message'] != "" ? null : Alignment.center,
          child: map['message'] != ""
              ? Image.network(
            map['message'],
            fit: BoxFit.cover,
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
