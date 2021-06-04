class Event {
  final String id;
  final String responsibleMeeting;
  final String eventType;
  final String eventLocation;
  final String eventDay;
  final String eventTime;
  final String departmentId;
  final String teamId;

  Event({
    required this.id,
    required this.responsibleMeeting,
    required this.eventType,
    required this.eventLocation,
    required this.eventDay,
    required this.eventTime,
    required this.departmentId,
    required this.teamId,
  });

  @override
  List<Object?> get props => [
        id,
        responsibleMeeting,
        eventType,
        eventLocation,
        eventDay,
        eventTime,
        departmentId,
        teamId,
      ];
}
