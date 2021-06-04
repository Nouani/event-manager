import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeService {
  final FirebaseFirestore _firestore;
  final String _collectionName = 'employees';
  CollectionReference? _collectionReference;

  EmployeeService(this._firestore) {
    this._collectionReference = _firestore.collection(_collectionName);
  }

  Future<DocumentSnapshot<Object?>> getEmployee(String? id) {
    return _collectionReference!.doc(id).get();
  }
}
