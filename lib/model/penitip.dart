import 'dart:convert';

class Penitip {
  int id_penitip;
  String nama;
  String nomor_telepon;
  String alamat;
  int komisi;

  Penitip({
    required this.id_penitip,
    required this.nama,
    required this.nomor_telepon,
    required this.alamat,
    required this.komisi,
  });

  factory Penitip.fromRawJson(String str) => Penitip.fromJson(json.decode(str));
  factory Penitip.fromJson(Map<String, dynamic> json) => Penitip(
        id_penitip: json["id_penitip"],
        nama: json["nama"],
        nomor_telepon: json["nomor_telepon"],
        alamat: json["alamat"],
        komisi: json["komisi"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id_penitip": id_penitip,
        "nama": nama,
        "nomor_telepon": nomor_telepon,
        "alamat": alamat,
        "komisi": komisi,
      };
}
