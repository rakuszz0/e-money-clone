import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transaction_service.dart';

class FinanceScreen extends StatefulWidget {
  const FinanceScreen({super.key});

  @override
  State<FinanceScreen> createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  final List<Map<String, dynamic>> fundingSources = [
    {
      "title": "Bank BCA",
      "subtitle": "**** 1234",
      "icon": Icons.account_balance,
    },
    {
      "title": "Kartu Kredit Visa",
      "subtitle": "**** 5678",
      "icon": Icons.credit_card,
    },
  ];

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Keuangan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoinsCard(provider),
            const SizedBox(height: 24),
            _buildFundingSources(),
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

  /// ===============================
  /// COINS CARD
  /// ===============================
  Widget _buildCoinsCard(TransactionProvider provider) {
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
              const Text(
                'E-Wallet Coins',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${provider.coins} Coins',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.amber[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () => _showRedeemCoinsDialog(provider),
            child: const Text('Tukar'),
          ),
        ],
      ),
    );
  }

  void _showRedeemCoinsDialog(TransactionProvider provider) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tukar Coins"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Masukkan jumlah coins yang ingin ditukar menjadi saldo.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Jumlah Coins",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "1 Coin = Rp 100",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final coins = int.tryParse(controller.text) ?? 0;

              if (coins <= 0) {
                _showSnack("Masukkan jumlah coins yang valid!");
                return;
              }

              if (coins > provider.coins) {
                _showSnack("Coins tidak cukup!");
                return;
              }

              provider.redeemCoins(coins);

              Navigator.pop(context);
              _showSnack("Berhasil menukar $coins coins!");
            },
            child: const Text("Tukar"),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// FUNDING SOURCES
  /// ===============================
  Widget _buildFundingSources() {
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
              onPressed: _showAddFundingSourceSheet,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...fundingSources.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _fundingSourceItem(item),
          );
        }).toList(),
      ],
    );
  }

  Widget _fundingSourceItem(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(item["icon"], color: Colors.blue[800]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  item["subtitle"],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "edit") {
                _showEditFundingSourceDialog(item);
              } else if (value == "delete") {
                _showDeleteFundingSourceDialog(item);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: "edit", child: Text("Edit")),
              PopupMenuItem(value: "delete", child: Text("Hapus")),
            ],
            child: const Icon(Icons.more_vert, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showEditFundingSourceDialog(Map<String, dynamic> item) {
    final titleController = TextEditingController(text: item["title"]);
    final subtitleController = TextEditingController(text: item["subtitle"]);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Sumber Dana"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: subtitleController,
              decoration: const InputDecoration(labelText: "Nomor / Info"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final newTitle = titleController.text.trim();
              final newSubtitle = subtitleController.text.trim();

              if (newTitle.isEmpty || newSubtitle.isEmpty) {
                _showSnack("Data tidak boleh kosong!");
                return;
              }

              setState(() {
                item["title"] = newTitle;
                item["subtitle"] = newSubtitle;
              });

              Navigator.pop(context);
              _showSnack("Sumber dana berhasil diperbarui!");
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showDeleteFundingSourceDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Sumber Dana"),
        content: Text("Apakah kamu yakin ingin menghapus ${item["title"]}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                fundingSources.remove(item);
              });
              Navigator.pop(context);
              _showSnack("Sumber dana berhasil dihapus!");
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  void _showAddFundingSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
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
                onTap: () {
                  Navigator.pop(context);
                  _showAddFundingFormDialog(isBank: true);
                },
              ),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Kartu Debit/Kredit'),
                onTap: () {
                  Navigator.pop(context);
                  _showAddFundingFormDialog(isBank: false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddFundingFormDialog({required bool isBank}) {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isBank ? "Tambah Bank" : "Tambah Kartu"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: isBank ? "Nama Bank" : "Nama Kartu",
              ),
            ),
            TextField(
              controller: subtitleController,
              decoration: const InputDecoration(
                labelText: "Nomor / Info",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final subtitle = subtitleController.text.trim();

              if (title.isEmpty || subtitle.isEmpty) {
                _showSnack("Lengkapi data terlebih dahulu!");
                return;
              }

              setState(() {
                fundingSources.add({
                  "title": title,
                  "subtitle": subtitle,
                  "icon": isBank ? Icons.account_balance : Icons.credit_card,
                });
              });

              Navigator.pop(context);
              _showSnack("Sumber dana berhasil ditambahkan!");
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// FINANCE SERVICES
  /// ===============================
  Widget _buildFinanceServices() {
    final services = [
      {"title": "Simpanan", "icon": Icons.savings, "color": Colors.blue},
      {"title": "Asuransi", "icon": Icons.verified_user, "color": Colors.green},
      {"title": "Pinjaman", "icon": Icons.request_quote, "color": Colors.orange},
      {"title": "Investasi", "icon": Icons.trending_up, "color": Colors.purple},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: services.map((service) {
        return _serviceCard(
          title: service["title"] as String,
          icon: service["icon"] as IconData,
          color: service["color"] as Color,
        );
      }).toList(),
    );
  }

  Widget _serviceCard({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openService(title),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _openService(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceDetailScreen(serviceName: title),
      ),
    );
  }
}

class ServiceDetailScreen extends StatelessWidget {
  final String serviceName;

  const ServiceDetailScreen({super.key, required this.serviceName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceName),
      ),
      body: Center(
        child: Text(
          "$serviceName (Coming Soon)",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}