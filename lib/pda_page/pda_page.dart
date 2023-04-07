import 'package:flutter/material.dart';

class PDAPage extends StatefulWidget {
  const PDAPage({Key? key}) : super(key: key);

  @override
  State<PDAPage> createState() => _PDAPageState();
}

class _PDAPageState extends State<PDAPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDA')),
      body: Column(
        children: [
          TextFormField(),
        ],
      ),
    );
  }
}
