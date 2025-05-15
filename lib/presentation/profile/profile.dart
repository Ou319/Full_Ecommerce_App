import 'package:ecomme_app/app/supabase_auth_service.dart';
import 'package:ecomme_app/presentation/profile/EditProfile.dart';
// import 'package:ecomme_app/core/services/supabase_auth_service.dart';
import 'package:ecomme_app/presentation/ressourses/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _authService = SupabaseAuthService();

  String? _fullName;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final profile = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      setState(() {
        _email = profile['email'];
        _fullName = profile['full_name'];
      });
    }
  }

  Future<void> _signOut() async {
    final error = await _authService.signOut();
    if (error != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Editprofile()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 16, top: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColor.grey,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _fullName != null && _fullName!.isNotEmpty
                                ? _fullName![0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.person_outline,
                                    size: 20, color: Color(0xFF666666)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _fullName ?? 'Loading...',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.email_outlined,
                                    size: 20, color: Color(0xFF666666)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _email ?? '',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: const Color(0xFF666666),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Settings Options
              Text(
                'Preferences',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingItem(
                icon: Icons.download,
                title: 'Storage',
                onTap: () {},
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              _buildSettingItem(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {},
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              _buildSettingItem(
                icon: Icons.support_agent,
                title: 'Customer Support',
                onTap: () {},
              ),
              const SizedBox(height: 24),

              Text(
                'Other',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingItem(
                icon: Icons.info_outline,
                title: 'About Us',
                onTap: () {},
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              _buildSettingItem(
                icon: Icons.new_releases_outlined,
                title: "What's New",
                onTap: () {},
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              _buildSettingItem(
                icon: Icons.find_replace_outlined,
                title: 'Discover Finalcad',
                onTap: () {},
              ),
              const SizedBox(height: 24),

              Text(
                'New Features',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingItem(
                icon: Icons.view_comfortable,
                title: 'Vote for new features',
                onTap: () {},
              ),
              const SizedBox(height: 24),

              Text(
                'Account',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: const Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingItem(
                icon: Icons.logout,
                title: 'Sign Out',
                isSignOut: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(); // Close dialog
                            await _signOut();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isSignOut = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSignOut ? Colors.red.withOpacity(0.1) : AppColor.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSignOut ? Colors.red : Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: isSignOut ? Colors.red : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (!isSignOut)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF999999),
              ),
          ],
        ),
      ),
    );
  }
}
