class Employee {
  final String id;
  final String name;
  final String surname;
  final String photoUrl;
  final String departmentId;
  final String teamId;
  final String phoneNumber;

  Employee({
    required this.id,
    required this.name,
    required this.surname,
    required this.photoUrl,
    required this.departmentId,
    required this.teamId,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        surname,
        photoUrl,
        departmentId,
        teamId,
        phoneNumber,
      ];
}
