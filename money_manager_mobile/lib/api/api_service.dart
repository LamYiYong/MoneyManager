import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/expense.dart';

class ApiService {
  // Android Emulator 访问电脑 localhost
  static const String baseUrl = "http://192.168.1.180:8000";

  static Future<Map<String, dynamic>> createExpense({
    required double amount,
    required String category,
    required String date, // yyyy-mm-dd
    String? note,
    int userId = 1,
  }) async {
    final url = Uri.parse("$baseUrl/expenses");

    final body = {
      "amount": amount,
      "category": category,
      "date": date,
      "note": note ?? "",
      "user_id": userId,
    };

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception("API error ${res.statusCode}: ${res.body}");
    }
  }
  static Future<List<Expense>> fetchExpenses() async {
  final url = Uri.parse("$baseUrl/expenses");

  final res = await http.get(url);

  if (res.statusCode == 200) {
    final List data = jsonDecode(res.body);
    return data.map((e) => Expense.fromJson(e)).toList();
  } else {
    throw Exception("Failed to load expenses");
  }
}
static Future<List<Map<String, dynamic>>> fetchTrend(int days) async {
  final url = Uri.parse("$baseUrl/analytics/spending-trend?days=$days");

  final res = await http.get(url);

  if (res.statusCode == 200) {
    final data = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(data['trend']);
  } else {
    throw Exception("Failed to load trend data");
  }
}
}
