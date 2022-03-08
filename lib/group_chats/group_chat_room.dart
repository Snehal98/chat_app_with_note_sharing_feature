import 'dart:async';
import 'dart:io';

import 'package:chat_app_va/Authenticate/Methods.dart';
import 'package:chat_app_va/Screens/NotesScreen.dart';
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

import 'group_info.dart';

class GroupChatRoom extends StatefulWidget {
  final String groupChatId, groupName;
  // final Map<String, dynamic> userMap;
  // final String time;
  // bool isshared;
  // required this.time, required this.userMap, required this.isshared

  GroupChatRoom({required this.groupName, required this.groupChatId, Key? key})
      : super(key: key);


  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, dynamic>? userMap;
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
        .collection('group')
        .doc(widget.groupChatId)
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
          .collection('group')
          .doc(widget.groupChatId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('group')
          .doc(widget.groupChatId)
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
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();

      await _firestore
          .collection('groups')
          .doc(widget.groupChatId)
          .collection('chats')
          .add(chatData);



      //trial strats
      // await _firestore
      //     .collection('users')
      //     .where("name", isEqualTo: _auth.currentUser!.displayName)
      //     .get()
      //     .then((value) {
      //   setState(() {
      //     userMap = value.docs[0].data();
      //     // for (var i = 0; i < value.docs.length; i++) {
      //     //   allUsers.add(value.docs[i].data());
      //     // }
      //
      //     // isLoading = false;
      //   });
      //   print(userMap);
      // });

      // Map<String, dynamic>? userMap =  _auth.currentUser as Map<String, dynamic>?;



    //  trial ends
    }
  }
  // Future<void> _getUserName() async {
  //   Firestore.instance
  //       .collection('Users')
  //       .document((await FirebaseAuth.instance.currentUser!).uid)
  //       .get()
  //       .then((value) {
  //     setState(() {
  //       userMap = value.docs();
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // Map<String, dynamic> userMap = _auth.currentUser as Map<String, dynamic>;
    // print(userMap);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(widget.groupName),
          actions: [
            IconButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GroupInfo(
                          groupName: widget.groupName,
                          groupId: widget.groupChatId,
                        ),
                      ),
                    ),
                icon: Icon(Icons.more_vert)),
          ],
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height / 1.27,
                  width: size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('groups')
                        .doc(widget.groupChatId)
                        .collection('chats')
                        .orderBy('time')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> chatMap =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;

                            return messageTile(size, chatMap, context);
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
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
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
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
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 10, 0),
                                      child: Icon(Icons.photo),
                                    ),
                                    Text("Photos"),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (int menu) {
                              if (menu == 1) {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => NotesScreen(
                                //         widget.groupChatId,
                                //         // widget.time,
                                //         "",
                                //         ,
                                //     ),
                                //   ),
                                // );
                              } else if (menu == 2) {
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
            ],
          ),
        ])

        // trial starts

//       body: Stack(
//         children: [
//
//           // First Container containing singlechildscrollview
//
//           SingleChildScrollView(
//             // controller: _scrollController,
//             child: Column(
//               children: [
//                 Container(
//                   height: size.height / 1.28,
//                   width: size.width,
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: _firestore
//                         .collection('group')
//                         .doc(widget.groupChatId)
//                         .collection('chats')
//                         .orderBy("time", descending: false)
//                         .snapshots(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<QuerySnapshot> snapshot) {
//                       if (snapshot.hasData) {
//                         return ListView.builder(
//                           // controller: _scrollController,
//                           itemCount: snapshot.data!.docs.length,
//                           itemBuilder: (context, index) {
//
//                             // Map? map = snapshot.data!.docs[index].data() as Map?;
//                             // DateTime mydateTime = data!['created'].toDate();
//
//
//                             Map<String, dynamic> chatMap =
//                             snapshot.data!.docs[index].data()
//                             as Map<String, dynamic>;
//
//
//                             //trial
//                             // DateTime mydateTime = map!['time'].toDate();
//                             // String formattedTime =
//                             // DateFormat.yMMMd().add_jm().format(mydateTime);
//
//                             //trial ends
//                             return messageTile(size, chatMap, context);
//                           },
//                         );
//                       } else {
//                         return Container();
//                       }
//                     },
//                   ),
//                 ),
//                 //ithun cut kelela
//               ],
//             ),
//           ),
//
//           Stack(
//               children: [
//                 Positioned(
//                   left: 0,
//                   bottom: 0,
//                   child: Container(
//                     color: Colors.white,
//                     height: size.height / 10,
//                     width: size.width,
//                     alignment: Alignment.center,
//                     child: Align(
//                       alignment: Alignment.centerLeft,
//                       child: Container(
//                         height: size.height / 12,
//                         width: size.width / 1.1,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: size.width / 20,
//                             ),
//                             Expanded(
//                               child: Container(
//                                 height: size.height / 17,
//                                 width: size.width / 1.5,
//                                 child: TextField(
//                                   expands: true,
//                                   maxLines: null,
//                                   minLines: null,
//                                   controller: _message,
// // autofocus: true,
// // maxLines: 5,
//                                   decoration: InputDecoration(
// // suffixIcon: IconButton(
// //   onPressed: () => getImage(),
// //   icon: Icon(Icons.photo),
// // ),
//                                     hintText: "Type your message here...",
//                                     contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
// // maxLines: 5,
//                                 ),
//                               ),
//                             ),
//
// //TODO: Adjust floating popupmenu button
// //TODO: Add message type = note
// //TODO: Return card for shared note
// //TODO: Refine onsendmessage function
//
//                             PopupMenuButton(
//                               itemBuilder: (context) => [
//                                 PopupMenuItem(
//                                   value: 1,
//                                   child: Row(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.fromLTRB(0,0,10,0),
//                                         child: Icon(Icons.notes),
//                                       ),
//                                       Text("Notes"),
//                                     ],
//                                   ),
//                                 ),
//                                 PopupMenuItem(
//                                   value: 2,
//                                   child: Row(
//                                     children: [
//                                       Padding(
//                                         padding: const EdgeInsets.fromLTRB(0,0,10,0),
//                                         child: Icon(Icons.photo),
//                                       ),
//                                       Text("Photos"),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                               // onSelected: (int menu)
//                               // {
//                               //   if (menu == 1) {
//                               //     Navigator.of(context)
//                               //         .push(
//                               //       MaterialPageRoute(
//                               //         builder: (context) => NotesScreen(
//                               //             widget.groupChatId,
//                               //             // widget.time,
//                               //             // widget.userMap),
//                               //       ),
//                               //     );
//                               //   }
//                               //   else if (menu == 2) {
//                               //     getImage();
//                               //   }
//                               // },
//                             ),
//
//                             IconButton(
//                               icon: Icon(Icons.send),
//                               onPressed: onSendMessage,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ]
//           )
//           // second container
//
//         ],
//       ),

        // trial ends

        );
  }

  Widget messageTile(
      Size size, Map<String, dynamic> chatMap, BuildContext context) {
    // return Builder(builder: (_)
    // {
    if (chatMap['type'] == "text") {
      return Container(
        width: size.width,
        alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
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
              children: [
                Text(
                  chatMap['sendBy'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: size.height / 200,
                ),
                Text(
                  chatMap['message'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      );
    } else if (chatMap['type'] == "img") {
      return Container(
        width: size.width,
        alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          height: size.height / 2,
          child: Image.network(
            chatMap['message'],
          ),
        ),
      );
    } else if (chatMap['type'] == "notify") {
      return Container(
        width: size.width,
        alignment: Alignment.center,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black38,
          ),
          child: Text(
            chatMap['message'],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
  // );
}
// }

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
