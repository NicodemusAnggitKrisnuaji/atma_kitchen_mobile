import 'dart:convert';

class User {
  int? id;
  String? nama;
  String? email;
  String? password;
  String? nomor_telepon;
  String? alamat;
  String? saldo;
  String? tanggal_lahir;
  String? role;
  String? remember_token;
  int? poin;

  User({
    this.id,
    this.nama,
    this.email,
    this.password,
    this.alamat,
    this.tanggal_lahir,
    this.nomor_telepon,
    this.saldo,
    this.role,
    this.remember_token,
    this.poin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      alamat: json['alamat'],
      tanggal_lahir: json['tanggal_lahir'],
      nomor_telepon: json['nomor_telepon'],
      saldo: json['saldo'],
      role: json['role'],
      remember_token: json['remember_token'],
      poin: json['poin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'password': password,
      'alamat': alamat,
      'tanggal_lahir': tanggal_lahir,
      'nomor_telepon': nomor_telepon,
      'saldo': saldo,
      'role': role,
      'remember_token': remember_token,
      'poin': poin,
    };
  }
}
