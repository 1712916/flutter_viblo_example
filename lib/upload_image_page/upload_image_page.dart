import 'package:flutter/material.dart';
import 'package:flutter_example/task_runner/task_runner.dart';

import 'upload_image_util.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({Key? key}) : super(key: key);

  @override
  State<UploadImagePage> createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  UploadImageUtil uploadImageUtil = UploadImageUtil()..setMappingMethod(IsolateMappingImage());

  @override
  void initState() {
    super.initState();
    uploadImageUtil.addListener(listener);
  }

  void listener() {
    if (uploadImageUtil.isInProcess) {
      print('uploading');
    } else {
      print('upload done');
      print('${uploadImageUtil.getPaths()}');
    }
  }

  @override
  void dispose() {
    uploadImageUtil.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadImageUtil.clear();
          setState(() {});
        },
        child: Text('Clear Center'),
      ),
      body: Column(
        children: <Widget>[
          Text(
            'Upload Path',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              3,
              (index) => GestureDetector(
                onTap: () {
                  uploadImageUtil.addImage('localPath_$index');
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.primaries[index],
                  child: Text('localPath: $index'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'List Remote Path',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: uploadImageUtil,
                  builder: (context, child) {
                    if (uploadImageUtil.isInProcess) {
                      return Text('In Processing');
                    }
                    return Text('This is current list\n ${uploadImageUtil.getPaths()}');
                  },
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
