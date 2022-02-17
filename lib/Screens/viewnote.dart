import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  final Map data;
  late final String time;
  final DocumentReference ref;

  ViewNote(this.data, this.time, this.ref);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  late String title;
  late String des;
  // late String newtime;

  bool edit = false;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    title = widget.data['title'];
    des = widget.data['description'];
    // newtime = DateTime.now();
    return SafeArea(
      child: Scaffold(
        //
        floatingActionButton: edit
            ? FloatingActionButton(
          onPressed: save,
          child: Icon(
            Icons.save_rounded,
            color: Colors.white,
          ),
          backgroundColor: Colors.grey[700],
        )
            : null,
        //
        resizeToAvoidBottomInset: false,
        //
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Notes",
            style: TextStyle(
              fontSize: 32.0,
              fontFamily: "lato",
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(
              15.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 10.0,
                // ),
                Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Title",
                        ),
                        style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: "lato",
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['title'],
                        enabled: edit,
                        onChanged: (_val) {
                          title = _val;
                          print("Title " + title);
                          widget.data['title'] = title;
                          // DateTime newtime = DateTime.now();
                          // String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(newtime);
                        },
                        validator: (_val) {
                          if (_val!.isEmpty) {
                            return "Can't be empty !";
                          } else {
                            return null;
                          }
                        },
                      ),


                      //
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12.0,
                          bottom: 12.0,
                        ),
                        child: Text(
                          widget.time,
                          // newtime,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: "lato",
                            color: Colors.grey,
                          ),
                        ),
                      ),

                      TextFormField(
                        decoration: InputDecoration.collapsed(
                          hintText: "Note Description",
                        ),
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "lato",
                          color: Colors.grey,
                        ),
                        initialValue: widget.data['description'],
                        enabled: edit,
                        onChanged: (_val) {
                          des = _val;
                          widget.data['description'] = des;
                          // widget.time = DateTime.now() as String;
                        },
                        maxLines: 20,
                        validator: (_val) {
                          if (_val!.isEmpty) {
                            return "Can't be empty !";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ],
                  ),
                ),

                        PopupMenuButton(
                            // Navigator.pop(context),
                            // color: Colors.redAccent,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.all(Radius.circular(15.0))
                            // ),
                            itemBuilder: (context) =>
                            [
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          edit = !edit;
                                        });
                                      },
                                      child: Icon(
                                        Icons.edit,
                                        size: 24.0,
                                        color: Colors.redAccent,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                          Colors.white,
                                        ),
                                        padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                            horizontal: 15.0,
                                            vertical: 8.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width / 30,
                                    ),
                                    InkWell(
                                      child: Container(
                                        child: Text("Edit"),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          edit = !edit;
                                        });
                                        // Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: delete,
                                      child: Icon(
                                        Icons.delete_forever,
                                        size: 24.0,
                                        color: Colors.redAccent,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                          Colors.white,
                                        ),
                                        padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(
                                            horizontal: 15.0,
                                            vertical: 8.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width / 30,
                                    ),
                                    InkWell(
                                      child: Container(
                                        child: Text("Delete"),
                                      ),
                                      onTap: () => delete(),
                                    ),
                                  ],
                                ),
                              ),

                            ]),
                        //
                        SizedBox(
                          height: 12.0,
                        ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void delete() async {
    // delete from db
    await widget.ref.delete();
    Navigator.pop(context);
  }

  void save() async {
    print("Inside save function");
    if (key.currentState!.validate()) {
      // TODo : showing any kind of alert that new changes have been saved
      print("Saving the changes...");
      print("Title inside save " + title);
      await widget.ref.update(
        {'title': title, 'description': des},
      );
      print("Changes saved!");
      Navigator.of(context).pop();
    }
  }
}
