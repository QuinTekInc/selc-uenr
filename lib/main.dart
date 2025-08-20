import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:selc_uenr/pages/get_started.dart';
import 'package:selc_uenr/providers/selc_provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      ChangeNotifierProvider(
        create: (_) => SelcProvider(),

        child: const SelcApp(),
      ),
  );
}

class SelcApp extends StatelessWidget {

  const SelcApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SELC UENR',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const GetStartedPage(),
    );
  }
}

