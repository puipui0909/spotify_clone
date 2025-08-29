import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final Widget? action;

  const CustomAppBar({super.key, this.onBack, this.action});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if(onBack != null)
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack,
          )
          else if(action != null)
            action!,
          const Spacer(),
          Image.asset('assets/images/loading.png', height: 33, width: 108),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
