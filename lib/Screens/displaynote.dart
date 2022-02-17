import 'dart:math';

import 'package:chat_app_va/Screens/displaynote.dart';
import 'package:chat_app_va/Screens/viewnote.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'addnote.dart';

class DisplayNote extends StatefulWidget {
  final Map data;
  final String time;
  final DocumentReference ref;

  DisplayNote(this.data, this.time, this.ref);
  @override
  _DisplayNoteState createState() => _DisplayNoteState();
}

class _DisplayNoteState extends State<DisplayNote> {
  late String title;
  late String des;

  bool edit = false;
  @override
  CollectionReference ref = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('posts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: ref.get(),
        builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
                  title = widget.data['title'];
                  des = widget.data['description'];
                  Map? data = snapshot.data!.data() as Map?;
                  DateTime mydateTime = data!['created'].toDate();
                  String formattedTime =
                  DateFormat.yMMMd().add_jm().format(mydateTime);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         Text(
                            "${data['title']}",
                            style: TextStyle(
                            fontSize: 24.0,
                            fontFamily: "lato",
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
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
                          color: Colors.black87,
            ),
            ),
            ),
            ],
            ),
            ),);
            }else{
            return Center(
            child: Text("Loading..."),
            );

    }
            }

      ),

    );

}
}








//       //
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
//         //
//         body: FutureBuilder<QuerySnapshot>(
//             future: ref.get(),
//             builder: (BuildContext context, AsyncSnapshot snapshot) {
//               if (snapshot.hasData) {
//                 if (snapshot.data!.docs.length == 0) {
//                   return Center(
//                     child: Text(
//                       "You have no saved Notes !",
//                       style: TextStyle(
//                         color: Colors.white70,
//                       ),
//                     ),
//                   );
//                 }
//
//                 // return StreamBuilder<QuerySnapshot>(
//                 //   stream: FirebaseFirestore.instance.collection("posts").snapshots(),
//                 //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 //     // return ListView.builder(
//                 //     //   itemCount: snapshot.data!.docs.length,
//                 //     //   itemBuilder: (context, index) {
//                 //         // Random random = new Random();
//                 //         // Color bg = myColors[random.nextInt(6)];
//                 Map? data = snapshot.data!.data() as Map?;
//                 // final Map<String, dynamic> userMap
//                 DateTime mydateTime = data!['created'].toDate();
//                 //         final String title;
//                 //         final String des;
//                 //         // late final Map data;
//                 //         final String time;
//                 String formattedTime =
//                 DateFormat.yMMMd().add_jm().format(mydateTime);
//
//                 return Card(
//                     child: Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "${data['title']}",
//                             style: TextStyle(
//                               fontSize: 24.0,
//                               fontFamily: "lato",
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           //
//                           Container(
//                             alignment: Alignment.centerRight,
//                             child: Text(
//                               formattedTime,
//                               style: TextStyle(
//                                 fontSize: 20.0,
//                                 fontFamily: "lato",
//                                 color: Colors.black87,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                 );
//               }else{
//                 return Center(
//                 child: Text("Loading..."),
//               );
//               }
//             }
//         )
//     );
//   }
// }



