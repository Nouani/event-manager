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
          teamId: value.data()!["teamId"]);
    });
  }

  static Future<Iterable<Employee>> getEmployeesEqualDepartmentAndTeam(
      String departmentId, String teamId) async {
    return FirebaseFirestore.instance
        .collection("employees")
        .where("departmentId", isEqualTo: departmentId)
        .where("teamId", isEqualTo: teamId)
        .get()
        .then(
          (value) => value.docs.map((e) {
            return Employee(
                id: e.id,
                name: e.data()["name"],
                surname: e.data()["surname"],
                photoUrl: e.data()["photoUrl"],
                departmentId: e.data()["departmentId"],
                teamId: e.data()["departmentId"]);
          }),
        );
  }
}
