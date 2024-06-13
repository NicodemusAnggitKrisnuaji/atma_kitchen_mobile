import 'dart:convert';

class Produk {
  int id_produk;
  int? id_penitip;
  String nama_produk;
  int harga_produk;
  double stock; // Gunakan double untuk angka desimal
  String deskripsi_produk;
  String kategori;
  int quota;
  String image;

  Produk({
    required this.id_produk,
    this.id_penitip,
    required this.nama_produk,
    required this.harga_produk,
    required this.stock,
    required this.deskripsi_produk,
    required this.kategori,
    required this.quota,
    required this.image,
  });

  factory Produk.fromRawJson(String str) => Produk.fromJson(json.decode(str));

  factory Produk.fromJson(Map<String, dynamic> json) => Produk(
        id_produk: json["id_produk"],
        id_penitip: json["id_penitip"],
        nama_produk: json["nama_produk"],
        harga_produk: json["harga_produk"],
        stock: (json["stock"] as num).toDouble(), // Konversikan ke double
        deskripsi_produk: json["deskripsi_produk"],
        kategori: json["kategori"],
        quota: json["quota"],
        image: json["image"],
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "id_produk": id_produk,
        "id_penitip": id_penitip,
        "nama_produk": nama_produk,
        "harga_produk": harga_produk,
        "stock": stock,
        "deskripsi_produk": deskripsi_produk,
        "kategori": kategori,
        "quota": quota,
        "image": image,
      };
}
