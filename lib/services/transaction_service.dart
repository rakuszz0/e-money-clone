import 'package:flutter/material.dart';

class Transaction {
  final String title;
  final String date;
  final String amount;
  final String type;
  final String method;
  final IconData icon;
  final Color color;

  Transaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
    required this.method,
    required this.icon,
    required this.color,
  });
}

class TransactionProvider with ChangeNotifier {
  double _balance = 5744.0;
  int _coins = 1250;

  final List<Transaction> _transactions = [
    Transaction(
      title: 'Top Up Dana',
      date: '2024-04-18',
      amount: 'Rp 500.000',
      type: 'Top Up',
      method: 'Bank Transfer',
      icon: Icons.add_circle,
      color: Colors.green,
    ),
  ];

  double get balance => _balance;
  int get coins => _coins;
  List<Transaction> get transactions => List.unmodifiable(_transactions);

  String _formatRupiah(double amount) {
    final value = amount.abs().toStringAsFixed(0);
    return amount >= 0 ? "Rp $value" : "-Rp $value";
  }

  void _addCoinsFromExpense(double amount) {
    // reward coins 1% dari transaksi pengeluaran
    final reward = (amount.abs() * 0.01).toInt();
    if (reward > 0) {
      _coins += reward;
    }
  }

  void addTransaction({
    required String title,
    required double amount,
    required String type,
    required String method,
    required IconData icon,
    required Color color,
  }) {
    _balance += amount;

    // coins reward hanya jika transaksi pengeluaran
    if (amount < 0) {
      _addCoinsFromExpense(amount);
    }

    _transactions.insert(
      0,
      Transaction(
        title: title,
        date: DateTime.now().toString().split(' ')[0],
        amount: _formatRupiah(amount),
        type: type,
        method: method,
        icon: icon,
        color: color,
      ),
    );

    notifyListeners();
  }

  void topUp(double amount) {
    if (amount <= 0) return;

    addTransaction(
      title: 'Top Up Saldo',
      amount: amount,
      type: 'Top Up',
      method: 'Bank Transfer',
      icon: Icons.add_circle,
      color: Colors.green,
    );
  }

  void transfer(double amount, String recipient) {
    if (amount <= 0) return;

    addTransaction(
      title: 'Transfer ke $recipient',
      amount: -amount,
      type: 'Transfer',
      method: 'Wallet',
      icon: Icons.send,
      color: Colors.red,
    );
  }

  void withdraw(double amount) {
    if (amount <= 0) return;

    addTransaction(
      title: 'Tarik Tunai',
      amount: -amount,
      type: 'Withdraw',
      method: 'ATM',
      icon: Icons.atm,
      color: Colors.orange,
    );
  }

  void redeemCoins(int amount) {
    if (amount <= 0) return;
    if (amount > _coins) return;

    _coins -= amount;

    // 1 coin = Rp 100
    final double rupiah = amount * 100;

    addTransaction(
      title: "Tukar Coins",
      amount: rupiah,
      type: "Coins",
      method: "E-Wallet Coins",
      icon: Icons.monetization_on,
      color: Colors.amber,
    );
  }
}