import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evenager/data/event.dart';

class EventService {
  static Future<DocumentReference<Map<String, dynamic>>> insertEvent(
      Event data) async {
    return FirebaseFirestore.instance.collection("events").add({
      "responsibleMeeting": data.responsibleMeeting,
      "eventType": data.eventType,
      "eventLocation": data.eventLocation,
      "eventDay": data.eventDay,
      "eventTime": data.eventTime,
      "departmentId": data.departmentId,
      "teamId": data.teamId,
    });
  }

  static Future<void> removeEvent(String id) {
    return FirebaseFirestore.instance.collection("events").doc(id).delete();
  }
}
