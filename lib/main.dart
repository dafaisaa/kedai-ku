import 'package:flutter/material.dart';

import 'data/menu_repository.dart';
import 'features/cart/cart_store.dart';
import 'features/menu/menu_list_screen.dart';
import 'features/orders/order_store.dart';

void main() => runApp(KedaiKuApp(repository: MenuRepository()));

class KedaiKuApp extends StatelessWidget {
  final MenuRepository repository;
  final CartStore cartStore;
  final OrderStore orderStore;

  KedaiKuApp({
    super.key,
    required this.repository,
    CartStore? cartStore,
    OrderStore? orderStore,
  }) : cartStore = cartStore ?? CartStore(),
       orderStore = orderStore ?? OrderStore();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kedai-Ku',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.brown, useMaterial3: true),
      home: MenuListScreen(
        repository: repository,
        cartStore: cartStore,
        orderStore: orderStore,
      ),
    );
  }
}
