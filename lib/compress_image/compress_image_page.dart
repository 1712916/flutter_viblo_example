import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/compress_image/image_util.dart';
import 'package:flutter_example/count_down_page/count_down_page.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_isolate/flutter_isolate.dart' as flutter_isolate;

class CompressImagePage extends StatefulWidget {
  const CompressImagePage({Key? key}) : super(key: key);

  @override
  State<CompressImagePage> createState() => _CompressImagePageState();
}

class _CompressImagePageState extends State<CompressImagePage> {
  String filePath = 'assets/images/image_compress.jpg';
  String compressPath = '';
  double currentSliderValue = 20;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compress Image'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(filePath),
            Slider(
              value: currentSliderValue,
              max: 100,
              divisions: 100,
              label: currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  currentSliderValue = value;
                });
              },
            ),
            const SizedBox(height: 10),
            Button(
              title: 'Compress',
              onTap: onCompress,
            ),
            const SizedBox(height: 10),
            if (compressPath.isNotEmpty && !loading) Image.file(File(compressPath)),
            if (loading)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              )
          ],
        ),
      ),
    );
  }

  void onCompress() async {
    Future testCompress() async {
      loading = true;
      setState(() {});

      var file = await AssetImageToFile().getImageFileFromAssets(filePath);

      final targetPath = await getRandomImagePath();

      final message = jsonEncode(ImageCompressModel(file.path, targetPath, currentSliderValue.round()).toJson());

      final compressFilePath = await flutter_isolate.flutterCompute<String?, String>(compressImage, message);

      loading = false;
      setState(() {});

      if (compressFilePath != null) {
        compressPath = compressFilePath;
        setState(() {});
      }
    }

    testCompress();
    //await Future.wait([for (int i = 1; i < 10; i++) testCompress()]);
  }
}
