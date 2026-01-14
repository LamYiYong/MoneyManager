import 'package:flutter/material.dart';
import '../api/api_service.dart';

class TrendScreen extends StatelessWidget {
  const TrendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ApiService.fetchTrend(7),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final trend = snapshot.data ?? [];

        if (trend.isEmpty) {
          return const Center(child: Text("No trend data"));
        }

        final total = trend.fold<double>(
          0,
          (sum, e) => sum + (e['amount'] as num).toDouble(),
        );

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Last 7 Days",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),

              Text(
                "Total: RM ${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Trend list
              Expanded(
                child: ListView.builder(
                  itemCount: trend.length,
                  itemBuilder: (context, index) {
                    final day = trend[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const Icon(Icons.show_chart),
                        title: Text(day['date']),
                        trailing: Text(
                          "RM ${(day['amount'] as num).toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
