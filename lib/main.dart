import 'package:flutter/material.dart';
import 'package:cafe_management_system/core/local.dart';
import 'package:cafe_management_system/screens/orders_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.instance.init();
  runApp(const CafeManagementSystem());
}

class CafeManagementSystem extends StatelessWidget {
  const CafeManagementSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'نظام إدارة المقهى',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        fontFamily: 'Arial',
      ),
      home: const OrdersListScreen(),
    );
  }
}