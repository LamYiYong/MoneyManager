import 'package:flutter/material.dart';
import '../api/api_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String _category = "Food";
  DateTime _selectedDate = DateTime.now();

  bool _loading = false;

  final List<String> _categories = const [
    "Food",
    "Transport",
    "Shopping",
    "Entertainment",
    "Bills",
    "Other",
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    // yyyy-mm-dd
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return "${d.year}-$mm-$dd";
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(_amountController.text.trim());
    final dateStr = _formatDate(_selectedDate);
    final note = _noteController.text.trim();

    setState(() => _loading = true);

    try {
      final result = await ApiService.createExpense(
        amount: amount,
        category: _category,
        date: dateStr,
        note: note,
        userId: 1,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Saved ✅ ID: ${result['id']}")),
      );

      // 清空输入
      _amountController.clear();
      _noteController.clear();
      setState(() {
        _category = "Food";
        _selectedDate = DateTime.now();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed ❌ $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _formatDate(_selectedDate);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Add Expense",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    prefixText: "RM ",
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final value = (v ?? "").trim();
                    if (value.isEmpty) return "Please enter amount";
                    final n = double.tryParse(value);
                    if (n == null) return "Amount must be a number";
                    if (n <= 0) return "Amount must be > 0";
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // Category
                DropdownButtonFormField<String>(
                  value: _category,
                  items: _categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _category = v ?? "Food"),
                  decoration: const InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                // Date
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Date: $dateText",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today),
                      label: const Text("Pick"),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Note
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    labelText: "Note (optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const CircularProgressIndicator()
                        : const Text("Save"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
