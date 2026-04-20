import 'package:flutter/material.dart';

class QRISScreen extends StatelessWidget {
  const QRISScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Scan QRIS', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Simulated Camera View
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[900],
            child: const Center(
              child: Icon(Icons.camera_alt, color: Colors.white54, size: 100),
            ),
          ),
          // Scanner Overlay
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue[400]!, width: 4),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Arahkan kamera ke kode QRIS',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          // Bottom Actions
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _scanAction(Icons.image, 'Galeri'),
                _scanAction(Icons.history, 'Riwayat'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scanAction(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white24,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
