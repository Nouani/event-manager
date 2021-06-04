import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeService {
  static Future<Map<String, dynamic>?> getEmployeeById(String id) async {
    return FirebaseFirestore.instance
        .collection("employees")
        .doc(id)
        .get()
        .then((value) => value.data());
  }
}
