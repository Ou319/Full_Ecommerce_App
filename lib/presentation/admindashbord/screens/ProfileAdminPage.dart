import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ecomme_app/app/supabase_auth_service.dart';
import 'package:ecomme_app/presentation/ressourses/colormanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profileadminpage extends StatefulWidget {
  const Profileadminpage({super.key});

  @override
  State<Profileadminpage> createState() => _ProfileadminpageState();
}

class _ProfileadminpageState extends State<Profileadminpage> {
  final _authService = SupabaseAuthService();

  String? _fullName;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadAdminProfile();
  }

  Future<void> _loadAdminProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        _fullName = profile['full_name'];
        _email = profile['email'];
      });
    }
  }

  Future<void> _signOut() async {
    final error = await _authService.signOut();
    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColor.blue,
                    child: Text(
                      _fullName != null && _fullName!.isNotEmpty
                          ? _fullName![0].toUpperCase()
                          : '?',
                      style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_fullName ?? 'Loading...',
                          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(_email ?? '',
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 32),

            Text("Admin Tools", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 12),

            _buildAdminItem(icon: Icons.edit_note, title: "Edit Admin Info", onTap: () {}),
            _buildAdminItem(icon: Icons.group, title: "Manage Users", onTap: () {}),
            _buildAdminItem(icon: Icons.inventory_2, title: "Manage Orders", onTap: () {}),

            const SizedBox(height: 24),

            Text("System", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600])),
            const SizedBox(height: 12),

            _buildAdminItem(icon: Icons.settings, title: "Settings", onTap: () {}),
            _buildAdminItem(
              icon: Icons.logout,
              title: "Sign Out",
              isLogout: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Confirm"),
                    content: const Text("Do you want to sign out?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await _signOut();
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isLogout ? Colors.red.withOpacity(0.1) : AppColor.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: isLogout ? Colors.red : Colors.white),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: isLogout ? Colors.red : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (!isLogout)
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
