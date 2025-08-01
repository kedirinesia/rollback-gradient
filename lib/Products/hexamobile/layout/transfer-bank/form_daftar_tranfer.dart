// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:mobile/Products/hexamobile/layout/transfer-bank/select_bank.dart';
import 'package:mobile/models/wd_bank.dart';
import 'package:mobile/models/daftar_transfer.dart';

class FormDaftarTransfer extends StatefulWidget {
  final DaftarTransferModel transferData;
  final int indexItem;
  final BuildContext transferBS;

  const FormDaftarTransfer(
      {this.transferData, this.indexItem, this.transferBS, Key key})
      : super(key: key);

  @override
  State<FormDaftarTransfer> createState() => _FormDaftarTransferState();
}

class _FormDaftarTransferState extends State<FormDaftarTransfer> {
  TextEditingController namaTujuan = TextEditingController();
  TextEditingController noTujuan = TextEditingController();

  String namaBank = '';
  String kodeProduk = '';
  String admin = '';

  List<WithdrawBankModel> banks = [];

  bool loading = true;

  @override
  void initState() {
    if (widget.transferData != null) {
      namaTujuan.text = widget.transferData.namaRekening;
      noTujuan.text = widget.transferData.noTujuan;
      namaBank = widget.transferData.namaBank;
      kodeProduk = widget.transferData.kodeProduk;
    }
    super.initState();
  }

  void submitFormData() {
    if (namaTujuan.text.isEmpty ||
        noTujuan.text.isEmpty ||
        namaBank.isEmpty ||
        kodeProduk.isEmpty) {
      final snackBar = SnackBar(content: const Text('Form Wajib Diisi!'));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    Map<String, dynamic> dataToSend = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'kodeProduk': kodeProduk,
      'namaRekening': namaTujuan.text,
      'namaBank': namaBank,
      'noTujuan': noTujuan.text,
    };

    DaftarTransferModel tranfer = DaftarTransferModel.parse(dataToSend);

    if (widget.indexItem != null) {
      Hive.box('daftar-transfer')
          .putAt(widget.indexItem, DaftarTransferModel.create(tranfer).toMap())
          .then((value) {
        Navigator.of(context).pop(widget.transferBS);
      });
    } else {
      Hive.box('daftar-transfer')
          .add(DaftarTransferModel.create(tranfer).toMap())
          .then((value) {
        Navigator.of(context).pop(widget.transferBS);
      });
    }
  }

  @override
  void dispose() {
    namaTujuan.dispose();
    noTujuan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var value;

    return Scaffold(
      backgroundColor: Color(0XFFF0F0F0),
      appBar:
          AppBar(title: Text('Transfer Baru'), centerTitle: true, elevation: 0),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  SizedBox(height: 10),
                  selectBank(value),
                  SizedBox(height: 5),
                  inputDestionationName(context),
                  SizedBox(height: 10),
                  inputDestionationNumber(context),
                ],
              ),
            )),
            buttonSubmit(context),
          ],
        ),
      ),
    );
  }

  Widget selectBank(value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(.15),
          child: SvgPicture.asset('assets/img/payuni2/bank.svg'),
        ),
        title: Text(
          'Bank Tujuan',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(namaBank.isEmpty ? 'Pilih bank' : namaBank),
        trailing: Icon(Icons.navigate_next_rounded),
        onTap: () async {
          WithdrawBankModel bank = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SelectBankPage(),
            ),
          );
          if (bank == null) return;

          setState(() {
            namaBank = bank.nama;
            kodeProduk = bank.kodeProduk;
            admin = bank.admin.toString();
          });
        },
      ),
    );
  }

  Widget inputDestionationName(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nama Tujuan',
              style: TextStyle(color: Colors.grey, fontSize: 11)),
          SizedBox(height: 5),
          TextFormField(
            keyboardType: TextInputType.text,
            enableInteractiveSelection: true,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF0F0F0),
              prefixIcon: Padding(
                padding:
                    const EdgeInsetsDirectional.only(start: 13.0, end: 12.0),
                child: SvgPicture.asset(
                  "assets/img/payuni2/user.svg",
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.027,
                  width: MediaQuery.of(context).size.height * 0.027,
                ), // myIcon is a 48px-wide widget.
              ),
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 2.0, top: 8.0),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(4),
              ),
              hintText: "Nama Tujuan",
              hintStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.0182,
                color: Colors.grey,
              ),
            ),
            controller: namaTujuan,
          ),
        ],
      ),
    );
  }

  Widget inputDestionationNumber(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nomor Tujuan',
              style: TextStyle(color: Colors.grey, fontSize: 11)),
          SizedBox(height: 5),
          TextFormField(
            keyboardType: TextInputType.number,
            enableInteractiveSelection: true,
            obscureText: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF0F0F0),
              prefixIcon: Padding(
                padding:
                    const EdgeInsetsDirectional.only(start: 13.0, end: 12.0),
                child: SvgPicture.asset(
                  "assets/img/payuni2/credit_card.svg",
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.027,
                  width: MediaQuery.of(context).size.height * 0.027,
                ),
              ),
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 2.0, top: 8.0),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(4),
              ),
              hintText: "Nomor Rekening Tujuan",
              hintStyle: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.0182,
                color: Colors.grey,
              ),
            ),
            controller: noTujuan,
          ),
        ],
      ),
    );
  }

  Widget buttonSubmit(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: submitFormData,
        style: ElevatedButton.styleFrom(
          foregroundColor: Theme.of(context).primaryColor, backgroundColor: Theme.of(context).primaryColor, disabledForegroundColor: Theme.of(context).primaryColor.withOpacity(0.38), disabledBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.12),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'LANJUTKAN',
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.height * 0.0182,
            ),
          ),
        ),
      ),
    );
  }
}
