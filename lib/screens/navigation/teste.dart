import 'dart:developer';

import 'package:evenager/services/authentication_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log(context.read<AuthenticationService>().userUid.toString());

    return Container(
      child: Text("HOME"),
    );
  }
}
