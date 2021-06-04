class Team {
  final String id;
  final String teamName;
  final List<dynamic> employees;

  Team({
    required this.id,
    required this.teamName,
    required this.employees,
  });

  @override
  List<Object?> get props => [
        id,
        teamName,
        employees,
      ];
}
