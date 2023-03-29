import 'package:isar/isar.dart';

part 'email.g.dart';

@collection
class Email {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  // @Index(type: IndexType.value)
  String? email;
}

@collection
class Teacher {
  Id id = Isar.autoIncrement;

  final String name;

  Teacher(this.name);
}

@collection
class Student {
  Id id = Isar.autoIncrement;

  final String name;

  final teacher = IsarLink<Teacher>();

  Student(this.name);
}
