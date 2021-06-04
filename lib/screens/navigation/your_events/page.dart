import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenager/data/employee.dart';
import 'package:evenager/data/event.dart';
import 'package:evenager/services/authentication_service.dart';
import 'package:evenager/services/employee_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourEvents extends StatefulWidget {
  @override
  _YourEventsState createState() => _YourEventsState();
}

class _YourEventsState extends State<YourEvents> {
  late Employee employee;

  @override
  Widget build(BuildContext context) {
    EmployeeService.getEmployeeById(
            context.read<AuthenticationService>().userUid.toString())
        .then((value) => {
              setState(() {
                employee = value;
              })
            });

    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Ola, ${employee.surname}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Color.fromRGBO(130, 25, 227, 1),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Aqui estão seus eventos",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Text(
                    "Agendados por você ",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      employee.photoUrl,
                      height: 25,
                      width: 25,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<Iterable<Event>?>(
                  stream: FirebaseFirestore.instance
                      .collection("events")
                      .where("responsibleMeeting", isEqualTo: employee.id)
                      .snapshots()
                      .map((event) {
                    return event.docs.map((e) {
                      return Event(
                          responsibleMeeting: e.data()["responsibleMeeting"],
                          eventType: e.data()["eventType"],
                          eventLocation: e.data()["eventLocation"],
                          eventDay: e.data()["eventDay"],
                          eventTime: e.data()["eventTime"],
                          departmentId: e.data()["departmentId"],
                          teamId: e.data()["teamId"]);
                    });
                  }),
                  builder: (context, snapshots) {
                    final events = snapshots.data;

                    if (events!.isEmpty) {
                      return Text("Not found list");
                    }

                    return SizedBox(
                      height: 150, // constrain height
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: events.map((e) {
                          return _buildYourEvents(e);
                        }).toList(),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildYourEvents(Event e) {
    return GestureDetector(
      onTap: () {
        log("Apertou no ${e.responsibleMeeting}");
      },
      child: Container(
        margin: EdgeInsets.only(right: 20),
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(150, 150, 150, 0.8),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${e.eventType}",
                  style: TextStyle(color: Colors.black87, fontSize: 18),
                ),
                Text(
                  "${e.eventLocation}",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${e.eventTime}",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                Text(
                  "${e.eventDay}",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
