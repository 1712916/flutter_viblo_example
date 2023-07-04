import 'package:flutter/material.dart';
/*
* Load thêm dữ liệu cho model hiện có
* Chỉ load với model hiển thị trên màn hình (model tương tác với người dùng (bằng mắt))
* Cách này dùng cho trường hợp chỉ quan tâm đến các dữ liệu ban đầu (không bị phụ thuộc vào dữ liệu thêm vào)
*   cho các trường hợp tương khác sau đó như là submit
* */

class FetchMoreInfoForModelPage extends StatefulWidget {
  const FetchMoreInfoForModelPage({super.key});

  @override
  State<FetchMoreInfoForModelPage> createState() => _FetchMoreInfoForModelPageState();
}

class _FetchMoreInfoForModelPageState extends State<FetchMoreInfoForModelPage> {
  List<UserModel> users = [];

  void generateUsers() {
    users = List.generate(100, (index) => UserModel(id: index.toString(), name: 'Name $index'));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    generateUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch More Information'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          ///Use ListView.separated or builder to just load model show in screen
          return UserCard(
            userModel: users[index],
            onChanged: (user) {
              //reassign value for model
              users[index] = user;
            },
          );
        },
        itemCount: users.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for (var user in users) {
            print(user.toString());
          }
        },
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  const UserCard({super.key, required this.userModel, required this.onChanged});

  final UserModel userModel;

  final ValueChanged<UserModel> onChanged;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isLoadingAddress = true;

  List<String>? addresses;

  @override
  void initState() {
    super.initState();
    loadAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Name: ${widget.userModel.name}'),
        if (isLoadingAddress) Text('Loading Address') else Text('${addresses?.join(',')}')
      ],
    );
  }

  void loadAddress() async {
    if (widget.userModel.addresses != null) {
      addresses = widget.userModel.addresses;
    } else {
      addresses = await widget.userModel.loadAddress();
      widget.onChanged(widget.userModel.copyWith(addresses!));
    }

    isLoadingAddress = false;
    if (mounted) {
      setState(() {});
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final List<String>? addresses;

  UserModel({
    required this.id,
    required this.name,
    this.addresses,
  });

  UserModel copyWith(List<String> addresses) {
    return UserModel(
      id: id,
      name: name,
      addresses: addresses,
    );
  }

  Future<List<String>> loadAddress() async {
    ///add delay to show loading
    await Future.delayed(Duration(seconds: 2));
    return ['addresses 1 of $id and $name', 'addresses 2 of $id and $name'];
  }

  @override
  String toString() {
    return '$id $name ${addresses?.join(',')}';
  }
}
