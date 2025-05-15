import 'package:ecomme_app/presentation/ressourses/button.dart';
import 'package:ecomme_app/presentation/ressourses/colormanager.dart';
import 'package:ecomme_app/presentation/ressourses/input.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('full_name')
          .eq('id', user.id)
          .single();

      setState(() {
        _usernameController.text = response['full_name'] ?? '';
        _emailController.text = user.email ?? '';
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final user = Supabase.instance.client.auth.currentUser;

    try {
      if (_usernameController.text.isNotEmpty) {
        await Supabase.instance.client
            .from('profiles')
            .update({'full_name': _usernameController.text})
            .eq('id', user!.id);
      }

      if (_emailController.text.isNotEmpty) {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(email: _emailController.text),
        );
      }

      if (_passwordController.text.isNotEmpty) {
        await Supabase.instance.client.auth.updateUser(
          UserAttributes(password: _passwordController.text),
        );
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 30),
            InputAuth(
              controllerName: _usernameController,
              TextInput: 'Full Name',
              iconInput: const Icon(Icons.person),
            ),
            InputAuth(
              controllerName: _emailController,
              TextInput: 'Email',
              iconInput: const Icon(Icons.email),
            ),
            InputAuth(
              controllerName: _passwordController,
              TextInput: 'New Password',
              iconInput: const Icon(Icons.lock),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: GestureDetector(
                onTap: () {
                  if (!_isSaving) {
                    _saveChanges();
                  }
                },
                child: Button(
                  isBorder: false,
                  textInput: _isSaving ? "Saving..." : "Save Changes",
                  colorBg: AppColor.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
