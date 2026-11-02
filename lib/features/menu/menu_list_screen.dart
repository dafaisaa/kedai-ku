import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../../data/menu_repository.dart';
import '../cart/cart_screen.dart';
import '../cart/cart_store.dart';
import '../orders/order_store.dart';
import 'menu.dart';
import 'menu_detail_screen.dart';

/// Daftar menu, dikelompokkan per kategori.
/// Layar ini hanya membaca data dari [MenuRepository], tidak menyimpan daftarnya sendiri.
class MenuListScreen extends StatelessWidget {
  final MenuRepository repository;
  final CartStore cartStore;
  final OrderStore orderStore;

  const MenuListScreen({
    super.key,
    required this.repository,
    required this.cartStore,
    required this.orderStore,
  });

  void _openCart(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CartScreen(cartStore: cartStore, orderStore: orderStore),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];

    for (final category in repository.categories()) {
      rows.add(_CategoryHeader(title: category));
      for (final menu in repository.byCategory(category)) {
        rows.add(_MenuTile(menu: menu, cartStore: cartStore));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kedai-Ku'),
        actions: [
          ListenableBuilder(
            listenable: cartStore,
            builder: (context, _) {
              final count = cartStore.itemCount;
              return IconButton(
                onPressed: () => _openCart(context),
                tooltip: 'Keranjang',
                icon: Badge(
                  isLabelVisible: count > 0,
                  label: Text('$count'),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        // Membatasi lebar supaya di tablet/jendela lebar teks tidak terbentang.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(children: rows),
        ),
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: cartStore,
        builder: (context, _) {
          if (cartStore.isEmpty) return const SizedBox.shrink();

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _openCart(context),
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: Text(
                        'Keranjang (${cartStore.itemCount}) · ${formatRupiah(cartStore.total)}',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String title;

  const _CategoryHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final Menu menu;
  final CartStore cartStore;

  const _MenuTile({required this.menu, required this.cartStore});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // enabled: false membuat tile tampil redup dan tidak bisa diketuk.
      enabled: menu.available,
      title: Text(menu.name),
      subtitle: menu.variants.isEmpty
          ? null
          : Text('${menu.variants.length} pilihan varian'),
      trailing: Text(menu.available ? formatRupiah(menu.price) : 'Habis'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MenuDetailScreen(menu: menu, cartStore: cartStore),
          ),
        );
      },
    );
  }
}
