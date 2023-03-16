import 'package:isar/isar.dart';

part 'email.g.dart';

@collection
class Email {
  Id id = Isar.autoIncrement; // you can also use id = null to auto increment

  @Index(type: IndexType.value)
  String? email;
}
