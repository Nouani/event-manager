class Department {
  final String departmentName;

  Department({
    required this.departmentName,
  });

  @override
  List<Object?> get props => [
        departmentName,
      ];
}
