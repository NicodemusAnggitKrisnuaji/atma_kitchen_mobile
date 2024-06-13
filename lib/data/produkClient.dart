import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:atma_kitchen_mobile/model/produk.dart';

class ProdukClient {
  static final String url = '10.0.2.2:8000';
  static final String endpoint = '/api/produk';

  static Future<List<Produk>> fetchAll() async {
    try {
      var response = await http.get(Uri.http(url, endpoint));

      if (response.statusCode != 200)
        throw Exception('Failed to load products: ${response.reasonPhrase}');

      var responseBody = response.body;
      print('Response body: $responseBody'); // Debugging

      var decodedResponse = json.decode(responseBody);
      Iterable list = decodedResponse['data'];

      return list.map((e) => Produk.fromJson(e)).toList();
    } catch (e) {
      return Future.error('Failed to fetch products: ${e.toString()}');
    }
  }

  static Future<Produk> show(id) async {
    try {
      var response = await http.get(Uri.http(url, '$endpoint/$id'));

      if (response.statusCode != 200)
        throw Exception('Failed to find product: ${response.reasonPhrase}');

      var responseBody = response.body;
      print('Response body: $responseBody'); // Debugging

      var decodedResponse = json.decode(responseBody);

      return Produk.fromJson(decodedResponse['data']);
    } catch (e) {
      return Future.error('Failed to find product: ${e.toString()}');
    }
  }
}
