import 'package:flutter/material.dart';



class RegisterScreen extends StatelessWidget{
  const RegisterScreen({super.key});
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          //key: _formKey,
          child: Column(
            children: [
              TextFormField(
                //controller: _nameController,
                decoration: InputDecoration(labelText: "Tên"),
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                //controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value == null || value.isEmpty ? 'Vui lòng nhập email' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                //controller: _passwordController,
                decoration: InputDecoration(labelText: "Mật khẩu"),
                obscureText: true,
                validator: (value) => value != null && value.length < 6
                    ? 'Mật khẩu ít nhất 6 ký tự'
                    : null,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: (){},
                child: Text("Đăng ký"),
              ),
            ],
          ),
        ),
      ),
    );
  }

}