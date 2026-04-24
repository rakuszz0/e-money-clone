import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "Matt Shadow";
  String phone = "+62 813 6998 2308";
  bool isPremium = true;

  String profileImageUrl = "https://i.pravatar.cc/300";

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: name);
    final phoneController = TextEditingController(text: phone);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ubah Profil"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "Nomor HP"),
              keyboardType: TextInputType.phone,
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
              setState(() {
                name = nameController.text.trim();
                phone = phoneController.text.trim();
              });
              Navigator.pop(context);
              _showSnack("Profil berhasil diperbarui!");
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _showChangePhotoDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text("Ambil Foto (Dummy)"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  profileImageUrl = "https://i.pravatar.cc/300?img=15";
                });
                _showSnack("Foto profil berhasil diubah!");
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Pilih dari Galeri (Dummy)"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  profileImageUrl = "https://i.pravatar.cc/300?img=30";
                });
                _showSnack("Foto profil berhasil diubah!");
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text("Hapus Foto", style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  profileImageUrl = "https://i.pravatar.cc/300";
                });
                _showSnack("Foto profil direset!");
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSecurityDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Keamanan & PIN"),
        content: const Text("Fitur ini untuk mengatur PIN / password.\n(Dummy Feature)"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _showBankDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Rekening Bank"),
        content: const Text("Belum ada rekening yang terhubung.\n(Dummy Feature)"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnack("Tambah rekening bank (dummy)");
            },
            child: const Text("Tambah"),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pusat Bantuan"),
        content: const Text("Hubungi CS: support@ewallet.com\n(Dummy Feature)"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _showTerms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Syarat & Ketentuan"),
        content: const Text(
          "Ini adalah syarat & ketentuan aplikasi.\n(Dummy Feature)",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tentang Aplikasi"),
        content: const Text(
          "E-Wallet App\nVersi 1.0.0\n\nDibuat menggunakan Flutter.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Keluar"),
        content: const Text("Apakah kamu yakin ingin keluar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _showSnack("Logout berhasil (dummy)");
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  void _togglePremium() {
    setState(() {
      isPremium = !isPremium;
    });

    _showSnack(isPremium ? "Upgrade ke Premium!" : "Downgrade ke Basic!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSnack("Settings (dummy)");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileHeader(),
            const SizedBox(height: 24),

            _buildSectionTitle("Akun"),
            _buildCardMenu([
              _menuItem(
                icon: Icons.person_outline,
                title: "Ubah Profil",
                onTap: _showEditProfileDialog,
              ),
              _menuItem(
                icon: Icons.security,
                title: "Keamanan & PIN",
                onTap: _showSecurityDialog,
              ),
              _menuItem(
                icon: Icons.account_balance,
                title: "Rekening Bank",
                onTap: _showBankDialog,
              ),
            ]),

            const SizedBox(height: 18),

            _buildSectionTitle("Info Lainnya"),
            _buildCardMenu([
              _menuItem(
                icon: Icons.help_outline,
                title: "Pusat Bantuan",
                onTap: _showHelpCenter,
              ),
              _menuItem(
                icon: Icons.description,
                title: "Syarat & Ketentuan",
                onTap: _showTerms,
              ),
              _menuItem(
                icon: Icons.info_outline,
                title: "Tentang Aplikasi",
                onTap: _showAbout,
              ),
            ]),

            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _confirmLogout,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Keluar'),
                ),
              ),
            ),

            const SizedBox(height: 18),
            const Text(
              'Versi 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// ===============================
  /// PROFILE HEADER
  /// ===============================
  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _showChangePhotoDialog,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt,
                      color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          phone,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: _togglePremium,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isPremium ? Colors.amber[100] : Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isPremium ? "Member Premium ⭐" : "Member Basic",
              style: TextStyle(
                color: isPremium ? Colors.orange[900] : Colors.blue[800],
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ===============================
  /// SECTION TITLE
  /// ===============================
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// CARD MENU
  /// ===============================
  Widget _buildCardMenu(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  /// ===============================
  /// MENU ITEM
  /// ===============================
  Widget _menuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue[700]),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}