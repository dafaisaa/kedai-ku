import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../cart/cart_line.dart';
import '../cart/cart_store.dart';
import 'menu.dart';

/// Detail satu menu: pilih varian, jumlah, dan catatan.
class MenuDetailScreen extends StatefulWidget {
  final Menu menu;
  final CartStore cartStore;

  const MenuDetailScreen({
    super.key,
    required this.menu,
    required this.cartStore,
  });

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen> {
  Variant? _variant;
  int _quantity = 1;
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  /// Baris keranjang yang akan dibuat dari pilihan saat ini.
  CartLine get _line => CartLine(
    menu: widget.menu,
    variant: _variant,
    quantity: _quantity,
    note: _noteController.text.trim(),
  );

  void _addToCart() {
    widget.cartStore.add(_line);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${_line.quantity}x ${widget.menu.name} ditambahkan ke keranjang',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(menu.name)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(menu.name, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                '${menu.category} · ${formatRupiah(menu.price)}',
                style: theme.textTheme.bodyLarge,
              ),
              if (menu.variants.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Varian', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final v in menu.variants)
                      ChoiceChip(
                        label: Text(
                          v.extraPrice > 0
                              ? '${v.name} (+${formatRupiah(v.extraPrice)})'
                              : v.name,
                        ),
                        selected: _variant == v,
                        onSelected: (selected) {
                          setState(() => _variant = selected ? v : null);
                        },
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Text('Jumlah', style: theme.textTheme.titleMedium),
              Row(
                children: [
                  IconButton(
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    tooltip: 'Kurangi',
                  ),
                  Text('$_quantity', style: theme.textTheme.titleLarge),
                  IconButton(
                    onPressed: () => setState(() => _quantity++),
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Tambah',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  hintText: 'Mis. tanpa es',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _addToCart,
                  child: Text('Tambah · ${formatRupiah(_line.subtotal)}'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
