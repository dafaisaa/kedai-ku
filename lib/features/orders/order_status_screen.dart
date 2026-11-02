import 'package:flutter/material.dart';

import '../../core/format.dart';
import 'order.dart';

/// Menampilkan satu pesanan beserta statusnya.
class OrderStatusScreen extends StatelessWidget {
  final Order order;

  const OrderStatusScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pickup = TimeOfDay.fromDateTime(order.pickupTime).format(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Status pesanan')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pesanan diterima',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Chip(label: Text(order.status.label)),
                ],
              ),
              const SizedBox(height: 8),
              Text('Atas nama ${order.customerName}'),
              Text('Diambil pukul $pickup'),
              const SizedBox(height: 24),
              Text('Isi pesanan', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              for (final line in order.lines)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          '${line.quantity}x ${line.menu.name}'
                          '${line.variant != null ? ' (${line.variant!.name})' : ''}'
                          '${line.note.isNotEmpty ? '\n${line.note}' : ''}',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(formatRupiah(line.subtotal)),
                    ],
                  ),
                ),
              const Divider(height: 32),
              Row(
                children: [
                  Expanded(
                    child: Text('Total', style: theme.textTheme.titleMedium),
                  ),
                  Text(
                    formatRupiah(order.total),
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Kembali ke menu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
