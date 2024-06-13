import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atma_kitchen_mobile/data/produkClient.dart';
import 'package:atma_kitchen_mobile/model/produk.dart';
import 'package:atma_kitchen_mobile/page/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:atma_kitchen_mobile/model/user.dart'; // Pastikan import User

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<User?> _userDataFuture;
  User? userData; // Variabel untuk menyimpan data pengguna
  final listProdukProvider = FutureProvider<List<Produk>>((ref) async {
    return await ProdukClient.fetchAll();
  });

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  Future<User?> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      Map<String, dynamic> userDataMap = jsonDecode(userDataString);
      return User.fromJson(userDataMap);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Homepage'),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Homepage'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData) {
          userData = snapshot.data; // Simpan data pengguna dalam variabel local
          return Scaffold(
            appBar: AppBar(
              title: Text('Homepage'),
              actions: [
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileView(
                            user: userData!), // Kirim userData ke ProfileView
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Bagian gambar di atas
                  Stack(
                    children: [
                      Image.asset(
                        'images/kitchen.jpg', // Ganti dengan jalur gambar yang sesuai
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  // Bagian tentang kami
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/logo.png', // Ganti dengan jalur gambar yang sesuai
                          width: 200,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Tentang Kami',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Atma Kitchen adalah sebuah usaha baru di bidang kuliner, yang dimiliki oleh Bu Margareth Atma Negara, seorang selebgram yang sangat suka mencoba makanan yang sedang hits dimana menjual aneka kue premium, dan akan segera dibuka di Yogyakarta.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  // Bagian produk
                  Consumer(builder: (context, ref, child) {
                    final produkProvider = ref.watch(listProdukProvider);

                    return produkProvider.when(
                      data: (produks) => ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: produks.length,
                        itemBuilder: (context, index) {
                          final produk = produks[index];
                          return scrollViewItem(produk);
                        },
                      ),
                      error: (err, s) => Center(child: Text(err.toString())),
                      loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  })
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('Homepage'),
            ),
            body: Center(
              child: Text('No user data available'),
            ),
          );
        }
      },
    );
  }

  Widget scrollViewItem(Produk produk) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                produk.nama_produk,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Stok: ${produk.stock}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Kuota: ${produk.quota}',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
