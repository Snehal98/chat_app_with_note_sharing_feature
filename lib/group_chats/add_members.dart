// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
//
//
// class AddMembersINGroup extends StatefulWidget {
//   final String groupChatId, name;
//   final List membersList;
//   const AddMembersINGroup(
//       {required this.name,
//         required this.membersList,
//         required this.groupChatId,
//         Key? key})
//       : super(key: key);
//
//   @override
//   _AddMembersINGroupState createState() => _AddMembersINGroupState();
// }
//
// class _AddMembersINGroupState extends State<AddMembersINGroup> with WidgetsBindingObserver{
//   final TextEditingController _search = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   Map<String, dynamic>? userMap;
//   bool isLoading = false;
//   List membersList = [];
//   Map<String, dynamic>? currentUser;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   // var allUsers = [];
//   final List<Map<String, dynamic>> allUsers = [];
//   List<Map<String, dynamic>> _foundUsers = [];
//
//   var filteredUsers = [];
//   // List<Map<String, dynamic>> membersList = [];
//   CollectionReference userReference =
//   FirebaseFirestore.instance.collection('users');
//
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   membersList = widget.membersList;
//   // }
// //
// //   void onSearch() async {
// //     setState(() {
// //       isLoading = true;
// //     });
// //
// //     await _firestore
// //         .collection('users')
// //         .where("name", isEqualTo: _search.text)
// //         .get()
// //         .then((value) {
// //       setState(() {
// //         userMap = value.docs[0].data();
// //         isLoading = false;
// //       });
// //       print(userMap);
// //     });
// //   }
// //
// //   void onAddMembers() async {
// //     membersList.add(userMap);
// //
// //     await _firestore.collection('groups').doc(widget.groupChatId).update({
// //       "members": membersList,
// //     });
// //
// //     await _firestore
// //         .collection('users')
// //         .doc(userMap!['uid'])
// //         .collection('groups')
// //         .doc(widget.groupChatId)
// //         .set({"name": widget.name, "id": widget.groupChatId});
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final Size size = MediaQuery.of(context).size;
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Add Members"),
// //         backgroundColor: Colors.redAccent,
// //       ),
// //       body: SingleChildScrollView(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             SizedBox(
// //               height: size.height / 20,
// //             ),
// //             Container(
// //               height: size.height / 14,
// //               width: size.width,
// //               alignment: Alignment.center,
// //               child: Container(
// //                 height: size.height / 14,
// //                 width: size.width / 1.15,
// //                 child: TextField(
// //                   controller: _search,
// //                   decoration: InputDecoration(
// //                     hintText: "Search",
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(10),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(
// //               height: size.height / 50,
// //             ),
// //             isLoading
// //                 ? Container(
// //               height: size.height / 12,
// //               width: size.height / 12,
// //               alignment: Alignment.center,
// //               child: CircularProgressIndicator(),
// //             )
// //                 : ElevatedButton(
// //               onPressed: onSearch,
// //               child: Text("Search"),
// //               style: ButtonStyle(
// //                 backgroundColor: MaterialStateProperty.all(
// //                   Colors.redAccent,
// //                 ),
// //               ),
// //             ),
// //             userMap != null
// //                 ? ListTile(
// //               onTap: onAddMembers,
// //               leading: Icon(Icons.account_box),
// //               title: Text(userMap!['name']),
// //               subtitle: Text(userMap!['email']),
// //               trailing: Icon(Icons.add),
// //             )
// //                 : SizedBox(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addObserver(this);
//     getAllUsers();
//     membersList = widget.membersList;
//     _foundUsers = allUsers;
//     super.initState();
//   }
//
//   void onResultTap(int index) {
//     bool isAlreadyExist = false;
//
//     for (int i = 0; i < membersList.length; i++) {
//       if (membersList[i]['uid'] == _foundUsers[index]['uid']) {
//         isAlreadyExist = true;
//       }
//     }
//
//     if (!isAlreadyExist) {
//       setState(() {
//         membersList.add({
//           "name": _foundUsers[index]['name'],
//           "email": _foundUsers[index]['email'],
//           "uid": _foundUsers[index]['uid'],
//           "isAdmin": false,
//         });
//       });
//       _foundUsers.removeAt(index);
//     }
//   }
//
//   void onAddMembers(int index) async {
//     membersList.add(_foundUsers);
//
//     await _firestore.collection('groups').doc(widget.groupChatId).update({
//       "members": membersList,
//     });
//
//     await _firestore
//         .collection('users')
//         .doc(_foundUsers[index]['uid'])
//         .collection('groups')
//         .doc(widget.groupChatId)
//         .set({"name": widget.name, "id": widget.groupChatId});
//   }
//
//
//   void _runFilter(String enteredKeyword) {
//     List<Map<String, dynamic>> results = [];
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = allUsers;
//     } else {
//       results = allUsers
//           .where((user) =>
//           user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
//           .toList();
//       // we use the toLowerCase() method to make it case-insensitive
//     }
//     // Refresh the UI
//     setState(() {
//       _foundUsers = results;
//     });
//   }
//
//   void getAllUsers() {
//     userReference.get().then((value) {
//       // print(value.docs[0].data());
//       value.docs.forEach((element) {
//         final thisUser = element.data() as Map<String, dynamic>;
//         // print("Details of thisUser\n\n");
//         // print(thisUser);
//         if (thisUser.isNotEmpty && thisUser['uid'] != _auth.currentUser!.uid) {
//           final userUid = thisUser['uid'];
//           final userName = thisUser['name'];
//           final userEmail = thisUser['email'];
//           final userStatus = thisUser['status'];
//
//           if (userName != null && userEmail != null) {
//             allUsers.add({
//               'uid': userUid,
//               'name': userName,
//               'email': userEmail,
//               'status': userStatus
//             });
//           }
//         }
//       });
//     });
//   }
//
//   void getCurrentUserDetails() async {
//     await _firestore
//         .collection('users')
//         .doc(_auth.currentUser!.uid)
//         .get()
//         .then((map) {
//       setState(() {
//         membersList.add({
//           "name": map['name'],
//           "email": map['email'],
//           "uid": map['uid'],
//           "status": map['status'],
//         });
//       });
//     });
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: Text("Add Members"),
//         backgroundColor: Colors.redAccent,
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               SizedBox(
//                 height: size.height / 35,
//               ),
//               Row(
//                 children: [
//                   SizedBox(
//                     width: size.width / 20,
//                   ),
//                   Container(
//                     height: size.height / 14,
//                     width: size.width / 1.3,
//                     alignment: Alignment.center,
//                     child: Container(
//                       height: size.height / 14,
//                       width: size.width / 1.15,
//                       child: TextField(
//                         controller: _search,
//                         decoration: InputDecoration(
//                           hintText: "Find your friends here!",
//                           contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         onChanged: (value) => _runFilter(value),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     width: size.width / 20,
//                   ),
//                   Icon(
//                     Icons.search,
//                     color: Colors.redAccent,
//                     size: 35,
//                   )
//                 ],
//               ),
//             ],
//           ),
//           isLoading
//               ? Center(
//             child: Container(
//               height: size.height / 20,
//               width: size.height / 20,
//               child: CircularProgressIndicator(),
//             ),
//           )
//               : Stack(
//             children: [
//               Positioned(
//                   left: 0,
//                   top: 80,
//                   child: SingleChildScrollView(
//                     child: Container(
//                         height: size.height / 1.32,
//                         width: size.width,
//                         child: StreamBuilder<QuerySnapshot>(
//                           stream: _firestore
//                               .collection('users')
//                               .snapshots(),
//                           builder: (BuildContext context,
//                               AsyncSnapshot<QuerySnapshot> snapshot) {
//                             if (snapshot.data != null) {
//                               return ListView.builder(
//                                 itemCount: _foundUsers.length,
//                                 itemBuilder: (context, index) {
//                                   _foundUsers.sort((a, b) =>
//                                       a["name"].compareTo(b["name"]));
//                                   return allUsersWidget(
//                                       size,
//                                       _foundUsers[index],
//                                       context,
//                                       index);
//                                 },
//                               );
//                             } else {
//                               return Container();
//                             }
//                           },
//                         )
//                     ),
//                   )
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget allUsersWidget(Size size, Map<String, dynamic> currentUser,
//       BuildContext context, int index) {
//     return ListTile(
//       onTap: () => onAddMembers(index),
//       leading: Icon(Icons.account_box),
//       title: Text(currentUser['name']),
//       subtitle: Text(currentUser['email']),
//       trailing: Icon(Icons.add),
//     );
//   }
//
// }







//correct code


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMembersINGroup extends StatefulWidget {
  final String groupChatId, name;
  final List membersList;
  const AddMembersINGroup(
      {required this.name,
        required this.membersList,
        required this.groupChatId,
        Key? key})
      : super(key: key);

  @override
  _AddMembersINGroupState createState() => _AddMembersINGroupState();
}

class _AddMembersINGroupState extends State<AddMembersINGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  List membersList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    membersList = widget.membersList;
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("name", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  void onAddMembers() async {
    membersList.add(userMap);

    await _firestore.collection('groups').doc(widget.groupChatId).update({
      "members": membersList,
    });

    await _firestore
        .collection('users')
        .doc(userMap!['uid'])
        .collection('groups')
        .doc(widget.groupChatId)
        .set({"name": widget.name, "id": widget.groupChatId});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Members"),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: size.height / 20,
            ),
            Container(
              height: size.height / 14,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 14,
                width: size.width / 1.15,
                child: TextField(
                  controller: _search,
                  decoration: InputDecoration(
                    hintText: "Search",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: size.height / 50,
            ),
            isLoading
                ? Container(
              height: size.height / 12,
              width: size.height / 12,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
                : ElevatedButton(
              onPressed: onSearch,
              child: Text("Search"),
              style: ButtonStyle(
                alignment: Alignment.center,
                backgroundColor: MaterialStateProperty.all(
                  Colors.redAccent,
                ),
              ),
            ),
            userMap != null
                ? ListTile(
              onTap: onAddMembers,
              leading: Icon(Icons.account_box),
              title: Text(userMap!['name']),
              subtitle: Text(userMap!['email']),
              trailing: Icon(Icons.add),
            )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}