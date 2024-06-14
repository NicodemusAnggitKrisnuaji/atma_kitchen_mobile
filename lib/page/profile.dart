import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:atma_kitchen_mobile/model/user.dart';
import 'package:atma_kitchen_mobile/page/HistoryWithdrawal.dart'; // Import halaman riwayat penarikan saldo
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atma_kitchen_mobile/data/historySaldo_client.dart';

class ProfileView extends StatefulWidget {
  final User user;

  const ProfileView({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController saldoController = TextEditingController();
  TextEditingController rekeningController = TextEditingController();
  TextEditingController bankController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _saveUserData(widget.user);
  }

  Future<void> _saveUserData(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDataString = jsonEncode(user.toJson());
    await prefs.setString('userData', userDataString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${widget.user.nama}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: ${widget.user.email}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Address: ${widget.user.alamat}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Date of Birth: ${widget.user.tanggal_lahir}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Phone Number: ${widget.user.nomor_telepon}',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10.0),
            Text(
              'Saldo: ${widget.user.saldo}', // Menampilkan saldo pengguna
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigasi ke halaman penarikan saldo
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoryWithdrawalPage(user: widget.user),
                  ),
                );
              },
              child: Text('Riwayat Penarikan Saldo'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Ajukan Penarikan Saldo',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: saldoController,
              decoration: InputDecoration(
                labelText: 'Jumlah Saldo yang Akan Ditarik',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: rekeningController,
              decoration: InputDecoration(
                labelText: 'Nomor Rekening',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: bankController,
              decoration: InputDecoration(
                labelText: 'Nama Bank',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                // Ajukan penarikan saldo
                _ajukanPenarikanSaldo();
              },
              child: Text('Ajukan Penarikan Saldo'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _ajukanPenarikanSaldo() async {
    double saldo = double.tryParse(saldoController.text) ?? 0.0;
    String rekening = rekeningController.text;
    String bank = rekeningController.text;

    if (saldo <= 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Jumlah saldo yang ditarik harus lebih dari 0'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // Panggil fungsi untuk ajukan penarikan saldo dari HistoryClient
      // Pastikan untuk mendapatkan token pengguna dari SharedPreferences atau sumber otentikasi lainnya
      String token = widget.user.remember_token ??
          ''; // Ganti dengan cara mendapatkan token pengguna
      Map<String, dynamic> response = await HistoryClient.tarikSaldo(
          widget.user.id!, saldo, rekening, bank);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Info'),
            content: Text(response['message']),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Gagal melakukan penarikan saldo: $error'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
