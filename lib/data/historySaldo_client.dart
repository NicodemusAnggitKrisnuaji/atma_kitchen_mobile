import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:atma_kitchen_mobile/model/historySaldo.dart';

class HistoryClient {
  static const String url = '10.0.2.2:8000'; 

  static Future<Map<String, dynamic>> tarikSaldo(
      int id, double saldo, String rekening, String bank) async {
    try {
      var response = await http.post(
        Uri.http(url, '/api/tarik-saldo/$id'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"saldo": saldo, "rekening": rekening, "bank": bank }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return Future.error('Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

   static Future<List<historySaldo>> getWithdrawalHistory(int id) async {
    try {
      var response = await http.get(
         Uri.http(url, '/api/withdrawal-history/$id'),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(response.body)['data'];
        List<historySaldo> historyList = responseData
            .map((item) => historySaldo.fromJson(item))
            .toList();
        return historyList;
      } else {
        throw Exception('Failed to load withdrawal history');
      }
    } catch (error) {
      throw Exception('Error fetching withdrawal history: $error');
    }
  }
}
