import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>{
  final _formkey = GlobalKey<FormState>();
  bool _obscurePassword = true;

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
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                    child: Text('Register', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),),
                  ),
                  Container(
                    height: 80,
                    width: 334,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              Container(
                  height: 80,
                  width: 334,
                  child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          labelText: 'Enter Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          )))),
              Container(
                  height: 80,
                  width: 334,
                  child: TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: (){
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                          )
                      ))),
              TextButton(
                  onPressed: (){},
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(332, 80),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)
                      )
                  ),
                  child: Text('Create Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),)),
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
        )
        ))
    );
  }
}