

import 'package:flutter/material.dart';


class LogoCardImageView extends StatelessWidget {
  const LogoCardImageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset('lib/assets/UENR-Logo.png', height: 120, width: 120,),
      ),
    );
  }
}
