class EventType {
  final String eventName;

  EventType({
    required this.eventName,
  });

  @override
  List<Object?> get props => [
        eventName,
      ];
}
