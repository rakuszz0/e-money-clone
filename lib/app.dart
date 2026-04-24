import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/finance_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/qris_screen.dart';

/// ===============================
/// APP ROOT
/// ===============================
class EWalletApp extends StatelessWidget {
  const EWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const MainNavigation(),
    );
  }
}

/// ===============================
/// MAIN NAVIGATION
/// ===============================
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  /// REAL SCREENS
  final List<Widget> _pages = const [
    HomeScreen(),
    HistoryScreen(),
    FinanceScreen(),
    ProfileScreen(),
  ];

  void _changePage(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      /// ===============================
      /// QRIS FLOATING BUTTON
      /// ===============================
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const QRISScreen(),
            ),
          );
        },
        child: const Icon(Icons.qr_code_scanner, size: 30),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      /// ===============================
      /// FINTECH NAVBAR
      /// ===============================
      bottomNavigationBar: _buildFintechNavbar(),
    );
  }

  /// ===============================
  /// FINTECH NAVBAR
  /// ===============================
  Widget _buildFintechNavbar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      elevation: 12,
      child: SizedBox(
        height: 70,
        child: Row(
          children: [
            /// LEFT SIDE
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navItem(
                    icon: Icons.home_rounded,
                    label: "Beranda",
                    index: 0,
                  ),
                  _navItem(
                    icon: Icons.swap_horiz_rounded,
                    label: "Riwayat",
                    index: 1,
                  ),
                ],
              ),
            ),

            /// SPACE FOR QRIS
            const SizedBox(width: 70),

            /// RIGHT SIDE
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _navItem(
                    icon: Icons.account_balance_wallet_rounded,
                    label: "Keuangan",
                    index: 2,
                  ),
                  _navItem(
                    icon: Icons.person_rounded,
                    label: "Saya",
                    index: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// NAV ITEM
  /// ===============================
  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isActive = _currentIndex == index;

    return InkWell(
      onTap: () => _changePage(index),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 26,
            color: isActive ? Colors.blue : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  isActive ? FontWeight.w600 : FontWeight.normal,
              color: isActive ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}