import '../features/menu/menu.dart';

/// Sumber data menu. Di G1 datanya hanya di memori.
/// Di G2 isi class ini diganti: ambil dari REST API dengan cache SQLite,
/// tanpa mengubah cara layar memanggilnya.
class MenuRepository {
  final List<Menu> _menus = const [
    Menu(
      id: 'm1',
      category: 'Kopi',
      name: 'Kopi Susu',
      price: 18000,
      variants: [
        Variant(id: 'v1', name: 'Less sugar'),
        Variant(id: 'v2', name: 'Large', extraPrice: 4000),
      ],
    ),
    Menu(id: 'm2', category: 'Kopi', name: 'Americano', price: 15000),
    Menu(
      id: 'm3',
      category: 'Non-kopi',
      name: 'Matcha Latte',
      price: 22000,
      available: false,
    ),
    Menu(id: 'm4', category: 'Makanan', name: 'Roti Bakar', price: 14000),
  ];

  List<Menu> getAll() => List.unmodifiable(_menus);

  List<String> categories() => _menus.map((m) => m.category).toSet().toList();

  List<Menu> byCategory(String category) =>
      _menus.where((m) => m.category == category).toList();
}
