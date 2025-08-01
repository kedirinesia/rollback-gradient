// @dart=2.9

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/Products/centralbayar/layout/topup/bank/bank.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/Products/centralbayar/layout/topup/bank/transfer-deposit.dart';
import 'package:mobile/bloc/Bloc.dart' show bloc;
import 'package:mobile/bloc/Api.dart' show apiUrl;

abstract class BankController extends State<TopupBank> {
  bool loading = false;
  TextEditingController nominal = TextEditingController();

  void topup() async {
    double parsedNominal = double.parse(nominal.text.replaceAll('.', ''));
    if (nominal.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Nominal belum diisi')));
      return;
    } else if (parsedNominal < 10000) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Minimal deposit adalah Rp 10.000')));
      return;
    }

    setState(() {
      loading = true;
    });

    http.Response response = await http.post(
        Uri.parse(apiUrl + '/deposit/send'),
        headers: {
          'content-type': 'application/json',
          'Authorization': bloc.token.valueWrapper?.value
        },
        body: jsonEncode(
            {'nominal': parsedNominal, 'type': widget.payment.type}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      Navigator.of(context).pop();
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => TransferDepositPage(
              data['nominal_transfer'], widget.payment.type)));
    } else {
      String message = json.decode(response.body)['message'] ??
          'Terjadi kesalahan pada server';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    setState(() {
      loading = false;
    });
  }
}
