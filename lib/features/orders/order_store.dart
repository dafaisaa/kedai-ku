import 'package:flutter/foundation.dart';

import '../cart/cart_line.dart';
import 'order.dart';

/// Pemegang daftar pesanan. Di G1 hanya di memori.
class OrderStore extends ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders => List.unmodifiable(_orders);
  Order? get latest => _orders.isEmpty ? null : _orders.last;

  /// Membuat pesanan baru berstatus "baru" dari baris keranjang.
  Order place({
    required String customerName,
    required DateTime pickupTime,
    required List<CartLine> lines,
  }) {
    final now = DateTime.now();
    final order = Order(
      id: 'o${now.microsecondsSinceEpoch}',
      customerName: customerName,
      pickupTime: pickupTime,
      lines: List.of(lines),
      createdAt: now,
    );
    _orders.add(order);
    notifyListeners();
    return order;
  }
}
