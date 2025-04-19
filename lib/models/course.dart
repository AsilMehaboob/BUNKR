class Course {
  final String id;
  final String code;
  final String name;
  final String academicYear;
  final String semester;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.academicYear,
    required this.semester,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'].toString(),
      code: json['code'],
      name: json['name'],
      academicYear: json['academic_year'],
      semester: json['academic_semester'],
    );
  }
}