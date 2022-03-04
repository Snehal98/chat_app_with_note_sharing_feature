// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import 'ChatRoom.dart';
//
//
// class AllUsers extends StatefulWidget {
//   final Map<String, dynamic> userMap;
//   final String time;
//   final String chatRoomId;
//
//   AllUsers(this.userMap, this.time, this.chatRoomId);
//
//   @override
//   _AllUsersState createState() => _AllUsersState();
// }
//
// class _AllUsersState extends State<AllUsers> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   CollectionReference ref = FirebaseFirestore.instance
//       .collection('users');
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: FutureBuilder<QuerySnapshot>(
//           future: ref.get(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               if (snapshot.data!.docs.length == 0) {
//                 return Center(
//                   child: Text(
//                     "You have no users!",
//                     style: TextStyle(
//                       color: Colors.white70,
//                     ),
//                   ),
//                 );
//               }
//               return ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (_) => ChatRoom(
//                               widget.chatRoomId,
//                               widget.time,
//                               widget.userMap!,
//                               // title: '',
//                               // description: '',
//                               isshared: false,
//                               // noteMap: {"Error": "HomeScreenerror"},
//                             ),
//                           ),
//                         )
//                             .then((value) {
//                           setState(() {});
//                         });
//                       },
//                       child: ListTile(
//                         onTap: () {
//
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => ChatRoom(
//                                 widget.chatRoomId,
//                                 widget.time,
//                                 widget.userMap!,
//                                 // title: '',
//                                 // description: '',
//                                 isshared: false,
//                                 // noteMap: {"Error": "HomeScreenerror"},
//                               ),
//                             ),
//                           );
//                         },
//                         leading: Icon(Icons.account_box, color: Colors.black, size: 50),
//                         title: Text(
//                           widget.userMap!['name'],
//                           // allUsers[2]['name'],
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         subtitle: Text(widget.userMap!['email']),
//                         trailing: Icon(Icons.chat, color: Colors.black, size: 50),
//
//                       ),
//                     );
//                   }
//               );
//             } else {
//               return Center(
//                 child: Text("Loading..."),
//               );
//             }
//
//           }
//       ),
//     );
//   }
// }
