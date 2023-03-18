import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference language =
    FirebaseFirestore.instance.collection("language");
