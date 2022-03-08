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
  var allUsers = [];
  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
    getAllUsers();
  }

  void getAllUsers() {
    userReference.get().then((value) {
      // print(value.docs[0].data());
      value.docs.forEach((element) {
        final currentUser = element.data() as Map<String, dynamic>;
        print(currentUser);
        if (currentUser.isNotEmpty) {
          final userName = currentUser['name'];
          final userEmail = currentUser['email'];

          if (userName != null && userEmail != null) {
            allUsers.add({'name': userName, 'email': userEmail});
          }
        }
        // final userName = currentUser?.['name'];
        // final TextUser = message.data['User'];
        // final MessageWeiget = Text('$TextMessage From $TextUser');
        // MessagesWeigets.add(MessageWeiget);
        // allUsers.add(element.data());
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
      print(userMap);
    });
        // .onError((error, stackTrace) => null)
  }

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
                      width: size.width / 1.4,
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
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width / 40,
                    ),
                    ElevatedButton(
                      onPressed: onSearch,
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
                  ],
                ),
            ],
          ),
              isLoading  ? Center(
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
                child: userMap != null ?
                    Container(
                        height: size.height / 14,
                        // width: size.width / 1.4,
                        width: size.width ,
                        alignment: Alignment.center,
                        child: ListTile(
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
                            leading: Icon(Icons.account_box,
                                color: Colors.black, size: 35),
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
                            trailing:
                                Icon(Icons.chat, color: Colors.black, size: 35),
                          )
                    )
                    :SingleChildScrollView(
                  // padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: Column(
                    children: [
                      Container(
                        height: size.height / 1.22,
                        width: size.width ,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: allUsers.length,
                          itemBuilder: (context, index) {
                            return allUsersWidget(
                                size, allUsers[index], context);
                          },
                        ),
                      ),
                    ],
                  ),
                )
              )],
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

  Widget allUsersWidget(Size size, Map<String, dynamic> currentUser, BuildContext context) {
    // print('\n\nCurrent User\n\n');
    // print(currentUser);
    dynamic currentTime = DateFormat.jm().format(DateTime.now());
    return ListTile(
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
      trailing: Icon(Icons.chat, color: Colors.black, size: 35),
    );
  }
}
