class Team {
  final String teamName;
  final List<dynamic> employees;

  Team({
    required this.teamName,
    required this.employees,
  });

  @override
  List<Object?> get props => [
        teamName,
        employees,
      ];
}
