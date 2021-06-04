import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenager/data/employee.dart';

class EmployeeService {
  static Future<Employee> getEmployeeById(String id) async {
    return FirebaseFirestore.instance
        .collection("employees")
        .doc(id)
        .get()
        .then((value) {
      return Employee(
          id: value.id,
          name: value.data()!["name"],
          surname: value.data()!["surname"],
          photoUrl: value.data()!["photoUrl"],
          departmentId: value.data()!["departmentId"],
          teamId: value.data()!["departmentId"]);
    });
  }
}
