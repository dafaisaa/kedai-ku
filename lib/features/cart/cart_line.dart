import '../menu/menu.dart';

/// Satu baris di keranjang: menu + varian + jumlah + catatan.
class CartLine {
  final Menu menu;
  final Variant? variant;
  final int quantity;
  final String note;

  const CartLine({
    required this.menu,
    this.variant,
    this.quantity = 1,
    this.note = '',
  });

  /// Harga satuan termasuk tambahan varian.
  int get unitPrice => menu.price + (variant?.extraPrice ?? 0);

  int get subtotal => unitPrice * quantity;

  CartLine copyWith({Variant? variant, int? quantity, String? note}) {
    return CartLine(
      menu: menu,
      variant: variant ?? this.variant,
      quantity: quantity ?? this.quantity,
      note: note ?? this.note,
    );
  }
}
