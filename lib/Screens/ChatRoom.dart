// import 'dart:convert';
// import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:chat_app_va/Authenticate/Methods.dart';
import 'package:chat_app_va/Screens/SharedNotesScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  static const double infinity = 1.0 / 0.0;
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

    else {
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


    ScrollController _scrollController = ScrollController(initialScrollOffset: 7000);
    // void _scrollToBottom() {
    //   if (_scrollController.hasClients) {
    //     _scrollController.animateTo(_scrollController.position.maxScrollExtent,
    //         duration: Duration(milliseconds: 300), curve: Curves.elasticOut);
    //   } else {
    //     Timer(Duration(milliseconds: 400), () => _scrollToBottom());
    //   }
    // }
    //
    // WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToBottom());

    isBottom() {
      print('\n\nISBOTTOM:\n');
      if (_scrollController.hasClients) {
        print('\n\nSC_Position:\n');
        print(_scrollController.position.pixels);
        print(_scrollController.position.maxScrollExtent);
        if (_scrollController.position.pixels != _scrollController.position.maxScrollExtent) {
          return true;
        }
        return false;
      }
      print('\n\nISBOTTOM EXITED:\n');
      return false;
    }


    return Scaffold(

      // floatingActionButton: isBottom()
      //     ? FloatingActionButton(
      //     backgroundColor: Colors.grey,
      //     splashColor: Colors.redAccent,
      //     tooltip: 'Scroll to Bottom',
      //     child: Icon(Icons.arrow_downward),
      //     onPressed: () =>
      //     {
      //       isBottom(),
      //       _scrollController.jumpTo(_scrollController.position.maxScrollExtent)
      //     }) :
      // null,

        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.grey,
        //   splashColor: Colors.redAccent,
        //   tooltip: 'Scroll to Bottom',
        //   child: Icon(Icons.arrow_downward),
        //   onPressed: () =>
        //   {
        //     isBottom(),
        //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent)
        //   }) ,



        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: StreamBuilder<DocumentSnapshot>(
            stream: _firestore
                .collection("users")
                .doc(widget.userMap['uid'])
                .snapshots(),
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
                        child: Column(
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
                      SizedBox(
                        width: size.width / 2.5,
                      ),
                      IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),


        // Body started

        body: Stack(
          children: [

            // First Container containing singlechildscrollview

              SingleChildScrollView(
                // controller: _scrollController,
                child: Column(
                  children: [
                    Container(
                      height: size.height / 1.28,
                      width: size.width,
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
                              controller: _scrollController,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {

                                // Map? map = snapshot.data!.docs[index].data() as Map?;
                                // DateTime mydateTime = data!['created'].toDate();


                                Map<String, dynamic> map =
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>;


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
                    //ithun cut kelela
                  ],
                ),
              ),

              Stack(
                children: [
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.white,
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
                                child: Container(
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
                                      value: 1,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                            child: Icon(Icons.notes),
                                          ),
                                          Text("Notes"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 2,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                            child: Icon(Icons.photo),
                                          ),
                                          Text("Photos"),
                                        ],
                                      ),
                                    ),
                                  ],
                                      onSelected: (int menu) {
                                      if (menu == 1) {
                                        Navigator.of(context)
                                            .push(
                                          MaterialPageRoute(
                                            builder: (context) => NotesScreen(
                                                widget.chatRoomId,
                                                widget.time,
                                                widget.userMap),
                                          ),
                                        );
                                      }
                                      else if (menu == 2) {
                                        getImage();
                                      }
                                },
                              ),

                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: onSendMessage,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ]
              )
            // second container

          ],
        ),

    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    // DateTime now = DateTime. now();
    // String formattedTime = DateFormat. Hms(). format(now);
    // var time = map['time']?? false;
    // DateTime mydateTime = map['time'].toDate();
    // trial

    // isshared = data['isshared'] ?? false;
    // late Color bg;
    // if (isshared)
    //   bg = Colors.grey;
    // else
    //   bg = Colors.redAccent;

    String stringtime = map['time'] == null
        ? DateTime.now().toString()
        : map['time'].toDate().toString();
    // stringtime = widget.time.toDate().toString();
    // DateTime date = DateTime.parse(stringtime);
    // String clocktime = DateFormat('hh:mm a').format(date);

    // trial


    // DateTime mydateTime = map['time'].toDate();
    // print(map);


    DateTime date = DateTime.parse(stringtime);
    String formattedTime = DateFormat("h:mma").format(date);

    return map['type'] == "text"
        ? GestureDetector(
      // onLongPress: showMenu(
      //     context: context,
      //     position: position,
      //     items: <PopupMenuEntry>[
      // PopupMenuItem(
      // value: 10,
      //     child: Row(
      //       children: <Widget>[
      //         Icon(Icons.delete),
      //         Text("Delete"),
      //       ]
      //     )
      // )
      //     ]
      // ),
      child: Container(
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
    )
        : map['type'] == "note" ?
    Container(
      width: size.width,
      // height: size.height,
      alignment: map['sendby'] == _auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(
            // border: Border.all(),
          boxShadow: [BoxShadow(
            color: Colors.grey,
            offset: const Offset(
              2.0,
              2.0,
            ),
            blurRadius: 4.0,
            spreadRadius: 1.0,
          )],
          borderRadius: BorderRadius.circular(15),
          color: Colors.greenAccent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        Icons.notes,
                      color: Colors.redAccent,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                      child: Text(
                  'NOTE',
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.redAccent,
                  ),
                ),
                    )
                  ],
            ),
              ),
    // decoration: BoxDecoration(
    //   border: Border.all(),
    //     borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
    // ),
            ),

            Container(
              child: Text(
                map['message'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              child: Text(
                formattedTime,
                // widget.time,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black,
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
