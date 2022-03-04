import 'package:chat_app_va/group_chats/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // List<Text> allUsers = [];
  var allUsers = [];
  CollectionReference userReference = FirebaseFirestore.instance
    .collection('users');

// final List<String> users =  ;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
    getAllUsers();
  }

  void getAllUsers() {
    print('\n\n\nUSER REFERENCE');
    print(userReference);
    userReference.get().then((value) {
      print(value.docs[0].data());
      value.docs.forEach((element) {
        final currentUser = element.data() as Map<String, dynamic>;
        print(currentUser);
        if (currentUser != null) {
          final userName = currentUser['name'];
          final userEmail = currentUser['email'];
          final userWidget = Text('$userName \n\n $userEmail');
          allUsers.add(currentUser);
        }
        // final userName = currentUser?.['name'];
        // final TextUser = message.data['User'];
        // final MessageWeiget = Text('$TextMessage From $TextUser');
        // MessagesWeigets.add(MessageWeiget);
        // allUsers.add(element.data());
      });
      // print('\n\n\nALL USERS');
      // print(allUsers);
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


  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;

    });

    // CollectionReference ref = FirebaseFirestore.instance
    //   .collection('users');
    //
    // for (var i = 0; i < ref.length; i++) {
    //   allUsers.add(ref.docs[i].data());
    // }


    print("List of all the users");
    print(userMap);
    await _firestore
        .collection('users')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        // for (var i = 0; i < value.docs.length; i++) {
        //   allUsers.add(value.docs[i].data());
        // }

        isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    dynamic currentTime = DateFormat.jm().format(DateTime.now());
// var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Home Screen"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: size.height / 20,
                width: size.height / 20,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 30,
                ),

                Row(
                  children: [
                    SizedBox(
                      width: size.width / 20,
                    ),
                    Container(
                      height: size.height / 14,
                      width: size.width / 1.4,
                      alignment: Alignment.center,
                      child: Container(
                        height: size.height / 14,
                        width: size.width / 1.15,
                        child: TextField(
                          controller: _search,
                          decoration: InputDecoration(
                            hintText: "Find your friends here!!",
                            contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Column(
                    //   children: [
                    //     Container(
                    //           height: 90,
                    //         color: Colors.lightGreenAccent,
                    //         child: ListView.builder(
                    //             itemCount: allusers.length,
                    //             itemBuilder: (BuildContext context, int index) {
                    //               return Text(allusers[index]);
                    //             },
                    //         ),
                    //       ),
                    //   ],
                    // ),

                    // Container(
                    //     height: 90,
                    //   color: Colors.lightGreenAccent,
                    //   child: ListView.builder(
                    //       itemCount: allusers.length,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return Text(allusers[index]);
                    //       },
                    //   ),
                    // ),
                    SizedBox(
                      width: size.width / 40,
                    ),
                    ElevatedButton(
                      onPressed: onSearch,
                      // child: Text("Search"),
                      // style: ElevatedButton.styleFrom(
                      // primary: Colors.redAccent,
                      child: Icon(
                        Icons.search_sharp,
                        size: 28.0,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.redAccent,
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //       height: 90,
                    //     color: Colors.lightGreenAccent,
                    //     child: ListView.builder(
                    //         itemCount: allusers.length,
                    //         itemBuilder: (BuildContext context, int index) {
                    //           return Text(allusers[index]);
                    //         },
                    //     ),
                    // ),
                  ],
                ),
                SizedBox(
                  height: size.height / 30,
                ),

// this is the correct code
              allUsers != null ?
                  // ListView.builder(
                  //   itemCount: allUsers.length,
                  //     itemBuilder: (context, index) {
                  //       Container(
                  //         child: Text(
                  //           'HELLO'
                  //         )
                  //       );
                  //     })
              //
              // Column(
              //   children: List<Text>.from(allUsers),
              // )
              ListView.builder(
                // Let the ListView know how many items it needs to build.
                itemCount: allUsers.length,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  final item = allUsers[index];

                  return ListTile(
                    title: item['name'],
                    subtitle: item['email'],
                  );
                },
              )
              : userMap != null
                      ? ListTile(
                          onTap: () {
                          String roomId = chatRoomId(
                          _auth.currentUser!.displayName!,
                          userMap!['name']);

                            Navigator.of(context).push(
                            MaterialPageRoute(
                            builder: (_) => ChatRoom(
                            roomId,
                                currentTime,
                            userMap!,
                            // title: '',
                            // description: '',
                            isshared: false,
                            // noteMap: {"Error": "HomeScreenerror"},
                            ),
                            ),
                      );
                      },
                          leading: Icon(Icons.account_box, color: Colors.black, size: 50),
                          title: Text(
                          userMap!['name'],
                            // allUsers[2]['name'],
                          style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                      ),
                      ),
                          subtitle: Text(userMap!['email']),
                          trailing: Icon(Icons.chat, color: Colors.black, size: 50),

                      )
                    : Container(),
// this is the correct code

                // ListView (
                //   children: new List.generate(10,
                //   (index) => new ListTile(
                //   title: Text('Item $index'),
                //   ),
                //   ))

                   /* ListTile(

                    leading: Icon(Icons.account_box,
                    color: Colors.black, size: 50),
                    title: Text(
                    allUsers[user]['name'],
                    style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    ),
                    ),
                    subtitle: Text(allUsers[user]['email']),
                    trailing:
                    Icon(Icons.chat, color: Colors.black, size: 50),*/






                //trial
                //         : Container(
                //   child: ListView.builder(
                //       itemBuilder: users.get()
                //   ),
                // ),
                //trial ends here
                //starts here
                // ElevatedButton(
                //   onPressed: AllUsers(
                //       widget.chatRoomId,
                //       widget.time,
                //       widget.userMap
                //   ),
                //   // child: Text("Search"),
                //   // style: ElevatedButton.styleFrom(
                //   // primary: Colors.redAccent,
                //   child: Text(
                //     "List of users",
                // ),)


                //ends here

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
}

// correct code till line 250



//
// class ChatResult extends StatelessWidget {
//   final User user;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   ChatResult(this.user);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color:Colors.white,
//       child: Column(
//         children: <Widget>[
//           GestureDetector(
//             onTap: (){},
//             // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> ChatScreen(
//             //     username: user.displayName,
//             //     uuid: Uuid().v4().toString()))),
//             child:
//             ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 // backgroundImage: CachedNetworkImageProvider(user.photoUrl),
//               ),
//               title: Text(_auth.currentUser!.displayName!,
//                 style: TextStyle(fontWeight: FontWeight.bold
//                 ),
//               ),
//               subtitle: Text('message'),
//             ),
//           ),
//           Divider(
//             height: 2.0,
//             color: Colors.black,
//           ),
//         ],
//       ),
//     );
//   }
// }

// user.displayName

// return Scaffold(
//   appBar: AppBar(
//     title: Text("Home Screen"),
//     actions: [
//       IconButton(icon: Icon(Icons.logout), onPressed: () => logOut(context))
//     ],
//   ),

//
//       body: ListView.builder(
//           itemCount: 5,
//           itemBuilder: (BuildContext context,int index){
//             return ListTile(
//                 leading: Icon(Icons.list),
//                 trailing: Text("GFG",
//                   style: TextStyle(
//                       color: Colors.green,fontSize: 15),),
//                 title:Text("$userMap")
//             );
//           }
//       ),
//
//
//
//       // body: ListView.builder(
//       //     itemCount: 5,
//       //     itemBuilder: (BuildContext context, int index) {
//       //       return Card(
//       //
//       //         child: Padding(
//       //           padding: const EdgeInsets.all(15.0),
//       //           child: Column(
//       //             crossAxisAlignment: CrossAxisAlignment.start,
//       //             children: [
//       //               Text(
//       //                 "${userMap}",
//       //                 style: TextStyle(
//       //                   fontSize: 24.0,
//       //                   fontFamily: "lato",
//       //                   fontWeight: FontWeight.bold,
//       //                   color: Colors.black87,
//       //                 ),
//       //               ),
//       //           ],
//       //                   ),
//       //                 ),
//       //               );
//       //
//       //     }
//       //           )
//
//             );
//   }
//   }
//
//
// // body: isLoading
// //     ? Center(
// //   child: Container(
// //     height: size.height / 20,
// //     width: size.height / 20,
// //     child: CircularProgressIndicator(),
// //   ),
// // )
// //     : Column(
// //
// //       children: [
// //         SizedBox(
// //           height: size.height / 30,
// //         ),
// //
// //         Row(
// //           children:[
// //           SizedBox(
// //         width: size.width / 20,
// //       ),
// //             Container(
// //               height: size.height / 14,
// //               width: size.width / 1.4,
// //               alignment: Alignment.center,
// //               child: Container(
// //                 height: size.height / 14,
// //                 width: size.width / 1.15,
// //                 child: TextField(
// //                   controller: _search,
// //                   decoration: InputDecoration(
// //                     hintText: "Find your friends here!!",
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(
// //               width: size.width / 40,
// //             ),
// //             ElevatedButton(
// //               onPressed: onSearch,
// //               child: Text("Search"),
// //             ),
// //           ],
// //         ),
// //          SizedBox(
// //               height: size.height / 30,
// //             ),
//
//   //
//   // ListTile(
//   // leading: Icon(Icons.list),
//   // trailing: Text("${userMap!['name']}",
//   // style: TextStyle(
//   // color: Colors.green, fontSize: 15
//   // ),
//   // ),
//   // title: Text("List item $index");
//   //
//   // child:
