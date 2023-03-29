import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import './collections/email.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController textEditingController = TextEditingController();

  bool isInit = false;
  late final Isar isar;
  List<Email>? collectionEmail;

  @override
  void initState() {
    super.initState();
    initIsar();
  }

  void initIsar() async {
    isar = await Isar.open([EmailSchema, TeacherSchema, StudentSchema]);
    isInit = true;
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            TextField(controller: textEditingController),
            ElevatedButton(
              onPressed: () async {
                if (isInit) {
                  // Email email = Email();
                  // await isar.writeTxn(() async {
                  //   await isar.emails.put(email); // insert & update
                  // });
                  //
                  // collectionEmail = await isar.emails.where().findAll();
                  // setState(() {});

                  await isar.writeTxn(() async {
                    final teacher = Teacher('VINH NGO');

                    await isar.teachers.put(teacher);
                    // final t = await isar.teachers.where().filter().idEqualTo(1).findFirst();
                    // print('t: ${t?.name}');

                    final s = Student('Vijnh222')..teacher.value = teacher;
                    await isar.students.put(s);
                    s.teacher.save();
                  });
                }
              },
              child: Text('add email'),
            ),
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: collectionEmail
                        ?.map(
                          (e) => ListTile(
                            leading: Text(e.id.toString() ?? ''),
                            title: Text(e.email ?? 'nnnnn'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () async {
                                    await isar.writeTxn(() async {
                                      await isar.emails.put(e..email = 'new email name'); // insert & update

                                      collectionEmail = await isar.emails.where().findAll();

                                      setState(() {});
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await isar.writeTxn(() async {
                                      await isar.emails.delete(e.id).then((success) async {
                                        if (success) {
                                          collectionEmail = await isar.emails.where().findAll();

                                          setState(() {});
                                        }
                                      });
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList() ??
                    [],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
