import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:atma_kitchen_mobile/model/user.dart';
import 'package:atma_kitchen_mobile/page/HistoryWithdrawal.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:atma_kitchen_mobile/model/historySaldo.dart';
import 'package:atma_kitchen_mobile/data/historySaldo_client.dart'; // Update import statement
import 'package:http/http.dart' as http;

class HistoryWithdrawalPage extends StatefulWidget {
  final User user;

  const HistoryWithdrawalPage({Key? key, required this.user}) : super(key: key);

  @override
  _HistoryWithdrawalPageState createState() => _HistoryWithdrawalPageState();
}

class _HistoryWithdrawalPageState extends State<HistoryWithdrawalPage> {
  List<historySaldo> _historySaldoList = []; // Ensure consistency in class name

  @override
  void initState() {
    super.initState();
    fetchWithdrawalHistory();
  }

  Future<void> fetchWithdrawalHistory() async {
    try {
      List<historySaldo> historyList = await HistoryClient.getWithdrawalHistory(widget.user.id!); // Ensure consistency in class name

      setState(() {
        _historySaldoList = historyList;
      });
    } catch (error) {
      print('Error fetching withdrawal history: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdrawal History'),
      ),
      body: _historySaldoList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _historySaldoList.length,
              itemBuilder: (context, index) {
                final history = _historySaldoList[index];
                return ListTile(
                  title: Text('Saldo Ditarik: ${history.saldo_ditarik}'),
                  subtitle: Text('Status: ${history.status}'),
                );
              },
            ),
    );
  }
}
