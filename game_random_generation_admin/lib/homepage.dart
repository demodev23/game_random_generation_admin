import 'package:flutter/material.dart';
import 'package:game_random_generation_admin/add_new_category.dart';
import 'package:game_random_generation_admin/add_new_language.dart';
import 'package:game_random_generation_admin/edit_data.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NewLanguage()));
                  },
                  child: Text("Add New Language")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => category_list()));
                  },
                  child: Text("Add Category / Subcategory")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectLanguage()));
                  },
                  child: Text("Add Data")),
            ],
          ),
        ),
      ),
    );
  }
}
