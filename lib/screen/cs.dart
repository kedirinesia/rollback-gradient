// @dart=2.9


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/Products/delta/layout/livechat.dart';
// import 'package:mobile/Products/payku/layout/livechat.dart';
import 'package:mobile/bloc/Bloc.dart';
import 'package:mobile/config.dart';
import 'package:mobile/models/cs.dart';
import 'package:mobile/provider/analitycs.dart';
import 'package:mobile/provider/api.dart';
import 'package:url_launcher/url_launcher.dart';

class CS1 extends StatefulWidget {
  @override
  _CSState createState() => _CSState();
}

class _CSState extends State<CS1> {
  List<CustomerService> listCs = [];
  bool loading = true;
  List<String> pkgNameShowContactUs = [
    'id.outletpay.mobile',
  ];

  @override
  void initState() {
    getData();
    super.initState();
    analitycs.pageView('/cs/', {
      'userId': bloc.userId.valueWrapper?.value,
      'title': 'Customer Service',
    });
  }

  void getData() async {
    try {
      List<dynamic> datas =
          await api.get('/cs/list/public', cache: true, auth: false);
      listCs.add(CustomerService());
      listCs.addAll(datas.map((e) => CustomerService.fromJson(e)).toList());
    } catch (_) {
      listCs.add(CustomerService());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
//   void getData() async {
//   try {
//     print('Merchant Code: $sigVendor'); // Pastikan nilai sigVendor benar

//     http.Response response = await http.get(
//       Uri.parse('$apiUrl/cs/list/public'),
//       headers: {
//         'Content-Type': 'application/json',
//         'merchantCode': sigVendor,
//       },
//     );
//     print("SAMPAI SINI");

//     if (response.statusCode == 200) {
//       print("Response Status: ${response.statusCode}");
//       print("Response Body: ${response.body}");

//       try {
//         Map<String, dynamic> jsonResponse = json.decode(response.body);
//         List<dynamic> datas = jsonResponse['data'];

//         print("Decoded JSON: $datas");

//         listCs.add(CustomerService());
//         listCs.addAll(datas.map((e) => CustomerService.fromJson(e)).toList());
//         print("Data berhasil ditambahkan ke listCs");
//       } catch (jsonError) {
//         print("JSON Decoding Error: $jsonError");
//         listCs.add(CustomerService());
//       }
//     } else {
//       print("HTTP Error: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//       listCs.add(CustomerService());
//     }
//   } catch (error) {
//     print("HTTP Request Error: $error");
//     listCs.add(CustomerService());
//   } finally {
//     setState(() {
//       loading = false;
//       print("SetState loading false");
//     });
//   }
// }

  Widget loadingWidget() {
    return Flexible(
      flex: 1,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: SpinKitThreeBounce(
            color: Theme.of(context).primaryColor,
            size: 35,
          ),
        ),
      ),
    );
  }

  Widget listWidget() {
    if (listCs.length == 0) {
      return Flexible(
        flex: 1,
        child: Center(
          child: SvgPicture.asset(
            'assets/img/contact_us.svg',
            width: MediaQuery.of(context).size.width * .45,
          ),
        ),
      );
    } else {
      return Flexible(
        flex: 1,
        child: Container(
          margin: EdgeInsets.only(top: 20.0),
          padding: EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: listCs.length,
            itemBuilder: (context, i) {
              if (i == 0) {
                return InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CustomerServicePage(),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          offset: Offset(5, 10),
                          blurRadius: 10.0,
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(.1),
                        child: Icon(Icons.support_agent_rounded),
                      ),
                      title: Text(
                        'Live Chat',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Live Chat dengan Customer Service kami',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return InkWell(
                onTap: () => launchUrl(
                  Uri.parse(listCs[i].link),
                  mode: LaunchMode.externalApplication,
                ),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.1),
                            offset: Offset(5, 10),
                            blurRadius: 10.0)
                      ]),
                  child: ListTile(
                    leading: listCs[i].icon == ""
                        ? CircleAvatar(
                            backgroundColor:
                                Theme.of(context).primaryColor.withOpacity(.1),
                            child: CachedNetworkImage(
                              imageUrl:
                                  'https://firebasestorage.googleapis.com/v0/b/wajib-online.appspot.com/o/icons%2Finfo.png?alt=media&token=c4af5286-53b6-42a8-be30-4799f84fb71f',
                              width: 20.0,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor:
                                Theme.of(context).primaryColor.withOpacity(.1),
                            child: CachedNetworkImage(
                              imageUrl: listCs[i].icon,
                              width: 24,
                              height: 24,
                            ),
                          ),
                    title: Text(
                      listCs[i].contact,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      listCs[i].title,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('Customer Service'), centerTitle: true, elevation: 0),
      body: Column(children: <Widget>[
        Container(
          width: double.infinity,
          height: 200,
          padding: EdgeInsets.all(20),
          child: Hero(
            tag: 'cs',
            child: Center(
                child: CachedNetworkImage(
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/wajib-online.appspot.com/o/icons%2Ftie.png?alt=media&token=143f7a42-e520-49fb-8314-a53ac2c28614')),
          ),
          decoration: BoxDecoration(color: Colors.white),
        ),
        pkgNameShowContactUs.contains(packageName)
            ? Text(
                'Hubungi Kami',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : SizedBox(),
        loading ? loadingWidget() : listWidget()
      ]),
    );
  }
}
