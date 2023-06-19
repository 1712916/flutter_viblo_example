import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CachedNetworkImagePage extends StatefulWidget {
  const CachedNetworkImagePage({Key? key}) : super(key: key);

  @override
  State<CachedNetworkImagePage> createState() => _CachedNetworkImagePageState();
}

class _CachedNetworkImagePageState extends State<CachedNetworkImagePage> {
  String url =
      'https://static.lag.vn/upload/news/23/04/14/bang-xep-hang-top-99-nhan-vat-duoc-yeu-thich-nhat-trong-naruto-14_LFSZ.jpg?w=1200&h=800&crop=pad&scale=both&encoder=wic&subsampling=444';
  String errorUrl =
      'https://static.lag.vn/upload/news/23/04/14/error-bang-xep-hang-top-99-nhan-vat-duoc-yeu-thich-nhat-trong-naruto-14_LFSZ.jpg?w=1200&h=800&crop=pad&scale=both&encoder=wic&subsampling=444';

  List<String> urls = [
    'https://images.immediate.co.uk/production/volatile/sites/3/2023/04/naruto-762b09d.jpg?re',
    'https://images.immediate.co.uk/production/volatile/sites/3/2023/04/error-naruto-762b09d.jpg?re',
    'http://s3ceph-stg.sendo.vn/og-logistic-contract-stg/uploads/40495365-cefd-41da-8277-fd1ec5e599a3-image.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YSMQ4KZW01RGOZM13F5F%2F20230420%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230420T104328Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=538670ef1003e1840ba36dbd90472558770e75267d88ed1af8bc8a3ab8f9ae52',
    'http://s3ceph-stg.sendo.vn/og-logistic-contract-stg/uploads/40495365-cefd-41da-8277-fd1ec5e599a3-image.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=YSMQ4KZW01RGOZM13F5F%2F20230420%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20230420T104328Z&X-Amz-Expires=86400&X-Amz-SignedHeaders=host&X-Amz-Signature=538670ef1003e1840ba36dbd90472558770e75267d88ed1af8bc8a3ab8f9ae52',
    'http://media3-stg.scdn.vn/img3/2023/05_26/8fI9wMDD3AHLthWMmSqg.jpg',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      a();
    });
  }

  void a() async {
    try {
      DefaultCacheManager().getSingleFile(url).then(
          (value) => (value) {
                print('value');
              }, onError: () {
        print('error');
      });
    } catch (e, stacktrace) {
      print('error catchh: ${stacktrace}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // DefaultCacheManager().getFileFromCache(url).then((value) {
    //   print('file: ${value?.originalUrl}');
    // });

    return Scaffold(
      appBar: AppBar(
        title: Text('Cached Network Image'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                imageUrl: url,
                height: 200,
              ),
              CachedNetworkImage(
                imageUrl: errorUrl,
                height: 200,
                errorWidget: (context, url, error) {
                  return Text('err');
                },
              ),
              ...urls.map(
                (url) => CachedNetworkImage(
                  imageUrl: url,
                  height: 200,
                  errorWidget: (context, url, error) {
                    return Text('err');
                  },
                  imageBuilder: (context, imageProvider) {
                    return Text('Loading');
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
