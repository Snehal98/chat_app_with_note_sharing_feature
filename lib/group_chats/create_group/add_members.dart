import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'create_group.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({Key? key}) : super(key: key);

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final TextEditingController _search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');
  final List<Map<String, dynamic>> allUsers = [];
  List<Map<String, dynamic>> _foundUsers = [];

  @override
  void initState() {
    // super.initState();
    getAllUsers();
    getCurrentUserDetails();
    _foundUsers = allUsers;
    super.initState();
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
          "isAdmin": true,
        });
      });
    });
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    // if (_search.text.isNotEmpty) {

    await _firestore
        .collection('users')
        .where("name", isEqualTo: _search.text.toLowerCase())
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });

    // } else {
    //   return "Enter valid name";
    // }

    //  trial starts
    //   await _firestore
    //       .collection('users')
    //       .where("name", isNotEqualTo: _search.text.toLowerCase())
    //       .get()
    //       .then((value) {
    //     setState(() {
    //       // userMap = null;
    //       isLoading = false;
    //     });
    //     // print(userMap);
    //   });
    //  ends
  }

  void onResultTap(int index) {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == _foundUsers[index]['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "name": _foundUsers[index]['name'],
          "email": _foundUsers[index]['email'],
          "uid": _foundUsers[index]['uid'],
          "isAdmin": false,
        });
      });
      _foundUsers.removeAt(index);
    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
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
      print("Details of allUsers");
      print(allUsers);
      // allUsers.sort((a, b) {
      //   return a.value['name'].toString().toLowerCase().compareTo(b.value['name'].toString().toLowerCase());
      // });
    });
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Add Members"),
      ),
      body: Stack(
        children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            // Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            LimitedBox(
              maxHeight: 200,
              child: ListView.builder(
                itemCount: membersList.length,
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => onRemoveMembers(index),
                    leading: Icon(Icons.account_circle),
                    title: Text(membersList[index]['name']),
                    subtitle: Text(membersList[index]['email']),
                    trailing: Icon(Icons.close),
                  );
                },
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: size.width / 12,
                ),
                SizedBox(
                  height: size.height / 30,
                ),
                Container(
                  height: size.height / 12,
                  width: size.width / 1.35,
                  alignment: Alignment.center,
                  child: Container(
                    height: size.height / 14,
                    // width: size.width / 1.15,
                    width: size.width / 1.4,
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        // errorText: _errorText,
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
                ),
              ],
            ),
          ]),
          Stack(
            children: [
              Positioned(
                  left: 0,
                  top: min(size.height/12 + membersList.length * 80, 200 + size.height/12),
                  child: _foundUsers.isNotEmpty
                      ? SingleChildScrollView(
                          // padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                          child: Container(
                              height: size.height / 1.62,
                              width: size.width / 1,
                              child: StreamBuilder<QuerySnapshot>(
                                stream:
                                    _firestore.collection('users').snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.data != null) {
                                    return ListView.builder(
                                      itemCount: _foundUsers.length,
                                      itemBuilder: (context, index) {
                                        _foundUsers.sort((a, b) =>
                                            a["name"].compareTo(b["name"]));
                                        return allUsersWidget(size,
                                            _foundUsers[index], context, index);
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              )

                              //
                              ))
                      : Container(
                          child: Text("Users list not displayed"),
                        )),
            ],
          )
        ],
      ),

      // SizedBox(
      //   height: size.height / 50,
      // ),
      // SizedBox(
      //   width: size.width / 40,
      // ),

      // isLoading
      //     ? Container(
      //         height: size.height / 12,
      //         width: size.height / 12,
      //         alignment: Alignment.center,
      //         child: CircularProgressIndicator(),
      //       )
      //     :
      // ElevatedButton(
      //               onPressed: () {
      //                 onSearch();
      //                 if (_formKey.currentState!.validate()) {
      //                 setState(() {
      //                 });
      //               }
      //                 },
      //               // child: Text("Search"),
      //               child: Icon(
      //                 Icons.search_sharp,
      //                 size: 28.0,
      //               ),
      //               style: ButtonStyle(
      //                 backgroundColor: MaterialStateProperty.all(
      //                   Colors.redAccent,
      //                 ),
      //                 padding: MaterialStateProperty.all(
      //                   EdgeInsets.symmetric(
      //                     horizontal: 16.0,
      //                     vertical: 8.0,
      //                   ),
      //                 ),
      //               ),

      //             ),

      // userMap != null
      //     ? ListTile(
      //         onTap: onResultTap,
      //         leading: Icon(Icons.account_box),
      //         title: Text(userMap!['name']),
      //         subtitle: Text(userMap!['email']),
      //         trailing: Icon(Icons.add),
      //       )
      //     : SizedBox(),

      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              child: Icon(Icons.forward),
              backgroundColor: Colors.redAccent,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateGroup(
                    membersList: membersList,
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }

  Widget allUsersWidget(Size size, Map<String, dynamic> currentUser,
      BuildContext context, int index) {
    return ListTile(
      onTap: () => onResultTap(index),
      leading: Icon(Icons.account_box),
      title: Text(currentUser['name']),
      subtitle: Text(currentUser['email']),
      trailing: Icon(Icons.add),
    );
  }
}
