import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator; //thông báo lỗi
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onTogglePassword;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.validator,
    this.isPassword = false,
    this.obscureText = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: onTogglePassword,
          )
              : null,
        ),
        validator: validator,
      ),
    );
  }
}
