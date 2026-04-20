import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transaction_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _sortBy = 'Tanggal';
  String _filterService = 'Semua';

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final transactions = transactionProvider.transactions.where((tx) {
      if (_filterService == 'Semua') return true;
      return tx.type == _filterService;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text('Belum ada transaksi'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: tx.color.withValues(alpha: 0.1),
                          child: Icon(tx.icon, color: tx.color),
                        ),
                        title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${tx.date} • ${tx.method}'),
                        trailing: Text(
                          tx.amount,
                          style: TextStyle(
                            color: tx.color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _filterChip('Sort: $_sortBy', () => _showSortOptions()),
          const SizedBox(width: 8),
          _filterChip('Layanan: $_filterService', () => _showServiceFilter()),
          const SizedBox(width: 8),
          _filterChip('Metode', () {}),
        ],
      ),
    );
  }

  Widget _filterChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.grey[100],
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('Urutkan Berdasarkan'), tileColor: Colors.grey[100]),
          ListTile(
            title: const Text('Tanggal'),
            onTap: () {
              setState(() => _sortBy = 'Tanggal');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Nominal'),
            onTap: () {
              setState(() => _sortBy = 'Nominal');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showServiceFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(title: const Text('Pilih Layanan'), tileColor: Colors.grey[100]),
          ...['Semua', 'Transfer', 'Top Up', 'Withdraw', 'QRIS'].map((service) {
            return ListTile(
              title: Text(service),
              onTap: () {
                setState(() => _filterService = service);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ],
      ),
    );
  }
}
