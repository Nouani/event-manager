class Department {
  final String id;
  final String departmentName;

  Department({
    required this.id,
    required this.departmentName,
  });

  @override
  List<Object?> get props => [
        id,
        departmentName,
      ];
}
