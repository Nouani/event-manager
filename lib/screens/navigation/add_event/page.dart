import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenager/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEvent extends StatelessWidget {
  @override
  void _getEmployee(BuildContext context) async {
    final id = context.read<AuthenticationService>().userUid;

    // final funcionario = await context.read<EmployeeService>().getEmployee(id);
  }

  Widget build(BuildContext context) {
    _getEmployee(context);

    return Text("Adicionar");
  }
}
