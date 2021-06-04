import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenager/services/authentication_service.dart';
import 'package:evenager/services/employee_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourEvents extends StatelessWidget {
  @override
  void _getEmployee(BuildContext context) async {
    final id = context.read<AuthenticationService>().userUid;

    // final funcionario = await context.read<EmployeeService>().getEmployee(id);
  }

  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Agendar Evento"),
            Text("Agendar Evento"),
            Text("Agendar Evento"),
            ElevatedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out"),
            ),
          ],
        ),
      ),
    );
  }
}
