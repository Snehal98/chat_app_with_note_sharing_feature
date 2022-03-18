import 'dart:io';

import 'package:chat_app_va/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ChatRoom.dart';
import '../Authenticate/Methods.dart';
import 'package:intl/intl.dart';

import 'allUsersList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // Map<String, dynamic>? userMap;
  Map<String, dynamic>? currentUser;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // var allUsers = [];
  final List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];

  var filteredUsers = [];
  List<Map<String, dynamic>> membersList = [];
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
    getAllUsers();
    _foundUsers = allUsers;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = allUsers;
    } else {
      results = allUsers
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  void getAllUsers() {
    userReference.get().then((value) {
      // print(value.docs[0].data());
      value.docs.forEach((element) {
        final thisUser = element.data() as Map<String, dynamic>;
        // print("Details of thisUser\n\n");
        // print(thisUser);
        if (thisUser.isNotEmpty && thisUser['uid'] != _auth.currentUser!.uid) {
          final userUid = thisUser['uid'];
          final userName = thisUser['name'];
          final userEmail = thisUser['email'];
          final userStatus = thisUser['status'];

          if (userName != null && userEmail != null) {
            allUsers.add({
              'uid': userUid,
              'name': userName,
              'email': userEmail,
              'status': userStatus
            });
          }
        }
      });
      // print("Details of allUsers");
      // print(allUsers);
      // allUsers.sort((a, b) {
      //   return a.value['name'].toString().toLowerCase().compareTo(b.value['name'].toString().toLowerCase());
      // });
    });
  }

  void getCurrentUserDetails() async {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      setState(() {
        membersList.add({
          "name": map['name'],
          "email": map['email'],
          "uid": map['uid'],
          "status": map['status'],
        });
      });
    });
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
// online
      setStatus("Online");
    } else {
// offline
      setStatus("Offline");
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

  // void onSearch() async {
  //   FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //   List<Map<String, dynamic>> results = [];
  //
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   // CollectionReference ref = FirebaseFirestore.instance
  //   //   .collection('users');
  //   //
  //   // for (var i = 0; i < ref.length; i++) {
  //   //   allUsers.add(ref.docs[i].data());
  //   // }
  //
  //   // if (_search.text.isNotEmpty) {
  //     await _firestore
  //         .collection('users')
  //         .where("name", isEqualTo: _search.text.toLowerCase())
  //         .get()
  //         .then((value) {
  //       setState(() {
  //         userMap = value.docs[0].data();
  //         // for (var i = 0; i < value.docs.length; i++) {
  //         //   allUsers.add(value.docs[i].data());
  //         // }
  //
  //         isLoading = false;
  //       });
  //       _search.clear();
  //       _foundUsers = allUsers;
  //       print(userMap);
  //     });
  //
  //   // } else {
  //   //   userMap == null;
  //   // //   users();
  //   // }
  //
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    dynamic currentTime = DateFormat.jm().format(DateTime.now());
// var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Home Screen"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: size.height / 35,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width / 20,
                  ),
                  Container(
                    height: size.height / 14,
                    width: size.width / 1.3,
                    alignment: Alignment.center,
                    child: Container(
                      height: size.height / 14,
                      width: size.width / 1.15,
                      child: TextField(
                        controller: _search,
                        decoration: InputDecoration(
                          hintText: "Find your friends here!",
                          contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) => _runFilter(value),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 20,
                  ),
                  Icon(
                    Icons.search,
                    color: Colors.redAccent,
                    size: 35,
                  )
                  // ElevatedButton(
                  //   // onPressed: onSearch,
                  //   child: Icon(
                  //     Icons.search_sharp,
                  //     size: 28.0,
                  //   ),
                  //   style: ButtonStyle(
                  //     alignment: Alignment.center,
                  //     backgroundColor: MaterialStateProperty.all(
                  //       Colors.redAccent,
                  //     ),
                  //     padding: MaterialStateProperty.all(
                  //       EdgeInsets.symmetric(
                  //         horizontal: 16.0,
                  //         vertical: 8.0,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          isLoading
              ? Center(
                  child: Container(
                    height: size.height / 20,
                    width: size.height / 20,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 80,
                      // bottom: 35,
                      // child: userMap != null ?
                      // child: userMap != null ?
                      // Container(
                      //         height: size.height / 14,
                      //         // width: size.width / 1.4,
                      //         width: size.width ,
                      //         alignment: Alignment.center,
                      //         child: ListTile(
                      //             onTap: () {
                      //               String roomId = chatRoomId(
                      //                   _auth.currentUser!.displayName!,
                      //                   userMap!['name']);
                      //
                      //               Navigator.of(context).push(
                      //                 MaterialPageRoute(
                      //                   builder: (_) => ChatRoom(
                      //                     roomId,
                      //                     currentTime,
                      //                     userMap!,
                      //                     // title: '',
                      //                     // description: '',
                      //                     isshared: false,
                      //                     // noteMap: {"Error": "HomeScreenerror"},
                      //                   ),
                      //                 ),
                      //               );
                      //               _search.clear();
                      //             },
                      //             leading: Icon(Icons.account_box,
                      //                 color: Colors.black, size: 35),
                      //             title: Text(
                      //               userMap!['name'],
                      //               // allUsers[2]['name'],
                      //               style: TextStyle(
                      //                 color: Colors.black,
                      //                 fontSize: 18,
                      //                 fontWeight: FontWeight.w500,
                      //               ),
                      //             ),
                      //             subtitle: Text(userMap!['email']),
                      //             trailing:
                      //                 // Icon(Icons.chat, color: Colors.black, size: 35),
                      //             Icon(
                      //                 Icons.chat,
                      //                 size: 35,
                      //                 color: Colors.black,
                      //             ),
                      //               // onPressed: () {}
                      //               // => onRemoveMembers(index)
                      //           )
                      //     )
                      child: SingleChildScrollView(
                              // padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                              child: Container(
                                  height: size.height / 1.32,
                                  width: size.width,

                                  // child: StreamBuilder<QuerySnapshot>(
                                  //   stream: _firestore.collection('users').snapshots(),
                                  //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                  //     if (snapshot.data != null) {
                                  //       return ListView.builder(
                                  //         itemCount: allUsers.length,
                                  //         itemBuilder: (context, index) {
                                  //           allUsers.sort((a, b) => a["name"].compareTo(b["name"]));
                                  //           return allUsersWidget(
                                  //                       size, allUsers[index], context, index);
                                  //         },
                                  //       );
                                  //     } else {
                                  //       return Container();
                                  //     }
                                  //   },
                                  // ),

                                  child: StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('users')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.data != null) {
                                        return ListView.builder(
                                          itemCount: _foundUsers.length,
                                          itemBuilder: (context, index) {
                                            _foundUsers.sort((a, b) =>
                                                a["name"].compareTo(b["name"]));
                                            return allUsersWidget(
                                                size,
                                                _foundUsers[index],
                                                context,
                                                index);
                                          },
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  )

                                  // child: ListView.builder(
                                  //   shrinkWrap: true,
                                  //   itemCount: allUsers.length,
                                  //   itemBuilder: (context, index) {
                                  //     return allUsersWidget(
                                  //         size, allUsers[index], context, index);
                                  //   },
                                  // ),
                                  ),
                            )
                    ),
                  ],
                )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.group),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GroupChatHomeScreen(),
          ),
        ),
      ),
    );
  }

  //
  // void onRemoveMembers(int index) {
  //   if (allUsers![index]['uid'] != _auth.currentUser!.uid) {
  //     setState(() {
  //       allUsers!.remove(index);
  //     });
  //   }
  // }

  //
  // Widget users() {
  //   final size = MediaQuery.of(context).size;
  //
  //
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: _firestore.collection('users').snapshots(),
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (snapshot.data != null) {
  //         return ListView.builder(
  //           itemCount: allUsers.length,
  //           itemBuilder: (context, index) {
  //             return allUsersWidget(
  //                 size, allUsers[index], context, index);
  //           },
  //         );
  //       } else {
  //         return Container();
  //       }
  //     },
  //   );
  // }

  Widget allUsersWidget(Size size, Map<String, dynamic> currentUser,
      BuildContext context, int index) {
    // print('\n\nCurrent User\n\n');
    // print(currentUser);
    dynamic currentTime = DateFormat.jm().format(DateTime.now());
    return ListTile(
      onTap: () {
        String roomId =
            chatRoomId(_auth.currentUser!.displayName!, currentUser['name']);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatRoom(
              roomId,
              currentTime,
              currentUser,
              // title: '',
              // description: '',
              isshared: false,
              // noteMap: {"Error": "HomeScreenerror"},
            ),
          ),
        );
        _search.clear();
        _foundUsers = allUsers;
      },
      leading: Icon(Icons.account_box, color: Colors.black, size: 35),
      title: Text(
        currentUser['name'],
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(currentUser['email']),
      trailing: Icon(
        Icons.chat,
        size: 35,
        color: Colors.black,
      ),
      // iconSize: 35,
      // color: Colors.black,
      // onPressed: () {}
      // => onRemoveMembers(index)
    );
  }
}
