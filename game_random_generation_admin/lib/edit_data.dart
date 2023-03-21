import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_random_generation_admin/models/firebase_collection.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  Map<String, dynamic> languages = {};
  String sel_lang = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _retrievedata();
  }

  _retrievedata() async {
    final temp = await language.limit(1);
    final temp2 = await temp.get();
    languages = {};
    languages = await temp2.docs.first.get('language');

    setState(() {
      sel_lang = languages.entries.first.key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  " Select Language -:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton(
                  // Initial Value
                  value: sel_lang,
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  // Down Arrow Icon
                  icon: const Icon(
                    Icons.arrow_drop_down,
                  ),
                  // Array list of items
                  items: languages.entries.map((e) {
                    return DropdownMenuItem<dynamic>(
                      value: e.key,
                      child: Text(e.key.toString()),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (newValue) {
                    setState(() {
                      sel_lang = newValue!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  print(languages[sel_lang]);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectCategory(
                                langcode: languages[sel_lang],
                              )));
                },
                child: Text(
                  "Enter",
                ))
          ],
        ),
      ),
    );
  }
}

class SelectCategory extends StatefulWidget {
  String langcode;
  SelectCategory({super.key, required this.langcode});

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  List<dynamic> main_category = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "Select Main Category",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("${widget.langcode}_main_category")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  main_category = [];
                  main_category = snapshot.data!.docs.first.get('category');
                  return Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.black,
                            thickness: 0.5,
                          );
                        },
                        itemCount: main_category.length,
                        shrinkWrap: true,
                        itemBuilder: (listcontext, index) {
                          return ListTile(
                            title: Text(
                              "${index + 1})  ${main_category[index]}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectSubCategory(
                                            langcode: widget.langcode,
                                            main_cat: main_category[index],
                                          )));
                            },
                          );
                        }),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    ));
  }
}

class SelectSubCategory extends StatefulWidget {
  String langcode;
  String main_cat;
  SelectSubCategory(
      {super.key, required this.langcode, required this.main_cat});

  @override
  State<SelectSubCategory> createState() => _SelectSubCategoryState();
}

class _SelectSubCategoryState extends State<SelectSubCategory> {
  List<dynamic> sub_category = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              "Select Sub Category",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(
                      "${widget.langcode}_${widget.main_cat.toLowerCase()}_words")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  sub_category = [];
                  snapshot.data!.docs.forEach((element) {
                    sub_category.add(element.id);
                  });
                  return Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.black,
                            thickness: 0.5,
                          );
                        },
                        itemCount: sub_category.length,
                        shrinkWrap: true,
                        itemBuilder: (listcontext, index) {
                          return ListTile(
                            title: Text(
                              "${index + 1})  ${sub_category[index]}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DataCRUDPage(
                                          CollectionName:
                                              "${widget.langcode}_${widget.main_cat.toLowerCase()}_words",
                                          subcat_name: sub_category[index])));
                            },
                          );
                        }),
                  );
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    ));
  }
}

class DataCRUDPage extends StatefulWidget {
  String CollectionName;
  String subcat_name;
  DataCRUDPage(
      {super.key, required this.CollectionName, required this.subcat_name});

  @override
  State<DataCRUDPage> createState() => _DataCRUDPageState();
}

class _DataCRUDPageState extends State<DataCRUDPage> {
  TextEditingController DataString = TextEditingController();

  final data_form_key = GlobalKey<FormState>();

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
              height: 10,
            ),
            Text(
              "Collection =: ${widget.CollectionName}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Sub Category =: ${widget.subcat_name}",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Add New Data",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: data_form_key,
              child: TextFormField(
                keyboardType: TextInputType.name,
                cursorHeight: 18,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                controller: DataString,
                decoration: InputDecoration(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width * 0.75,
                        maxWidth: MediaQuery.of(context).size.width * 0.75),
                    hintText: "Enter Word",
                    hintStyle: TextStyle(fontSize: 20),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1))),
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Empty Data Not Allowed";
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
                  if (data_form_key.currentState!.validate()) {
                    final db = await FirebaseFirestore.instance
                        .collection(widget.CollectionName);
                    final db_doc_name = widget.subcat_name;
                    await db.doc(db_doc_name).set({
                      'words': FieldValue.arrayUnion([DataString.text])
                    }, SetOptions(merge: true));

                    DataString.text = " ";
                  }
                },
                child: Text(
                  "ADD",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Existing Data",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Divider(
              color: Colors.black,
              thickness: 1,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(widget.CollectionName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> words = [];
                    snapshot.data!.docs.forEach((element) {
                      if (element.id == widget.subcat_name) {
                        words = element.get('words');
                      }
                    });
                    return Expanded(
                        child: ListView.separated(
                            itemBuilder: (listcontext, index) {
                              return ListTile(
                                title: Text(
                                  "${index + 1}) ${words[index]}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: Colors.black,
                                thickness: 1,
                              );
                            },
                            itemCount: words.length));
                  }

                  return CircularProgressIndicator();
                })
          ],
        ),
      ),
    ));
  }
}
