//Currently this screen is not being used

// import 'dart:math';
// import 'package:chat_app_va/Screens/viewsharednote.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import 'addnote.dart';
//
//
//
// class SharedNotes extends StatefulWidget {
//   const SharedNotes({Key? key}) : super(key: key);
//
//   @override
//   _SharedNotesState createState() => _SharedNotesState();
// }
//
// class _SharedNotesState extends State<SharedNotes> {
//   Map<String, dynamic>? userMap;
//
//   CollectionReference refe = FirebaseFirestore.instance
//       .collection('users')
//       .doc(FirebaseAuth.instance.currentUser!.uid)
//       .collection('sharednotes');
//
//   List<Color> myColors = [
//     Colors.blue,
//     Colors.amber,
//     Colors.pink,
//     Colors.green,
//     Colors.lightBlueAccent,
//     Colors.lightGreenAccent,
//     Colors.amberAccent,
//     Colors.pinkAccent,
//     Colors.white54,
//     Colors.purpleAccent,
//     Colors.red,
//     Colors.teal,
//     Colors.tealAccent,
//     Colors.cyan
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         //   Navigator.of(context)
//         //       .push(
//         //     MaterialPageRoute(
//         //       builder: (context) => AddNote(),
//         //     ),
//         //   )
//         //       .then((value) {
//         //     print("Calling Set State !");
//         //     setState(() {});
//         //   });
//         // },
//
//         child: Icon(
//           Icons.add,
//           color: Colors.white70,
//         ),
//         backgroundColor: Colors.grey[700],
//       ),
//         appBar: AppBar(
//           title: Text(
//             "Shared Notes",
//             style: TextStyle(
//               fontSize: 32.0,
//               fontFamily: "lato",
//               fontWeight: FontWeight.bold,
//               color: Colors.white70,
//             ),
//           ),
//           elevation: 0.0,
//           backgroundColor: Color(0xff070706),
//         ),
//       body: FutureBuilder<QuerySnapshot>(
//           future: refe.get(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               if (snapshot.data!.docs.length == 0) {
//                 return Center(
//                   child: Text(
//                     "You have no saved Notes !",
//                     style: TextStyle(
//                       color: Colors.white70,
//                     ),
//                   ),
//                 );
//               }
//
//               return ListView.builder(
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     Random random = new Random();
//                     Color bg = myColors[random.nextInt(6)];
//                     Map? sharednotedata = snapshot.data!.docs[index].data() as Map?;
//                     // Map<String, dynamic> map = snapshot.data!.docs[index]
//                     //     .data() as Map<String, dynamic>;
//                     // DateTime mydateTime = sharednotedata!['created'].toDate();
//                     // DateTime mydateTime = map['created'].toDate();
//
//                     // // Just for trial
//                     // final DateFormat formatter = DateFormat('yyyy-MM-dd');
//                     // final String formatted = formatter.format(mydateTime);
//                     // It ends here
//
//
//                     // String formattedTime =
//                     // DateFormat.yMMMd().add_jm().format(mydateTime);
//
//                     return InkWell(
//                         onTap: () {
//                           Navigator.of(context)
//                               .push(
//                             MaterialPageRoute(
//                               builder: (context) => ViewSharedNote(
//                                 sharednotedata!,
//                                 "time",
//                                 // formattedTime,
//                                 snapshot.data!.docs[index].reference,
//                               ),
//                             ),
//                           )
//                               .then((value) {
//                             setState(() {});
//                           });
//                         },
//                         child: Column(
//                           children: [
//                             Container(
//                               child: Card(
//                                 color: bg,
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Container(
//                                         alignment: Alignment.centerLeft,
//                                         child: Text(
//                                           // "${data['title']}",
//                                           // "${sharednotedata['sharednote']}",
//                                           // "${map['sharednote']}",
//                                           "${sharednotedata!['sharednote']}",
//                                           textAlign: TextAlign.left,
//                                           style: TextStyle(
//                                             fontSize: 24.0,
//                                             fontFamily: "lato",
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.black87,
//                                           ),
//                                         ),
//                                       ),
//                                       //
//                                       // Container(
//                                       //   alignment: Alignment.centerRight,
//                                       //   child: Text(
//                                       //     // formattedTime,
//                                       //     sharednotedata!['created'],
//                                       //     style: TextStyle(
//                                       //       fontSize: 20.0,
//                                       //       fontFamily: "lato",
//                                       //       color: Colors.black87,
//                                       //     ),
//                                       //   ),
//                                       // ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                     );
//                   },
//               );
//             } else {
//               return Center(
//                 child: Text("Loading..."),
//               );
//             }
//           }
//       ),
//
//
//
//     );
//   }
// }
//
