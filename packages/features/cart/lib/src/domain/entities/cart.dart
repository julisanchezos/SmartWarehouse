import 'package:cart/src/domain/entities/cart_item.dart';
import 'package:catalog/catalog.dart';

class Cart {
  const Cart({required this.items});

  factory Cart.empty() => const Cart(items: []);

  final List<CartItem> items;

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  /// Sum de subtotales. Devuelve `null` si el carrito está vacío (sin moneda
  /// de referencia).
  Money? get total {
    if (items.isEmpty) return null;
    // El back puede tener productos en distintas monedas (legacy / seed mixto).
    // Para no crashear el carrito si se mezclan, sumamos los montos crudos y
    // mostramos en la moneda del primer producto. Es lossy pero la alternativa
    // es romper toda la pantalla.
    final currency = items.first.product.price.currency;
    var totalCents = 0;
    for (final i in items) {
      totalCents += i.subtotal.amount;
    }
    return Money(amount: totalCents, currency: currency);
  }

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  int quantityOf(String productId) {
    final match = items.where((i) => i.product.id == productId);
    if (match.isEmpty) return 0;
    return match.first.quantity;
  }
}
