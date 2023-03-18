import 'package:flutter/material.dart';
import 'package:game_random_generation_admin/add_new_sub_category.dart';
import 'package:game_random_generation_admin/models/firebase_collection.dart';

class category_list extends StatefulWidget {
  const category_list({super.key});

  @override
  State<category_list> createState() => _category_listState();
}

class _category_listState extends State<category_list> {
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
                          builder: (context) => subcategory_list(
                                lang_code: languages[sel_lang],
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
