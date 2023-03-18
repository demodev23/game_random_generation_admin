import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final form_key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    _retrievedata();
  }

  _retrievedata() async {
    final main_cat_db = FirebaseFirestore.instance
        .collection("${widget.lang_code}_main_category");
    var temp2 = await main_cat_db
        .get()
        .then((value) => value.docs.single.get('category'));

    setState(() {
      main_category = temp2;
    });
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
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  cursorHeight: 18,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  controller: new_cat,
                  decoration: InputDecoration(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.75,
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
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
                    }

                    final demo = FirebaseFirestore.instance.collection(
                        '${widget.lang_code}_${new_cat.text.toLowerCase()}_words');
                    demo.doc('myDocument').set({'name': 'John Doe', 'age': 30});
                    new_cat.text = "";
                  },
                  child: Text("Add")),
              SizedBox(
                height: 20,
              ),
              Text(
                "Existing Categories",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("${widget.lang_code}_main_category")
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> categories =
                          snapshot.data!.docs.first.get('category');
                      print(categories);
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
