import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenager/data/department.dart';
import 'package:evenager/data/event.dart';
import 'package:evenager/data/eventLocation.dart';
import 'package:evenager/data/eventType.dart';
import 'package:evenager/data/team.dart';
import 'package:evenager/services/authentication_service.dart';
import 'package:evenager/services/department_service.dart';
import 'package:evenager/services/employee_service.dart';
import 'package:evenager/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:sms/sms.dart';
import 'package:toast/toast.dart';

class AddEvent extends StatefulWidget {
  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  String dropdownEventType = "";
  String dropdownEventLocation = "";

  String dropdownDepartmentId = "";
  String dropdownDepartmentSelected = "";

  String dropdownTeamId = "";
  String dropdownTeamSelected = "";

  TextEditingController txtDate = TextEditingController();
  TextEditingController txtTime = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obrigatório';
                                  }
                                  return null;
                                },
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
                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obrigatório';
                                  }
                                  return null;
                                },
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
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.

                            final data = new Event(
                              id: "",
                              responsibleMeeting: context
                                  .read<AuthenticationService>()
                                  .userUid
                                  .toString(),
                              eventType: dropdownEventType,
                              eventLocation: dropdownEventLocation,
                              eventDay: DateFormat('dd-MM-yyyy')
                                  .format(_selectedDate),
                              eventTime: _selectedTime.format(context),
                              departmentId: dropdownDepartmentId,
                              teamId: dropdownTeamId,
                            );

                            submitData(data);
                          }
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(15)),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget getEventLocations() {
    return StreamBuilder<Iterable<EventLocation>>(
      stream: FirebaseFirestore.instance
          .collection("eventLocations")
          .snapshots()
          .map((event) => event.docs.map(
              (e) => EventLocation(locationName: e.data()["locationName"]))),
      builder: (BuildContext context, snapshot) {
        var eventLocations = snapshot.data;

        if (eventLocations == null) {
          return SizedBox();
        }

        if (!snapshot.hasData) {
          return Text("No data found");
        }

        List<DropdownMenuItem> listEventLocations =
            getListEventLocations(eventLocations.toList());

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
          items: listEventLocations,
        );
      },
    );
  }

  List<DropdownMenuItem<String>> getListEventLocations(
      List<EventLocation> locais) {
    List<DropdownMenuItem<String>> ret = [];
    for (int i = 0; i < locais.length; i++) {
      ret.add(DropdownMenuItem(
          child: Text(locais[i].locationName), value: locais[i].locationName));
    }
    return ret;
  }

  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////

  Widget getEventTypes() {
    return StreamBuilder<Iterable<EventType>>(
      stream: FirebaseFirestore.instance
          .collection("eventTypes")
          .snapshots()
          .map((event) => event.docs.map(
                (e) => EventType(eventName: e.data()["eventName"]),
              )),
      builder: (BuildContext context, snapshot) {
        var eventTypes = snapshot.data;

        if (eventTypes == null) {
          return SizedBox();
        }

        if (eventTypes.isEmpty) {
          return Text("No data found");
        }

        List<DropdownMenuItem> listEventTypes =
            getListEventTypes(eventTypes.toList());

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
          items: listEventTypes,
        );
      },
    );
  }

  List<DropdownMenuItem<String>> getListEventTypes(List<EventType> values) {
    List<DropdownMenuItem<String>> ret = [];
    for (int i = 0; i < values.length; i++) {
      ret.add(DropdownMenuItem(
          child: Text(values[i].eventName), value: values[i].eventName));
    }
    return ret;
  }

  ////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////

  Widget getDepartaments() {
    return StreamBuilder<Iterable<Department>>(
      stream: FirebaseFirestore.instance
          .collection("departments")
          .snapshots()
          .map((event) => event.docs.map((e) => Department(
              id: e.id, departmentName: e.data()["departmentName"]))),
      builder: (BuildContext context, snapshot) {
        var departments = snapshot.data;

        if (departments == null) {
          return SizedBox();
        }

        if (departments.isEmpty) {
          return Container(
            child: Text("No data found"),
          );
        }

        List<DropdownMenuItem> listDepartments =
            getListDepartments(departments.toList());

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
                dropdownDepartmentSelected = value.departmentName;
              });
            });
          },
          items: listDepartments,
        );
      },
    );
  }

  List<DropdownMenuItem<String>> getListDepartments(List<Department> values) {
    List<DropdownMenuItem<String>> ret = [];
    for (int i = 0; i < values.length; i++) {
      ret.add(DropdownMenuItem(
          child: Text(values[i].departmentName), value: values[i].id));
    }
    return ret;
  }

  ////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////

  Widget getTeams() {
    return StreamBuilder<Iterable<Team>>(
      stream: FirebaseFirestore.instance
          .collection("departments")
          .doc(dropdownDepartmentId)
          .collection("teams")
          .snapshots()
          .map((event) => event.docs.map((e) => Team(
              id: e.id,
              teamName: e.data()["teamName"],
              employees: e.data()["employees"]))),
      builder: (BuildContext context, snapshot) {
        var teams = snapshot.data;

        if (teams == null) {
          return SizedBox();
        }

        if (teams.isEmpty) {
          return Text("No data found");
        }

        List<DropdownMenuItem> listDepartments = getListTeams(teams.toList());

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

            DepartmentService.getTeamById(dropdownDepartmentId, dropdownTeamId)
                .then((value) => {
                      setState(() {
                        dropdownTeamSelected = value.teamName;
                      })
                    });
          },
          items: listDepartments,
        );
      },
    );
  }

  List<DropdownMenuItem<String>> getListTeams(List<Team> values) {
    List<DropdownMenuItem<String>> ret = [];
    for (int i = 0; i < values.length; i++) {
      ret.add(DropdownMenuItem(
          child: Text(values[i].teamName), value: values[i].id));
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

  void submitData(Event data) {
    activeToastMessage("Processando...", Duration(seconds: 1));

    /*SmsSender sender = new SmsSender();
    EventService.insertEvent(data).then((value) => {
          activeToastMessage(
              "Evento agendado com sucesso!", Duration(seconds: 1)),
        });*/

    EmployeeService.getEmployeesEqualDepartmentAndTeam(
            data.departmentId, data.teamId)
        .then((value) => {
              /*activeToastMessage(
                  "Notificando convidados", Duration(seconds: 3)),
              log("teste2"),*/
              value.map((e) async => {
                    /*await sender
                              .sendSms(new SmsMessage(e.phoneNumber, 'teste'))*/
                    log("teste"),
                    log("Notificando => ${e.name}")
                  }),
            });

    /*SmsSender sender = new SmsSender();
    EmployeeService.getEmployeesEqualDepartmentAndTeam(
            data.departmentId, data.teamId)
        .then((value) => {
              value.map((e) async => {
                    await sender
                        .sendSms(new SmsMessage('e.numberPhone', 'teste'))
                  })
            });*/

    // _cleanFields();
  }

  void activeToastMessage(String message, Duration duration) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green[500],
      duration: duration,
    ));
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
