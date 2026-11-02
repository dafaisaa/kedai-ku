/// Pilihan varian untuk sebuah menu, mis. "Less sugar" atau "Large".
class Variant {
  final String id;
  final String name;
  final int extraPrice; // selisih harga dalam rupiah

  const Variant({required this.id, required this.name, this.extraPrice = 0});
}

/// Satu menu yang dijual.
class Menu {
  final String id;
  final String category;
  final String name;
  final int price; // harga dasar dalam rupiah
  final bool available; // false = stok habis
  final List<Variant> variants;

  const Menu({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    this.available = true,
    this.variants = const [],
  });
}
