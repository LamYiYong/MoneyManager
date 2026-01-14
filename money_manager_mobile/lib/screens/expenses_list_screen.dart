import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/expense.dart';

class ExpensesListScreen extends StatelessWidget {
  const ExpensesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Expense>>(
      future: ApiService.fetchExpenses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final expenses = snapshot.data ?? [];

        if (expenses.isEmpty) {
          return const Center(child: Text("No expenses yet"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final e = expenses[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const Icon(Icons.receipt_long),
                title: Text("${e.category} - RM ${e.amount.toStringAsFixed(2)}"),
                subtitle: Text("${e.date}\n${e.note}"),
                isThreeLine: true,
              ),
            );
          },
        );
      },
    );
  }
}
