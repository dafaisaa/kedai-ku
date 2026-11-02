import '../cart/cart_line.dart';

/// Alur status: baru -> diproses -> siap -> selesai. Cabang: dibatalkan.
enum OrderStatus {
  baru('Baru'),
  diproses('Diproses'),
  siap('Siap diambil'),
  selesai('Selesai'),
  dibatalkan('Dibatalkan');

  final String label;
  const OrderStatus(this.label);

  /// Status berikutnya; null jika sudah final.
  OrderStatus? get next {
    switch (this) {
      case OrderStatus.baru:
        return OrderStatus.diproses;
      case OrderStatus.diproses:
        return OrderStatus.siap;
      case OrderStatus.siap:
        return OrderStatus.selesai;
      case OrderStatus.selesai:
      case OrderStatus.dibatalkan:
        return null;
    }
  }
}

class Order {
  /// Dibuat di klien. Di G2 diganti UUID agar pengiriman ulang tidak membuat pesanan ganda.
  final String id;
  final String customerName;
  final DateTime pickupTime;
  final List<CartLine> lines;
  final OrderStatus status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.customerName,
    required this.pickupTime,
    required this.lines,
    this.status = OrderStatus.baru,
    required this.createdAt,
  });

  int get total => lines.fold(0, (sum, l) => sum + l.subtotal);

  Order copyWith({OrderStatus? status}) {
    return Order(
      id: id,
      customerName: customerName,
      pickupTime: pickupTime,
      lines: lines,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
