import '../constants.dart';
import '../providers/notification_provider.dart';

import '../helpers/modal_helper.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../screens/view_ar_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailBottomTabbar extends StatelessWidget {
  const ProductDetailBottomTabbar(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context) {
    final productProvider =
        Provider.of<ProductProviderModel>(context, listen: false);

    final foundProduct = productProvider.getProductById(id);
    return SizedBox(
      height: 90,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(ViewARScreen.namedRoute, arguments: id);
            },
            style: OutlinedButton.styleFrom(minimumSize: const Size(130, 45)),
            child: const Text(
              'View in AR',
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () {
              final cartProvider =
                  Provider.of<CartProviderModel>(context, listen: false);

              cartProvider.addItemToCart(
                prodId: id,
                title: foundProduct.title,
                price: foundProduct.price,
                quantity: 1,
                imageUrl: foundProduct.images['main'],
              );

              ModalHelpers.createInfoSnackbar(context, 'Product Added to cart');
              if (cartProvider.wasCartEmpty && cartProvider.items.isNotEmpty) {
                // Provider.of<NotificationProviderModel>(
                //   context,
                //   listen: false,
                // ).addNotification(
                //   NotificationItemModel(
                //     text: cartNotifications['t1']!['text']!,
                //     id: DateTime.now().toString(),
                //     title: cartNotifications['t1']!['title']!,
                //     icon: Icons.shopping_cart_rounded,
                //   ),
                // );
              }
            },
            style: ElevatedButton.styleFrom(minimumSize: const Size(130, 45)),
            child: const Text('Add to cart'),
          ),
        ],
      ),
    );
  }
}
