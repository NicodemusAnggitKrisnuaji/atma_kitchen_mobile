import 'dart:convert';

class historySaldo {
  int? id_history;
  int? id_user;
  String? saldo_ditarik; // Change type to String
  String? status;
  String? rekening;
  String? tanggal_ditarik;
  String? bank;

  historySaldo({
    this.id_history,
    this.id_user,
    this.saldo_ditarik,
    this.status,
    this.rekening,
    this.tanggal_ditarik,
    this.bank,
  });

  factory historySaldo.fromJson(Map<String, dynamic> json) {
    return historySaldo(
      id_history: json['id_history'],
      id_user: json['id_user'],
      saldo_ditarik: json['saldo_ditarik'].toString(), // Convert to String
      status: json['status'],
      rekening: json['rekening'],
      tanggal_ditarik: json['tanggal_ditarik'],
      bank: json['bank'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_history': id_history,
      'id_user': id_user,
      'saldo_ditarik': saldo_ditarik,
      'status': status,
      'rekening': rekening,
      'tanggal_ditarik': tanggal_ditarik,
      'bank': bank,
    };
  }
}
