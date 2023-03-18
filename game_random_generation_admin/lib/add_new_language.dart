import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game_random_generation_admin/models/firebase_collection.dart';

class NewLanguage extends StatefulWidget {
  const NewLanguage({super.key});

  @override
  State<NewLanguage> createState() => _NewLanguageState();
}

class _NewLanguageState extends State<NewLanguage> {
  TextEditingController newlang = TextEditingController();

  TextEditingController newlangcodes = TextEditingController();

  final fieldkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Form(
            key: fieldkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                const Text(
                  "Add New Language & its Code",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  cursorHeight: 18,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  controller: newlang,
                  decoration: InputDecoration(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.75,
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      hintText: "language name",
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
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.name,
                  cursorHeight: 18,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  controller: newlangcodes,
                  decoration: InputDecoration(
                      constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width * 0.75,
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      hintText: "language code",
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
                      return "Enter Correct code...";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (fieldkey.currentState!.validate() == true) {
                        final lang_dat = {
                          'language': {newlang.text: newlangcodes.text}
                        };
                        final temp1 = language.limit(1);
                        final temp2 = await temp1.get();
                        final docid = temp2.docs.first.id;

                        language
                            .doc(docid)
                            .set(lang_dat, SetOptions(merge: true));

                        /*
                        Map<String, dynamic> temp;
                        
                        CollectionReference collref = language;
                        QuerySnapshot querySnapshot =
                            await collref.limit(1).get();
                        temp = querySnapshot.docs.first.get('language');
                        print(temp);
                        temp[newlang.text] = newlangcodes.text;
                        await querySnapshot.docs.first.reference
                            .update({'language': temp});

                        */

                        final mainCategoryRef = FirebaseFirestore.instance
                            .collection('${newlangcodes.text}_main_category')
                            .doc();
                        final langLettersRef = FirebaseFirestore.instance
                            .collection('${newlangcodes.text}_letters')
                            .doc('letters');
                        final letterWordCatRef = FirebaseFirestore.instance
                            .collection(
                                '${newlangcodes.text}_letter_word_categories')
                            .doc();

                        final categoryData = {'category': []};

                        final alphabetsData = {'alphabets': []};

                        final letterWordCatData = {'letters': '', 'words': ''};

// add your desired category array data to the categoryData dictionary
// add your desired alphabets array data to the alphabetsData dictionary
// add your desired letters and words data to the letterWordCatData dictionary

                        mainCategoryRef.set(categoryData);
                        langLettersRef.set(alphabetsData);
                        letterWordCatRef.set(letterWordCatData);
                        newlang.text = "";
                        newlangcodes.text = "";
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Added Successfully")));
                      }
                    },
                    child: Text("Submit")),
                Text(
                  'Current Languages',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                StreamBuilder(
                    stream: language.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> language_list =
                            snapshot.data!.docs.first.get('language');
                        print(language_list);
                        return Expanded(
                          child: ListView.builder(
                            itemCount: language_list.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                  "${index + 1}) ${language_list.entries.elementAt(index).key.toString()}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
