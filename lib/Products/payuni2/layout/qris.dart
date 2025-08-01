import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile/component/alert.dart';
import 'package:mobile/provider/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class MyQrisPage extends StatefulWidget {
  @override
  _MyQrisPageState createState() => _MyQrisPageState();
}

class _MyQrisPageState extends State<MyQrisPage> {
  String? _qrImage;
  ScreenshotController _screenshotController = ScreenshotController();
  File? image;

  Future<void> _getQr() async {
    try {
      dynamic data = await api.post('/qris/generate');
      setState(() {
        _qrImage = data['image'];
      });
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(
        Alert(
          'Merchant belum mendukung static QRIS',
          isError: true,
        ),
      );
      return Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    _getQr();
    super.initState();
  }

  Future<void> _takeScreenshot() async {
    Directory temp = await getTemporaryDirectory();
    image = await File('${temp.path}/qris.png').create();
    Uint8List? bytes = await _screenshotController.capture(
      pixelRatio: 2.5,
      delay: Duration(milliseconds: 100),
    );
    await image?.writeAsBytes(bytes!);
    if (image == null) return;
    await Share.file(
      'QRIS Saya',
      'qris.png',
      image!.readAsBytesSync(),
      'image/png',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _takeScreenshot,
        label: Row(children: [
          Icon(
            Icons.download,
            size: 18,
          ),
          SizedBox(width: 5),
          Text("Unduh QRIS"),
        ]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      appBar: AppBar(
        title: Text('QRIS Static'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _qrImage == null
          ? SpinKitFadingCircle(
              color: Theme.of(context).primaryColor,
            )
          : Column(
              children: [
                Expanded(
                  child: Screenshot(
                    controller: _screenshotController,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  "https://payuni.co.id/img/bg.png"),
                              fit: BoxFit.cover)),
                      width: double.infinity,
                      height: double.infinity,
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          // logo
                          Container(
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://payuni.co.id/img/logoputih.png',
                              progressIndicatorBuilder: (_, __, ___) =>
                                  SpinKitFadingCircle(
                                color: Theme.of(context).primaryColor,
                              ),
                              width: 150,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: CachedNetworkImage(
                                imageUrl: _qrImage!,
                                progressIndicatorBuilder: (_, __, ___) =>
                                    SpinKitFadingCircle(
                                  color: Theme.of(context).primaryColor,
                                ),
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          // text
                          Container(
                            child: Text(
                              'Menerima Pembayaran Melalui :',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // futer
                          SizedBox(height: 5.0),
                          Flexible(
                            child: Container(
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://banner.payuni.co.id/Popay/futerqris.png',
                                progressIndicatorBuilder: (_, __, ___) =>
                                    SpinKitFadingCircle(
                                  color: Theme.of(context).primaryColor,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
