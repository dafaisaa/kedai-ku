import 'package:flutter/material.dart';

import '../../core/format.dart';
import '../orders/order_status_screen.dart';
import '../orders/order_store.dart';
import 'cart_line.dart';
import 'cart_store.dart';

/// Keranjang + konfirmasi pesanan (nama pemesan dan jam ambil).
class CartScreen extends StatefulWidget {
  final CartStore cartStore;
  final OrderStore orderStore;

  const CartScreen({
    super.key,
    required this.cartStore,
    required this.orderStore,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _nameController = TextEditingController();
  TimeOfDay? _pickupTime;
  String? _nameError;
  String? _timeError;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _pickupTime ?? TimeOfDay.now(),
    );
    if (picked != null && mounted) {
      setState(() {
        _pickupTime = picked;
        _timeError = null;
      });
    }
  }

  void _submit() {
    final name = _nameController.text.trim();
    final time = _pickupTime;
    String? nameError;
    String? timeError;
    DateTime? pickup;

    if (name.isEmpty) nameError = 'Nama wajib diisi';
    if (time == null) {
      timeError = 'Pilih jam ambil';
    } else {
      final now = DateTime.now();
      pickup = DateTime(now.year, now.month, now.day, time.hour, time.minute);
      if (pickup.isBefore(now)) timeError = 'Jam ambil sudah lewat';
    }

    if (nameError != null || timeError != null || pickup == null) {
      setState(() {
        _nameError = nameError;
        _timeError = timeError;
      });
      return;
    }

    final order = widget.orderStore.place(
      customerName: name,
      pickupTime: pickup,
      lines: widget.cartStore.lines,
    );
    widget.cartStore.clear();

    // Mengganti layar keranjang, sehingga tombol kembali menuju daftar menu.
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OrderStatusScreen(order: order)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Keranjang')),
      body: ListenableBuilder(
        listenable: widget.cartStore,
        builder: (context, _) {
          final lines = widget.cartStore.lines;

          if (lines.isEmpty) {
            return const Center(child: Text('Keranjang masih kosong'));
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (var i = 0; i < lines.length; i++)
                    _CartLineTile(
                      line: lines[i],
                      onQuantityChanged: (q) =>
                          widget.cartStore.setQuantity(i, q),
                      onRemove: () => widget.cartStore.removeAt(i),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total',
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        formatRupiah(widget.cartStore.total),
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Nama pemesan',
                      border: const OutlineInputBorder(),
                      errorText: _nameError,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _pickTime,
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _pickupTime == null
                          ? 'Pilih jam ambil'
                          : 'Jam ambil: ${_pickupTime!.format(context)}',
                    ),
                  ),
                  if (_timeError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Text(
                        _timeError!,
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _submit,
                    child: const Text('Kirim pesanan'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  final CartLine line;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const _CartLineTile({
    required this.line,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    line.menu.name,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Text(formatRupiah(line.subtotal)),
              ],
            ),
            if (line.variant != null) Text(line.variant!.name),
            if (line.note.isNotEmpty) Text('Catatan: ${line.note}'),
            Row(
              children: [
                IconButton(
                  onPressed: () => onQuantityChanged(line.quantity - 1),
                  icon: const Icon(Icons.remove_circle_outline),
                  tooltip: 'Kurangi',
                ),
                Text('${line.quantity}', style: theme.textTheme.titleMedium),
                IconButton(
                  onPressed: () => onQuantityChanged(line.quantity + 1),
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'Tambah',
                ),
                const Spacer(),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Hapus',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
