//Currently this sharednote screen is not used anywhere

























// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class ViewSharedNote extends StatefulWidget {
//   final Map sharednotedata;
//   late final String time;
//   final DocumentReference refe;
//
//   ViewSharedNote(this.sharednotedata, this.time, this.refe);
//
//   @override
//   _ViewSharedNoteState createState() => _ViewSharedNoteState();
// }
//
// class _ViewSharedNoteState extends State<ViewSharedNote> {
//   late String title;
//   late String des;
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     title = widget.sharednotedata['sharednote'];
//     // des = widget.sharednotedata['description'];
//     // newtime = DateTime.now();
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: Text("Notes",
//             style: TextStyle(
//               fontSize: 32.0,
//               fontFamily: "lato",
//               fontWeight: FontWeight.bold,
//               color: Colors.white70,
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(
//               15.0,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 // SizedBox(
//                 //   height: 10.0,
//                 // ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                         widget.sharednotedata['sharednote'],
//                       style: TextStyle(
//                         fontSize: 32.0,
//                         fontFamily: "lato",
//                         fontWeight: FontWeight.bold,
//                         color: Colors.grey,
//                       ),
//             ),
//
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 12.0,
//                         bottom: 12.0,
//                       ),
//                       child: Text(
//                         widget.time,
//                         // newtime,
//                         style: TextStyle(
//                           fontSize: 20.0,
//                           fontFamily: "lato",
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//
//                     // Text(
//                     //   widget.sharednotedata['sharednote'],
//                     //   style: TextStyle(
//                     //     fontSize: 20.0,
//                     //     fontFamily: "lato",
//                     //     color: Colors.grey,
//                     //   ),
//                     // ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: size.height / 2.5,
//                 ),
//
//                 ElevatedButton(
//                   onPressed: delete,
//                   child: Icon(
//                     Icons.delete_forever,
//                     size: 24.0,
//                     color: Colors.redAccent,
//                   ),
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(
//                       Colors.white,
//                     ),
//                     padding: MaterialStateProperty.all(
//                       EdgeInsets.symmetric(
//                         horizontal: 15.0,
//                         vertical: 8.0,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // PopupMenuButton(
//                 //   // color: Colors.redAccent,
//                 //   // shape: RoundedRectangleBorder(
//                 //   //     borderRadius: BorderRadius.all(Radius.circular(15.0))
//                 //   // ),
//                 //     itemBuilder: (context) =>
//                 //     [
//                 //       PopupMenuItem(
//                 //         child: Row(
//                 //           children: [
//                 //             ElevatedButton(
//                 //               onPressed: () {
//                 //                 setState(() {
//                 //                   edit = !edit;
//                 //                 });
//                 //               },
//                 //               child: Icon(
//                 //                 Icons.edit,
//                 //                 size: 24.0,
//                 //                 color: Colors.redAccent,
//                 //               ),
//                 //               style: ButtonStyle(
//                 //                 backgroundColor: MaterialStateProperty.all(
//                 //                   Colors.white,
//                 //                 ),
//                 //                 padding: MaterialStateProperty.all(
//                 //                   EdgeInsets.symmetric(
//                 //                     horizontal: 15.0,
//                 //                     vertical: 8.0,
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //             ),
//                 //             SizedBox(
//                 //               width: size.width / 30,
//                 //             ),
//                 //             InkWell(
//                 //               child: Container(
//                 //                 child: Text("Edit"),
//                 //               ),
//                 //               onTap: () {
//                 //                 setState(() {
//                 //                   edit = !edit;
//                 //                 });
//                 //                 // Navigator.pop(context);
//                 //               },
//                 //             ),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //       PopupMenuItem(
//                 //         child: Row(
//                 //           children: [
//                 //             ElevatedButton(
//                 //               onPressed: delete,
//                 //               child: Icon(
//                 //                 Icons.delete_forever,
//                 //                 size: 24.0,
//                 //                 color: Colors.redAccent,
//                 //               ),
//                 //               style: ButtonStyle(
//                 //                 backgroundColor: MaterialStateProperty.all(
//                 //                   Colors.white,
//                 //                 ),
//                 //                 padding: MaterialStateProperty.all(
//                 //                   EdgeInsets.symmetric(
//                 //                     horizontal: 15.0,
//                 //                     vertical: 8.0,
//                 //                   ),
//                 //                 ),
//                 //               ),
//                 //             ),
//                 //             SizedBox(
//                 //               width: size.width / 30,
//                 //             ),
//                 //             InkWell(
//                 //               child: Container(
//                 //                 child: Text("Delete"),
//                 //               ),
//                 //               onTap: () => delete(),
//                 //             ),
//                 //           ],
//                 //         ),
//                 //       ),
//                 //
//                 //     ]),
//                 // //
//                 SizedBox(
//                   height: 12.0,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void delete() async {
//     // delete from db
//     await widget.refe.delete();
//     Navigator.pop(context);
//   }
//
//   // void save() async {
//   //   if (key.currentState!.validate()) {
//   //     // TODo : showing any kind of alert that new changes have been saved
//   //     await widget.ref.update(
//   //       {'title': title, 'description': des},
//   //     );
//   //     Navigator.of(context).pop();
//   //   }
//   // }
// }
