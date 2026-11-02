import 'package:flutter/foundation.dart';

import 'cart_line.dart';

/// Pemegang isi keranjang. Layar hanya membaca dari sini dan memanggil
/// fungsinya; ListenableBuilder membuat layar ikut diperbarui saat isinya berubah.
class CartStore extends ChangeNotifier {
  final List<CartLine> _lines = [];

  List<CartLine> get lines => List.unmodifiable(_lines);
  bool get isEmpty => _lines.isEmpty;
  int get itemCount => _lines.fold(0, (sum, l) => sum + l.quantity);
  int get total => _lines.fold(0, (sum, l) => sum + l.subtotal);

  /// Menambah baris. Jika menu, varian, dan catatannya sama dengan baris yang
  /// sudah ada, jumlahnya digabung.
  void add(CartLine line) {
    final i = _lines.indexWhere(
      (l) =>
          l.menu.id == line.menu.id &&
          l.variant?.id == line.variant?.id &&
          l.note == line.note,
    );
    if (i == -1) {
      _lines.add(line);
    } else {
      _lines[i] = _lines[i].copyWith(
        quantity: _lines[i].quantity + line.quantity,
      );
    }
    notifyListeners();
  }

  /// Mengubah jumlah baris ke-[index]. Jumlah 0 atau kurang menghapus baris.
  void setQuantity(int index, int quantity) {
    if (quantity <= 0) {
      removeAt(index);
      return;
    }
    _lines[index] = _lines[index].copyWith(quantity: quantity);
    notifyListeners();
  }

  void removeAt(int index) {
    _lines.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _lines.clear();
    notifyListeners();
  }
}
