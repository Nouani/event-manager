import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenager/data/department.dart';
import 'package:evenager/data/employee.dart';
import 'package:evenager/data/event.dart';
import 'package:evenager/data/team.dart';
import 'package:evenager/services/authentication_service.dart';
import 'package:evenager/services/department_service.dart';
import 'package:evenager/services/employee_service.dart';
import 'package:evenager/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourEvents extends StatefulWidget {
  @override
  _YourEventsState createState() => _YourEventsState();
}

class _YourEventsState extends State<YourEvents> {
  late Employee employee;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    EmployeeService.getEmployeeById(
            context.read<AuthenticationService>().userUid.toString())
        .then(
      (value) => {
        setState(() {
          employee = value;
        })
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 70, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Olá, ${employee.surname}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Color.fromRGBO(130, 25, 227, 1),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AuthenticationService>().signOut();
                          },
                          child: Icon(Icons.exit_to_app),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red[800]),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Aqui estão seus eventos",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
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
                      color: Colors.black54,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      employee.photoUrl,
                      height: 35,
                      width: 35,
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
                        id: e.id,
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
                    return Text(
                      "Nenhum evento encontrado :(",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    );
                  }

                  return SizedBox(
                    height: 150, // constrain height
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: events.map((e) {
                        return _buildYourEvents(e, true);
                      }).toList(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Text(
                    "Você está participando",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              StreamBuilder<Iterable<Event>?>(
                stream: FirebaseFirestore.instance
                    .collection("events")
                    .where("departmentId", isEqualTo: employee.departmentId)
                    .where("teamId", isEqualTo: employee.teamId)
                    .snapshots()
                    .map((event) {
                  return event.docs.map((e) {
                    return Event(
                        id: e.id,
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
                    return Text(
                      "Nenhum evento encontrado :(",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                    );
                  }

                  return SizedBox(
                    height: 150, // constrain height
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: events.map((e) {
                        return _buildYourEvents(e, false);
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildYourEvents(Event e, bool isResponsibleMeeting) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return MoreInfoDialog(
              event: e,
              isResponsibleMeeting: isResponsibleMeeting,
            );
          },
        );
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

class MoreInfoDialog extends StatefulWidget {
  const MoreInfoDialog({
    Key? key,
    required this.event,
    required this.isResponsibleMeeting,
  }) : super(key: key);

  final Event event;
  final bool isResponsibleMeeting;

  @override
  _MoreInfoDialogState createState() => _MoreInfoDialogState();
}

class _MoreInfoDialogState extends State<MoreInfoDialog> {
  Department department = Department(departmentName: "");
  Team team = Team(teamName: "", employees: []);
  List<Employee> employees = [];

  @override
  void initState() {
    super.initState();

    final departmentId = widget.event.departmentId;
    final teamId = widget.event.teamId;
    DepartmentService.getDepartmentById(departmentId).then(
      (value) => setState(() {
        department = value;
      }),
    );

    DepartmentService.getTeamById(departmentId, teamId).then(
      (value) => setState(() {
        team = value;
      }),
    );

    EmployeeService.getEmployeesEqualDepartmentAndTeam(departmentId, teamId)
        .then(
      (value) => setState(() {
        employees = value.toList();
      }),
    );

    EmployeeService.getEmployeeById(widget.event.responsibleMeeting).then(
      (value) {
        List<Employee> data = employees;
        data.add(value);
        setState(() {
          employees = data;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: _buildDetaieldEvent(context),
            ),
          ),
          Positioned(
              right: -12,
              top: -12,
              child: ClipOval(
                child: Material(
                  color: Colors.redAccent, // button color
                  child: InkWell(
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                    onTap: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDetaieldEvent(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${widget.event.eventType}",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "${widget.event.eventLocation}",
                  style: TextStyle(color: Colors.black54, fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color.fromRGBO(200, 200, 200, 0.6),
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            // height: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 40),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Participantes",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${department.departmentName} | ${team.teamName}",
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: employees.map((otherEmployee) {
                      return _buildEventParticipants(otherEmployee);
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.isResponsibleMeeting == true
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              EventService.removeEvent(widget.event.id)
                                  .then((value) => Navigator.of(context).pop());
                            },
                            child: Icon(
                              Icons.delete,
                            ),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red[800]),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: Icon(
                              Icons.edit,
                            ),
                            style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple[800]),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${widget.event.eventTime}",
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                    Text(
                      "${widget.event.eventDay}",
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container _buildEventParticipants(Employee otherEmployee) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              otherEmployee.photoUrl,
              height: 35,
              width: 35,
            ),
          ),
          Text(
            "${otherEmployee.surname}",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
