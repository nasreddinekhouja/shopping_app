import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/viewmodels/shoppingcartProvider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'views/loginscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_super_parameters
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ShoppingCart()),
      ],
      child: MaterialApp(
        title: 'Store App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
