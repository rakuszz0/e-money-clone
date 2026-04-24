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
    final provider = Provider.of<TransactionProvider>(context);

    List<Transaction> transactions = provider.transactions.where((tx) {
      if (_filterService == 'Semua') return true;
      return tx.type == _filterService;
    }).toList();

    // SORT
    if (_sortBy == "Tanggal") {
      transactions.sort((a, b) => b.date.compareTo(a.date));
    } else if (_sortBy == "Nominal") {
      double parseAmount(String amount) {
        String clean = amount
            .replaceAll("Rp", "")
            .replaceAll("-", "")
            .replaceAll(".", "")
            .trim();
        return double.tryParse(clean) ?? 0;
      }

      transactions.sort((a, b) => parseAmount(b.amount).compareTo(parseAmount(a.amount)));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Riwayat Transaksi',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: transactions.isEmpty
                ? _emptyState()
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      return _transactionCard(tx);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// EMPTY STATE
  /// ===============================
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.receipt_long, size: 70, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "Belum ada transaksi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            "Transaksi kamu akan muncul di sini.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// FILTER SECTION
  /// ===============================
  Widget _buildFilterSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _filterChip(
            label: 'Sort: $_sortBy',
            onTap: _showSortOptions,
            icon: Icons.sort,
          ),
          const SizedBox(width: 10),
          _filterChip(
            label: 'Layanan: $_filterService',
            onTap: _showServiceFilter,
            icon: Icons.filter_alt_outlined,
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return ActionChip(
      onPressed: onTap,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      label: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// ===============================
  /// TRANSACTION CARD
  /// ===============================
  Widget _transactionCard(Transaction tx) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _showTransactionDetail(tx),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: tx.color.withOpacity(0.15),
              child: Icon(tx.icon, color: tx.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${tx.date} • ${tx.method}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              tx.amount,
              style: TextStyle(
                color: tx.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// DETAIL TRANSACTION
  /// ===============================
  void _showTransactionDetail(Transaction tx) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 16),

            CircleAvatar(
              radius: 30,
              backgroundColor: tx.color.withOpacity(0.15),
              child: Icon(tx.icon, color: tx.color, size: 30),
            ),
            const SizedBox(height: 12),

            Text(
              tx.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            Text(
              tx.amount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: tx.color,
              ),
            ),

            const SizedBox(height: 18),

            _detailRow("Tanggal", tx.date),
            _detailRow("Jenis", tx.type),
            _detailRow("Metode", tx.method),

            const SizedBox(height: 18),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text("Tutup"),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// SORT OPTIONS
  /// ===============================
  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                "Urutkan Berdasarkan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.date_range),
              title: const Text("Tanggal"),
              trailing: _sortBy == "Tanggal"
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => _sortBy = "Tanggal");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payments),
              title: const Text("Nominal"),
              trailing: _sortBy == "Nominal"
                  ? const Icon(Icons.check, color: Colors.blue)
                  : null,
              onTap: () {
                setState(() => _sortBy = "Nominal");
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// FILTER SERVICE
  /// ===============================
  void _showServiceFilter() {
    final services = ['Semua', 'Transfer', 'Top Up', 'Withdraw', 'Coins'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                "Pilih Layanan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ...services.map((service) {
              return ListTile(
                title: Text(service),
                trailing: _filterService == service
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  setState(() => _filterService = service);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}