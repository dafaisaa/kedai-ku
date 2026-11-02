import 'package:flutter_test/flutter_test.dart';

import 'package:kedai_ku/data/menu_repository.dart';
import 'package:kedai_ku/main.dart';

void main() {
  testWidgets('daftar menu tampil dan menu habis ditandai', (tester) async {
    await tester.pumpWidget(KedaiKuApp(repository: MenuRepository()));

    expect(find.text('Kedai-Ku'), findsOneWidget);
    expect(find.text('Kopi Susu'), findsOneWidget);
    expect(find.text('Matcha Latte'), findsOneWidget);
    expect(find.text('Habis'), findsOneWidget);
  });

  testWidgets('mengetuk menu membuka layar detail dengan varian', (
    tester,
  ) async {
    await tester.pumpWidget(KedaiKuApp(repository: MenuRepository()));

    await tester.tap(find.text('Kopi Susu'));
    await tester.pumpAndSettle();

    expect(find.text('Varian'), findsOneWidget);
    expect(find.text('Less sugar'), findsOneWidget);
  });
}
