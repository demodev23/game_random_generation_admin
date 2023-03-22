import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_random_generation_admin/add_new_category.dart';
import 'package:game_random_generation_admin/models/firebase_collection.dart';

class subcategory_list extends StatefulWidget {
  String lang_code;
  subcategory_list({super.key, required this.lang_code});

  @override
  State<subcategory_list> createState() => _subcategory_listState();
}

class _subcategory_listState extends State<subcategory_list> {
  List<dynamic> main_category = [];
  TextEditingController new_cat = TextEditingController();
  TextEditingController sub_cat = TextEditingController();
  TextEditingController internal_sub_cat = TextEditingController();
  TextEditingController DataEditorString = TextEditingController();
  final form_key = GlobalKey<FormState>();
  final subcat_form_key = GlobalKey<FormState>();
  final edit_data_key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Add New Category",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                key: form_key,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.name,
                      cursorHeight: 18,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      controller: new_cat,
                      decoration: InputDecoration(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          hintText: "category name",
                          hintStyle: TextStyle(fontSize: 20),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1))),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Enter Correct Name...";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      cursorHeight: 18,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      controller: sub_cat,
                      decoration: InputDecoration(
                          constraints: BoxConstraints(
                              minWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75),
                          hintText: "sub category name",
                          hintStyle: TextStyle(fontSize: 20),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1))),
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Enter Atleast One Subcategory...";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (form_key.currentState!.validate() == true) {
                      final main_cat_db = FirebaseFirestore.instance
                          .collection("${widget.lang_code}_main_category");
                      final temp = await main_cat_db.get();
                      final temp2 = await temp.docs.first.reference;
                      temp2.set({
                        "category": FieldValue.arrayUnion([new_cat.text])
                      }, SetOptions(merge: true));
                      final demo = FirebaseFirestore.instance.collection(
                          '${widget.lang_code}_${new_cat.text.toLowerCase()}_words');
                      demo.doc(sub_cat.text).set({'words': []});
                    }
                    new_cat.text = "";
                    sub_cat.text = "";
                  },
                  child: Text("Add")),
              SizedBox(
                height: 20,
              ),
              Text(
                "Add Sub Category To Existing Categories",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("${widget.lang_code}_main_category")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> categories = [];
                      categories = snapshot.data!.docs.first.get('category');

                      return Expanded(
                        child: ListView.builder(
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                "${index + 1}) ${categories[index]}",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (sdcontext) {
                                      return AlertDialog(
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        content: Text(
                                          "Operations on this Category",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (subcontext) {
                                                      return AlertDialog(
                                                        actionsAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        content: Text(
                                                          "Are You Sure ? ",
                                                        ),
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    subcontext);
                                                              },
                                                              child:
                                                                  Text("No")),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                final deleter =
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "${widget.lang_code}_${categories[index].toString().toLowerCase()}_words");
                                                                deleter.get().then(
                                                                    (snapshot) {
                                                                  for (DocumentSnapshot doc
                                                                      in snapshot
                                                                          .docs) {
                                                                    doc.reference
                                                                        .delete();
                                                                  }
                                                                });

                                                                final main_cat_db =
                                                                    FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "${widget.lang_code}_main_category");
                                                                final temp =
                                                                    await main_cat_db
                                                                        .get();
                                                                final temp2 =
                                                                    await temp
                                                                        .docs
                                                                        .first
                                                                        .reference;
                                                                temp2.set(
                                                                    {
                                                                      "category":
                                                                          FieldValue
                                                                              .arrayRemove([
                                                                        categories[
                                                                            index]
                                                                      ]),
                                                                    },
                                                                    SetOptions(
                                                                        merge:
                                                                            true));

                                                                Navigator.pop(
                                                                    subcontext);
                                                                Navigator.pop(
                                                                    sdcontext);
                                                              },
                                                              child: Text(
                                                                  "Yes Delete")),
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Text("Delete")),
                                          ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                    barrierDismissible: false,
                                                    useSafeArea: true,
                                                    context: context,
                                                    builder: (sdcontext) {
                                                      return AlertDialog(
                                                        scrollable: true,
                                                        title: Text(
                                                            "Add Sub category"),
                                                        content: Column(
                                                          children: [
                                                            Form(
                                                              key:
                                                                  subcat_form_key,
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                cursorHeight:
                                                                    18,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                                controller:
                                                                    internal_sub_cat,
                                                                decoration: InputDecoration(
                                                                    constraints: BoxConstraints(
                                                                        minWidth:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.75,
                                                                        maxWidth:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.75),
                                                                    hintText:
                                                                        "sub category name",
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                    border: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color:
                                                                                Colors.black,
                                                                            width: 1))),
                                                                onTapOutside:
                                                                    (event) {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                },
                                                                validator:
                                                                    (value) {
                                                                  if (value!
                                                                          .isEmpty ||
                                                                      !RegExp(r'^[a-z A-Z]+$')
                                                                          .hasMatch(
                                                                              value)) {
                                                                    return "Enter Atleast One Subcategory...";
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        actionsAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    sdcontext);
                                                              },
                                                              child: Text(
                                                                  "Cancel")),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (subcat_form_key
                                                                        .currentState!
                                                                        .validate() ==
                                                                    true) {
                                                                  final demo = FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          '${widget.lang_code}_${categories[index].toLowerCase().toString()}_words');
                                                                  demo
                                                                      .doc(internal_sub_cat
                                                                          .text)
                                                                      .set({
                                                                    'words': []
                                                                  });
                                                                }

                                                                internal_sub_cat
                                                                    .text = "";
                                                                Navigator.pop(
                                                                    sdcontext);
                                                              },
                                                              child:
                                                                  Text("Add")),
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Text("Add Sub Category")),
                                          ElevatedButton(
                                              onPressed: () async {
                                                DataEditorString.text =
                                                    categories[index];
                                                showDialog(
                                                    barrierDismissible: false,
                                                    useSafeArea: true,
                                                    context: context,
                                                    builder: (innercontext) {
                                                      return AlertDialog(
                                                        scrollable: true,
                                                        title:
                                                            Text("Edit Data"),
                                                        content: Column(
                                                          children: [
                                                            Form(
                                                              key:
                                                                  edit_data_key,
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .name,
                                                                cursorHeight:
                                                                    18,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                                controller:
                                                                    DataEditorString,
                                                                decoration: InputDecoration(
                                                                    constraints: BoxConstraints(
                                                                        minWidth:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.75,
                                                                        maxWidth:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.75),
                                                                    hintText:
                                                                        "Enter Data",
                                                                    hintStyle: TextStyle(
                                                                        fontSize:
                                                                            20),
                                                                    border: OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color:
                                                                                Colors.black,
                                                                            width: 1))),
                                                                onTapOutside:
                                                                    (event) {
                                                                  FocusScope.of(
                                                                          context)
                                                                      .unfocus();
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        actionsAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    innercontext);
                                                              },
                                                              child: Text(
                                                                  "Cancel")),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (edit_data_key
                                                                        .currentState!
                                                                        .validate() ==
                                                                    true) {
                                                                  final QuerySnapshot
                                                                      querySnapshot =
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              "${widget.lang_code}_${categories[index].toString().toLowerCase()}_words")
                                                                          .get();

                                                                  for (QueryDocumentSnapshot docSnapshot
                                                                      in querySnapshot
                                                                          .docs) {
                                                                    var temp =
                                                                        await docSnapshot
                                                                            .get('words');

                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "${widget.lang_code}_${DataEditorString.text.toLowerCase()}_words")
                                                                        .doc(docSnapshot
                                                                            .id)
                                                                        .set({
                                                                      'words':
                                                                          temp
                                                                    }, SetOptions(merge: true));
                                                                  }

                                                                  final deleter = FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "${widget.lang_code}_${categories[index].toString().toLowerCase()}_words");
                                                                  deleter
                                                                      .get()
                                                                      .then(
                                                                          (snapshot) async {
                                                                    for (DocumentSnapshot doc
                                                                        in snapshot
                                                                            .docs) {
                                                                      await doc
                                                                          .reference
                                                                          .delete();
                                                                    }
                                                                  });

                                                                  final main_cat_db = await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "${widget.lang_code}_main_category")
                                                                      .limit(1)
                                                                      .get();

                                                                  final docid =
                                                                      main_cat_db
                                                                          .docs
                                                                          .first
                                                                          .id;
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "${widget.lang_code}_main_category")
                                                                      .doc(docid
                                                                          .toString())
                                                                      .set({
                                                                    'category':
                                                                        FieldValue
                                                                            .arrayRemove([
                                                                      categories[
                                                                          index]
                                                                    ])
                                                                  }, SetOptions(merge: true));

                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          "${widget.lang_code}_main_category")
                                                                      .doc(docid
                                                                          .toString())
                                                                      .set({
                                                                    'category':
                                                                        FieldValue
                                                                            .arrayUnion([
                                                                      DataEditorString
                                                                          .text
                                                                    ])
                                                                  }, SetOptions(merge: true));
                                                                }

                                                                DataEditorString
                                                                    .text = "";
                                                                Navigator.pop(
                                                                    innercontext);
                                                                Navigator.pop(
                                                                    sdcontext);
                                                              },
                                                              child:
                                                                  Text("Edit")),
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Text("Edit"))
                                        ],
                                      );
                                    });
                              },
                            );
                          },
                        ),
                      );
                    }
                    return CircularProgressIndicator();
                  })
            ],
          ),
        ),
      ),
    );
  }
}


/*

showDialog(
                                    barrierDismissible: false,
                                    useSafeArea: true,
                                    context: context,
                                    builder: (sdcontext) {
                                      return AlertDialog(
                                        scrollable: true,
                                        title: Text("Add Sub category"),
                                        content: Column(
                                          children: [
                                            Form(
                                              key: subcat_form_key,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.name,
                                                cursorHeight: 18,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                                controller: internal_sub_cat,
                                                decoration: InputDecoration(
                                                    constraints: BoxConstraints(
                                                        minWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.75,
                                                        maxWidth: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.75),
                                                    hintText:
                                                        "sub category name",
                                                    hintStyle:
                                                        TextStyle(fontSize: 20),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: Colors.black,
                                                            width: 1))),
                                                onTapOutside: (event) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty ||
                                                      !RegExp(r'^[a-z A-Z]+$')
                                                          .hasMatch(value)) {
                                                    return "Enter Atleast One Subcategory...";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  if (subcat_form_key
                                                          .currentState!
                                                          .validate() ==
                                                      true) {
                                                    final demo = FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            '${widget.lang_code}_${categories[index].toLowerCase().toString()}_words');
                                                    demo
                                                        .doc(internal_sub_cat
                                                            .text)
                                                        .set({'words': []});
                                                  }

                                                  internal_sub_cat.text = "";
                                                },
                                                child: Text("Add")),
                                          ],
                                        ),
                                      );
                                    });



                                    */
