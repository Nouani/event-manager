import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DepartmentService {
  static Future<Map<String, dynamic>?> getDepartmentById(String id) async {
    return FirebaseFirestore.instance
        .collection("departments")
        .doc(id)
        .get()
        .then((value) => value.data());
  }

  static Future<Map<String, dynamic>?> getTeamById(
      String departmentId, String teamId) async {
    return FirebaseFirestore.instance
        .collection("departments")
        .doc(departmentId)
        .collection("teams")
        .doc(teamId)
        .get()
        .then((value) => value.data());
  }
}
