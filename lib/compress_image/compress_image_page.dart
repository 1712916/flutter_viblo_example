import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example/compress_image/image_util.dart';
import 'package:flutter_example/count_down_page/count_down_page.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class CompressImagePage extends StatefulWidget {
  const CompressImagePage({Key? key}) : super(key: key);

  @override
  State<CompressImagePage> createState() => _CompressImagePageState();
}

class _CompressImagePageState extends State<CompressImagePage> {
  String filePath = 'assets/images/image_compress.jpg';
  String compressPath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compress Image'),
      ),
      body: Column(
        children: [
          Image.asset(filePath),
          const SizedBox(height: 10),
          Button(
            title: 'Compress',
            onTap: () async {
              Future testCompress() async {
                final dir = await path_provider.getTemporaryDirectory();

                var file = await AssetImageToFile().getImageFileFromAssets(filePath);

                final targetPath = '${dir.absolute.path}/temp.jpg';

                final compressFile = await compute<ImageCompressModel, XFile?>(
                    isolateCompressImage, ImageCompressModel(file, targetPath));

                if (compressFile != null) {
                  compressPath = targetPath;
                  setState(() {});
                }
              }

              Future.wait([for (int i = 1; i < 10; i++) testCompress()]);
            },
          ),
          const SizedBox(height: 10),
          Image.asset(compressPath),
        ],
      ),
    );
  }
}
