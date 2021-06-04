class Employee {
  final String name;
  final String surname;
  final String photoUrl;
  final String departmentId;
  final String teamId;

  Employee({
    required this.name,
    required this.surname,
    required this.photoUrl,
    required this.departmentId,
    required this.teamId,
  });

  @override
  List<Object?> get props => [
        name,
        surname,
        photoUrl,
        departmentId,
        teamId,
      ];
}