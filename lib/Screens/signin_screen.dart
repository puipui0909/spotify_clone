import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen ({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: (){

                },
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
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                      SizedBox(height: 49,),
                      Container(
                          height: 80,
                          width: 334,
                          child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                  labelText: 'Enter Your Email',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
                              ))),
                      SizedBox(height: 8,),
                      Container(
                          height: 80,
                          width: 334,
                          child: TextFormField(
                              controller: _passwordController,
                              obscureText: _isPasswordVisible,
                              decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                    ),
                                    onPressed: (){
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                contentPadding: EdgeInsets.symmetric(vertical: 25, horizontal: 16),
                              ))),
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
              TextButton(
                  onPressed: _isLoading ? null : _signIn,
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(332, 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      )
                  ),
                  child: Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),)),
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
              Text('Do You Have An Account? Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),)
            ],
          ),
        ),
      ),
    );
  }


}