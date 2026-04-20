import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transaction_service.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keuangan', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoinsCard(transactionProvider.coins),
            const SizedBox(height: 24),
            _buildFundingSources(context),
            const SizedBox(height: 24),
            const Text(
              'Layanan Keuangan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFinanceServices(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinsCard(int coins) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber[300]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('E-Wallet Coins', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                '$coins Coins',
                style: TextStyle(fontSize: 20, color: Colors.amber[900], fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            child: const Text('Tukar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFundingSources(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sumber Dana',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => _showAddFundingSource(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _fundingSourceItem('Bank BCA', '**** 1234', Icons.account_balance),
        const SizedBox(height: 8),
        _fundingSourceItem('Kartu Kredit Visa', '**** 5678', Icons.credit_card),
      ],
    );
  }

  Widget _fundingSourceItem(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          const Spacer(),
          const Icon(Icons.more_vert, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildFinanceServices() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _serviceCard('Simpanan', Icons.savings, Colors.blue),
        _serviceCard('Asuransi', Icons.verified_user, Colors.green),
        _serviceCard('Pinjaman', Icons.request_quote, Colors.orange),
        _serviceCard('Investasi', Icons.trending_up, Colors.purple),
      ],
    );
  }

  Widget _serviceCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showAddFundingSource(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tambah Sumber Dana',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Bank Transfer'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Kartu Debit/Kredit'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
