import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transaction_service.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  Timer? _promoTimer;
  int _currentPromoIndex = 0;

  final List<Map<String, String>> promoBanners = const [
    {
      "title": "TOP UP\nE-WALLET",
      "subtitle": "MENANGKAN\nTOTAL HADIAH\nMILIARAN RUPIAH"
    },
    {
      "title": "DISKON\nSPESIAL",
      "subtitle": "BELANJA\nLEBIH HEMAT\nHARI INI"
    },
    {
      "title": "CASHBACK\nBESAR",
      "subtitle": "DAPATKAN\nBONUS CASHBACK\nSETIAP HARI"
    },
  ];

  @override
  void initState() {
    super.initState();
    _startPromoAutoSlide();
  }

  void _startPromoAutoSlide() {
    _promoTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_pageController.hasClients) return;

      _currentPromoIndex++;
      if (_currentPromoIndex >= promoBanners.length) {
        _currentPromoIndex = 0;
      }

      _pageController.animateToPage(
        _currentPromoIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherService>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              weatherProvider.backgroundGradient[0].withOpacity(0.12),
              Colors.grey[50]!,
            ],
            stops: const [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildBalanceCard(context),
                      const SizedBox(height: 24),
                      _buildGridActions(context),
                      const SizedBox(height: 24),
                      _buildPromoBanners(),
                      _buildPromoIndicators(),
                      const SizedBox(height: 24),
                      _buildFlashDeals(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// HEADER
  /// ===============================
  Widget _buildHeader(BuildContext context) {
    final weatherProvider = Provider.of<WeatherService>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue[600],
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Matt Shadow',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Row(
                children: [
                  Text(
                    weatherProvider.currentTime,
                    style: TextStyle(
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(weatherProvider.weatherIcon,
                      size: 14, color: Colors.blue[800]),
                  const SizedBox(width: 4),
                  Text(
                    weatherProvider.weatherText,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              const Icon(Icons.notifications_none, size: 28),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// BALANCE CARD
  /// ===============================
  Widget _buildBalanceCard(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text(
                    'Total Saldo',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.visibility_outlined,
                      color: Colors.white, size: 16),
                ],
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Menu Riwayat ditekan")),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Text('Riwayat',
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                      Icon(Icons.chevron_right,
                          color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Rp ${transactionProvider.balance.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text('Tabungan',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                        Icon(Icons.chevron_right,
                            color: Colors.white, size: 14),
                      ],
                    ),
                    Text(
                      'Rp ${transactionProvider.balance.toStringAsFixed(0)}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '2,5% p.a. cair harian',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.8), fontSize: 10),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Deposito',
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                        Icon(Icons.chevron_right,
                            color: Colors.white, size: 14),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Rp 0',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// GRID ACTIONS
  /// ===============================
  Widget _buildGridActions(BuildContext context) {
    final transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    final List<Map<String, dynamic>> actions = [
      {
        'icon': Icons.swap_horiz,
        'label': 'Transfer',
        'onTap': () => _showTransferDialog(context, transactionProvider)
      },
      {
        'icon': Icons.phone_android,
        'label': 'Top Up &\nTagihan',
        'onTap': () => _showTopUpDialog(context, transactionProvider)
      },
      {'icon': Icons.account_balance_wallet, 'label': 'Top Up E-\nWallet'},
      {'icon': Icons.person_add, 'label': 'Undang\nTeman'},
      {'icon': Icons.savings, 'label': 'Deposito'},
      {
        'icon': Icons.atm,
        'label': 'Tarik Tunai',
        'onTap': () => _showWithdrawDialog(context, transactionProvider)
      },
      {'icon': Icons.upload, 'label': 'Setor Tunai'},
      {'icon': Icons.grid_view, 'label': 'Lihat Semua'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: actions[index]['onTap'],
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(actions[index]['icon'], color: Colors.blue[600]),
              ),
              const SizedBox(height: 8),
              Text(
                actions[index]['label'],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ===============================
  /// PROMO BANNERS AUTO SLIDE
  /// ===============================
  Widget _buildPromoBanners() {
    return SizedBox(
      height: 110,
      child: PageView.builder(
        controller: _pageController,
        itemCount: promoBanners.length,
        onPageChanged: (index) {
          setState(() {
            _currentPromoIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final banner = promoBanners[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _promoItem(banner["title"]!, banner["subtitle"]!),
          );
        },
      ),
    );
  }

  Widget _buildPromoIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(promoBanners.length, (index) {
        final bool active = _currentPromoIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          width: active ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? Colors.blue : Colors.grey[400],
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }

  Widget _promoItem(String title, String subtitle) {
    return Container(
      width: double.infinity,
      height: 108,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue[400]!, Colors.blue[700]!]),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.phone_iphone, color: Colors.white, size: 40),
        ],
      ),
    );
  }

  /// ===============================
  /// FLASH DEALS
  /// ===============================
  Widget _buildFlashDeals() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt, color: Colors.blue[600]),
              const SizedBox(width: 4),
              const Text(
                'Deposito Flash Deals',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Dimulai dalam ',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              _timerBox('41'),
              _timerBox('17'),
              _timerBox('56'),
              const Icon(Icons.expand_less, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _dealItem(
                'Jangan Lewatkan 🔥',
                'Penawaran terbatas dimulai pada Senin 7:00 PM',
                '12 bulan',
                '7% p.a.',
                '50 kuota',
              ),
              const SizedBox(width: 12),
              _dealItem(
                'Favorit ⭐',
                'Suku bunga tinggi untuk masa depan',
                '6 bulan',
                '6,5% p.a.',
                '150 kuota',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timerBox(String value) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _dealItem(
      String title, String sub, String tenure, String rate, String quota) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: const TextStyle(fontSize: 7, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(tenure, style: const TextStyle(fontSize: 9)),
            Text(
              rate,
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              quota,
              style: const TextStyle(fontSize: 7, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// DIALOGS
  /// ===============================
  void _showTopUpDialog(BuildContext context, TransactionProvider provider) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Top Up Saldo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Jumlah Nominal',
            prefixText: 'Rp ',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0;
              if (amount > 0) {
                provider.topUp(amount);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Top Up Berhasil!')),
                );
              }
            },
            child: const Text('Top Up'),
          ),
        ],
      ),
    );
  }

  void _showTransferDialog(BuildContext context, TransactionProvider provider) {
    final amountController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Transfer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Penerima'),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Nominal',
                prefixText: 'Rp ',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text) ?? 0;
              final name = nameController.text;

              if (amount > 0 && name.isNotEmpty) {
                if (provider.balance >= amount) {
                  provider.transfer(amount, name);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Transfer Berhasil!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saldo tidak cukup!')),
                  );
                }
              }
            },
            child: const Text('Transfer'),
          ),
        ],
      ),
    );
  }

  void _showWithdrawDialog(BuildContext context, TransactionProvider provider) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tarik Tunai'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Jumlah Nominal',
            prefixText: 'Rp ',
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text) ?? 0;

              if (amount > 0) {
                if (provider.balance >= amount) {
                  provider.withdraw(amount);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Tarik Tunai Berhasil!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saldo tidak cukup!')),
                  );
                }
              }
            },
            child: const Text('Tarik Tunai'),
          ),
        ],
      ),
    );
  }
}