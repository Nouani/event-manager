import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenager/data/department.dart';
import 'package:evenager/data/team.dart';

class DepartmentService {
  static Future<Department> getDepartmentById(String id) async {
    return FirebaseFirestore.instance
        .collection("departments")
        .doc(id)
        .get()
        .then((value) =>
            Department(departmentName: value.data()!["departmentName"]));
  }

  static Future<Team> getTeamById(String departmentId, String teamId) async {
    return FirebaseFirestore.instance
        .collection("departments")
        .doc(departmentId)
        .collection("teams")
        .doc(teamId)
        .get()
        .then((value) => Team(
            teamName: value.data()!["teamName"],
            employees: value.data()!["employees"]));
  }
}
