import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  final _formkey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async{
    if(_formkey.currentState!.validate()){
      setState(() => _isLoading = true);

      try{
        //create account on firebase
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
        );
        if (userCredential.user != null) {
          await userCredential.user!.updateDisplayName(
              _nameController.text.trim());
        }
        // Save data in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'fullName': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'createdAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tạo tài khoản thành công')),
        );
        //Go to HomeScreen
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        String message = 'Xảy ra lỗi';
        if(e.code == 'email-already-in-use'){
          message = 'email đã được sử dụng';
        } else if (e.code == 'invalid-email'){
          message = 'email không hợp lệ';
        } else if (e.code == 'weak-password'){
          message = 'mật khẩu quá yếu';
        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
        );
      } finally{
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isPassword = false,
  }){
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          suffixIcon: isPassword ? IconButton(
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
          ) : null,
        ),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset(
                    'assets/images/loading.png',
                    height: 33,
                    width: 108,
                  ),
                ),
              )
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                    child: Text('Register', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                  ),
                  _buildTextField(
                      label: 'Full Name',
                      controller: _nameController,
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'Please enter your full name';
                        }
                        return null;
                      }
                  ),
                  _buildTextField(
                      label: 'Enter Email',
                      controller: _emailController,
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Please enter your email';
                        }
                        if(!value.contains('@') || !value.contains('.')){
                          return 'Invalid email';
                        }
                        return null;
                      },
                  ),
                  _buildTextField(
                      label: 'Password',
                      controller: _passwordController,
                      isPassword: true,
                      validator:(value){
                        if(value == null || value.isEmpty){
                          return 'Please enter your password';
                        }
                        if(value.length < 6){
                          return 'Your password needs at least 6 characters';
                        }
                        return null;
                      }
                  ),
              TextButton(
                  onPressed:_isLoading ? null : _createAccount,
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(332, 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      )
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                      'Create Account',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)
                    )
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 40,),
                  const Expanded(
                    child: Divider(thickness: 1),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('or',)),
                  const Expanded(child: Divider(thickness: 1,)),
                  SizedBox(width: 40,),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent
                      ),
                      onPressed: (){},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/images/google_icon.png',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,),
                      )
                  ),
                  SizedBox(width: 15,),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent
                      ),
                      onPressed: (){},
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset('assets/images/apple_icon.jpg',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,),
                      )
                  )
                ],
              ),
              RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    children:[
                      const TextSpan(text: 'Do You Have An Account?'),
                      TextSpan(
                        text: ' Sign In',
                        style: const TextStyle(
                          color: Colors.green
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (){
                            Navigator.pushNamed(context, '/signin');
                          }
                      )
                    ]
                  )),

            ],
          ),
        )
        ))
    );
  }
}