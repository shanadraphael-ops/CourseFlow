class Course {
  final int id;
  final String name;
  Course({required this.id, required this.name});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      name: json['name'] as String
    );
  }

  @override
  String toString() {
    return 'Course(id: $id, name: $name)';
  }
}