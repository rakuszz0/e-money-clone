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
  List<Transaction> get transactions => _transactions;

  void addTransaction(String title, double amount, String type, String method, IconData icon, Color color) {
    bool isExpense = amount < 0;
    
    // Update balance
    _balance += amount;
    
    // Add coins if it's a transaction (not top up)
    if (isExpense) {
      _coins += (amount.abs() * 0.01).toInt(); // 1% of transaction amount
    }

    // Add to history
    _transactions.insert(0, Transaction(
      title: title,
      date: DateTime.now().toString().split(' ')[0],
      amount: '${amount > 0 ? 'Rp ' : '-Rp '}${amount.abs().toStringAsFixed(0)}',
      type: type,
      method: method,
      icon: icon,
      color: color,
    ));

    notifyListeners();
  }

  void topUp(double amount) {
    addTransaction('Top Up Saldo', amount, 'Top Up', 'Bank Transfer', Icons.add_circle, Colors.green);
  }

  void transfer(double amount, String recipient) {
    addTransaction('Transfer ke $recipient', -amount, 'Transfer', 'Wallet', Icons.send, Colors.red);
  }

  void withdraw(double amount) {
    addTransaction('Tarik Tunai', -amount, 'Withdraw', 'ATM', Icons.atm, Colors.orange);
  }
}
