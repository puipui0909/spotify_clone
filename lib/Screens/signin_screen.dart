import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:spotify_clone/widgets/custom_appbar.dart';
import 'package:spotify_clone/widgets/register_and_sigin/field_button.dart';
import 'package:spotify_clone/widgets/register_and_sigin/text_field.dart';

import '../widgets/register_and_sigin/auth_redirect_text.dart';
import '../widgets/register_and_sigin/or_divider.dart';
import '../widgets/register_and_sigin/social_login_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen ({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = true;
  bool _isLoading = false;

  void _togglePasswordVisibility(){
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()){
        setState(() {
          _isLoading = true;
        });

        try{
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim()
          );

          //go to homescreen after sign in
          Navigator.pushReplacementNamed(context, '/home');
        } on FirebaseAuthException catch (e){
          String message = '';
          if(e.code == 'user-not-found'){
            message = 'Email không tồn tại';
          } else if (e.code == 'wrong-password'){
            message = 'Mật khẩu không chính xác';
          }else {
            message = 'Lỗi: ${e.message}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onBack: (){
        Navigator.pop(context);
      }),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                      SizedBox(height: 49,),
                      CustomTextField(
                          label: 'Enter Your Email',
                          controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập email';
                          }
                          if (!value.contains('@')) {
                            return 'Email không hợp lệ';
                          }
                          return null; // hợp lệ
                        },
                      ),
                      SizedBox(height: 8,),
                      CustomTextField(
                          label: 'Password',
                          controller: _passwordController,
                          isPassword: true,
                          validator: (value){
                            if(value == null || value.isEmpty)
                              return 'Mật khẩu không được để trống';
                            if(value.length < 6)
                              return 'Mật khẩu phải dài hơn 6 kí tự';
                            return null;
                          }),
                    ],
                  ),
              ),
              SizedBox(height: 4,),
              Padding(
                  padding: const EdgeInsets.only(left: 47.0, bottom: 15),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          overlayColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory
                        ),
                        onPressed: (){},
                        child: Text('Recovery Password', style: TextStyle(fontSize: 14),)),
                  ),
              ),
              FieldButton(type: 'sign in', action: _isLoading ? null : _signIn),
              SizedBox(height: 15,),
              OrDivider(),
              SocialLoginButton(),
              SizedBox(height: 15,),
              AuthRedirectText(type: 'signin')
            ],
          ),
        ),
      ),
    );
  }


}