import 'package:ecommerce_app/presentation/home_bloc/home_event.dart';
import 'package:ecommerce_app/presentation/product_list.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/service_locator.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/presentation/home_bloc/home_block.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: BlocProvider<HomeBloc>(
        create: (context) => di.getIt<HomeBloc>()..add(ImageFetch()),
        child: ProductList(), // Your first screen
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
