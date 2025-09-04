import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../widgets/custom_appbar.dart';

import '../widgets/register_and_sigin/auth_redirect_text.dart';
import '../widgets/register_and_sigin/field_button.dart';
import '../widgets/register_and_sigin/or_divider.dart';
import '../widgets/register_and_sigin/social_login_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );

      final user = userCred.user;
      if (user != null) {
        await user.updateDisplayName(_nameCtrl.text.trim());
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': _nameCtrl.text.trim(),
          'email': _emailCtrl.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tạo tài khoản thành công')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      final msg = switch (e.code) {
        'email-already-in-use' => 'Email đã được sử dụng',
        'invalid-email' => 'Email không hợp lệ',
        'weak-password' => 'Mật khẩu quá yếu',
        _ => 'Xảy ra lỗi'
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ✅ Widget chung cho TextField
  Widget _field({
    required String label,
    required TextEditingController ctrl,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) =>
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: TextFormField(
          controller: ctrl,
          obscureText: isPassword ? _obscurePassword : false,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            )
                : null,
          ),
          validator: validator,
        ),
      );

  // ✅ Validator
  String? _validate(String? v, String field) {
    if (v == null || v.isEmpty) return 'Please enter your $field';
    if (field == 'email' && (!v.contains('@') || !v.contains('.'))) {
      return 'Invalid email';
    }
    if (field == 'password' && v.length < 6) {
      return 'Your password needs at least 6 characters';
    }
    return null;
  }

  // ✅ Nút social login
  Widget _socialButton(String path) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    onPressed: () {},
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(path, height: 40, width: 40, fit: BoxFit.cover),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onBack: (){
        Navigator.pop(context);
      },),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text('Register',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                const SizedBox(height: 20),

                _field(
                  label: 'Full Name',
                  ctrl: _nameCtrl,
                  validator: (v) => _validate(v, 'full name'),
                ),
                const SizedBox(height: 12),

                _field(
                  label: 'Enter Email',
                  ctrl: _emailCtrl,
                  validator: (v) => _validate(v, 'email'),
                ),
                const SizedBox(height: 12),

                _field(
                  label: 'Password',
                  ctrl: _passCtrl,
                  isPassword: true,
                  validator: (v) => _validate(v, 'password'),
                ),
                const SizedBox(height: 20),
                FieldButton(type: 'createAccount', action: _isLoading ? null : _createAccount),
                const SizedBox(height: 20),
                OrDivider(),
                const SizedBox(height: 15),
                SocialLoginButton(),
                const SizedBox(height: 20),
                AuthRedirectText(type: 'register',),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
