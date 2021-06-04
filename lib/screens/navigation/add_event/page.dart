import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenager/data/event.dart';
import 'package:evenager/services/authentication_service.dart';
import 'package:evenager/services/department_service.dart';
import 'package:evenager/services/employee_service.dart';
import 'package:evenager/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay(hour: 0, minute: 0);

  String dropdownEventType = "";
  String dropdownEventLocation = "";

  String dropdownDepartmentId = "";
  String dropdownDepartmentSelected = "";

  String dropdownTeamId = "";
  String dropdownTeamSelected = "";

  TextEditingController txtDate = TextEditingController();
  TextEditingController txtTime = TextEditingController();

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
                margin: EdgeInsets.only(top: 50, bottom: 40),
                child: Text(
                  "Agendar Evento",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color.fromRGBO(130, 25, 227, 1),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 50),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(200, 200, 200, 0.6),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Qual o evento?",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Color.fromRGBO(160, 65, 240, 1),
                          ),
                        ),
                        getEventTypes(),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Qual o local?",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Color.fromRGBO(160, 65, 240, 1),
                          ),
                        ),
                        getEventLocations(),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 50),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(200, 200, 200, 0.6),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Qual o departamento?",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Color.fromRGBO(160, 65, 240, 1),
                          ),
                        ),
                        getDepartaments(),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    dropdownDepartmentId.trim() != ""
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Qual o time?",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 20,
                                  color: Color.fromRGBO(160, 65, 240, 1),
                                ),
                              ),
                              getTeams(),
                            ],
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 50),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(200, 200, 200, 0.6),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data do evento",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Color.fromRGBO(160, 65, 240, 1),
                          ),
                        ),
                        TextField(
                          readOnly: true,
                          decoration: _getDefaultInputDecoration(),
                          style: TextStyle(
                            color: Color.fromRGBO(160, 65, 240, 1),
                            fontSize: 15,
                          ),
                          controller: txtDate,
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Horário do evento",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Color.fromRGBO(160, 65, 240, 1),
                          ),
                        ),
                        TextField(
                          readOnly: true,
                          decoration: _getDefaultInputDecoration(),
                          style: TextStyle(
                            color: Color.fromRGBO(160, 65, 240, 1),
                            fontSize: 15,
                          ),
                          controller: txtTime,
                          onTap: () {
                            _selectTime(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    log(context
                        .read<AuthenticationService>()
                        .userUid
                        .toString());
                    final data = new Event(
                      responsibleMeeting: context
                          .read<AuthenticationService>()
                          .userUid
                          .toString(),
                      eventType: dropdownEventType,
                      eventLocation: dropdownEventLocation,
                      eventDay: DateFormat('dd-MM-yyyy').format(_selectedDate),
                      eventTime: _selectedTime.format(context),
                      departmentId: dropdownDepartmentId,
                      teamId: dropdownTeamId,
                    );
                    log(data.responsibleMeeting);
                    EventService.insertEvent(data);
                    _cleanFields();
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromRGBO(160, 65, 240, 1)),
                  ),
                  child: Text(
                    "AGENDAR",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 2.5,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getEventLocations() {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection("eventLocations").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var locais = snapshot.data!.docs;
        List<DropdownMenuItem> eventLocations = getListEventLocations(locais);
        if (!snapshot.hasData) {
          return Container(
            child: Text("No data found"),
          );
        } else {
          return DropdownButton(
            hint: Text(
              dropdownEventLocation,
              style: TextStyle(
                color: Color.fromRGBO(130, 25, 227, 1),
              ),
            ),
            // value: dropdownLocal,
            icon: Icon(
              Icons.place,
              color: Color.fromRGBO(130, 25, 227, 1),
            ),
            iconSize: 24,
            isExpanded: true,
            elevation: 16,
            style: TextStyle(
              color: Color.fromRGBO(130, 25, 227, 1),
            ),
            onChanged: (dynamic newValue) {
              setState(() {
                dropdownEventLocation = newValue.toString();
              });
            },
            items: eventLocations,
          );
        }
      },
    );
  }

  List<DropdownMenuItem<String>> getListEventLocations(locais) {
    List<DropdownMenuItem<String>> ret = [];
    for (int i = 0; i < locais.length; i++) {
      ret.add(DropdownMenuItem(
          child: Text(locais[i].data()["locationName"]),
          value: locais[i].data()["locationName"]));
    }
    return ret;
  }

  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////

  Widget getEventTypes() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("eventTypes").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var tipos = snapshot.data!.docs;
        List<DropdownMenuItem> eventTypes = getListEventTypes(tipos);
        if (!snapshot.hasData) {
          return Container(
            child: Text("No data found"),
          );
        } else {
          return DropdownButton(
            hint: Text(
              dropdownEventType,
              style: TextStyle(
                color: Color.fromRGBO(130, 25, 227, 1),
              ),
            ),
            // value: dropdownLocal,
            icon: const Icon(
              Icons.add_link,
              color: Color.fromRGBO(130, 25, 227, 1),
            ),
            iconSize: 24,
            isExpanded: true,
            elevation: 16,
            style: const TextStyle(
              color: Color.fromRGBO(130, 25, 227, 1),
            ),
            onChanged: (dynamic newValue) {
              setState(() {
                dropdownEventType = newValue.toString();
              });
            },
            items: eventTypes,
          );
        }
      },
    );
  }

  List<DropdownMenuItem<String>> getListEventTypes(values) {
    List<DropdownMenuItem<String>> ret = [];
    for (int i = 0; i < values.length; i++) {
      ret.add(DropdownMenuItem(
          child: Text(values[i].data()["eventName"]),
          value: values[i].data()["eventName"]));
    }
    return ret;
  }

  ////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////

  Widget getDepartaments() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("departments").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var departments = snapshot.data!.docs;
        List<DropdownMenuItem> listDepartments =
            getListDepartments(departments);
        if (!snapshot.hasData) {
          return Container(
            child: Text("No data found"),
          );
        } else {
          return DropdownButton(
            hint: Text(
              dropdownDepartmentSelected,
              style: TextStyle(
                color: Color.fromRGBO(130, 25, 227, 1),
              ),
            ),
            // value: dropdownLocal,
            icon: Icon(
              Icons.account_tree_outlined,
              color: Color.fromRGBO(130, 25, 227, 1),
            ),
            iconSize: 24,
            isExpanded: true,
            elevation: 16,
            style: TextStyle(
              color: Color.fromRGBO(130, 25, 227, 1),
            ),
            onChanged: (dynamic newValue) {
              setState(() {
                dropdownDepartmentId = newValue.toString();
              });

              DepartmentService.getDepartmentById(dropdownDepartmentId)
                  .then((value) {
                setState(() {
                  dropdownDepartmentSelected = value!["departmentName"];
                });
              });
            },
            items: listDepartments,
          );
        }
      },
    );
  }

  List<DropdownMenuItem<String>> getListDepartments(values) {
    List<DropdownMenuItem<String>> ret = [];
    for (int i = 0; i < values.length; i++) {
      ret.add(DropdownMenuItem(
          child: Text(values[i].data()["departmentName"]),
          value: values[i].id));
    }
    return ret;
  }

  ////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////

  Widget getTeams() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("departments")
          .doc(dropdownDepartmentId)
          .collection("teams")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var teams = snapshot.data!.docs;
        List<DropdownMenuItem> listDepartments = getListTeams(teams);

        if (!snapshot.hasData) {
          return Container(
            child: Text("No data found"),
          );
        } else {
          return DropdownButton(
            hint: Text(
              dropdownTeamSelected,
              style: TextStyle(
                color: Color.fromRGBO(130, 25, 227, 1),
              ),
            ),
            // value: dropdownLocal,
            icon: Icon(
              Icons.emoji_people,
              color: Color.fromRGBO(130, 25, 227, 1),
            ),
            iconSize: 24,
            isExpanded: true,
            elevation: 16,
            style: TextStyle(
              color: Color.fromRGBO(130, 25, 227, 1),
            ),
            onChanged: (dynamic newValue) {
              setState(() {
                dropdownTeamId = newValue.toString();
              });

              DepartmentService.getTeamById(
                      dropdownDepartmentId, dropdownTeamId)
                  .then((value) => {
                        setState(() {
                          dropdownTeamSelected = value!["teamName"];
                        })
                      });
            },
            items: listDepartments,
          );
        }
      },
    );
  }

  List<DropdownMenuItem<String>> getListTeams(values) {
    List<DropdownMenuItem<String>> ret = [];
    for (int i = 0; i < values.length; i++) {
      ret.add(DropdownMenuItem(
          child: Text(values[i].data()["teamName"]), value: values[i].id));
    }
    return ret;
  }

  ////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////

  _selectDate(BuildContext context) async {
    final dateFormat = new DateFormat('dd/MM/yyyy');

    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 720)));

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      txtDate
        ..text = dateFormat.format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: txtDate.text.length, affinity: TextAffinity.upstream));
    }
  }

  _selectTime(BuildContext context) async {
    TimeOfDay? newSelectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (newSelectedTime != null) {
      _selectedTime = newSelectedTime;
      DateTime now = DateTime.now();
      DateTime auxiliar = DateTime(now.year, now.month, now.day,
          newSelectedTime.hour, newSelectedTime.minute);
      txtTime
        ..text = DateFormat("HH:mm").format(auxiliar)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: txtDate.text.length, affinity: TextAffinity.upstream));
    }
  }

  InputDecoration _getDefaultInputDecoration() {
    return InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(200, 200, 200, 0.6)),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(160, 65, 240, 1)),
      ),
    );
  }

  void _cleanFields() {
    setState(() {
      dropdownEventType = "";
      dropdownEventLocation = "";
      dropdownDepartmentId = "";
      dropdownDepartmentSelected = "";
      dropdownTeamId = "";
      dropdownTeamSelected = "";
    });
  }
}
