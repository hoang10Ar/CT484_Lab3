import 'package:flutter/material.dart';
import 'package:myshop/ui/cart/cart_item_card.dart';
import 'package:myshop/ui/cart/cart_manager.dart';
import 'package:myshop/ui/orders/orders_manager.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartManager>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Column(
        children: [
          buildCartSummary(cart, context),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: buildCartDetails(cart),
          ),
        ],
      ),
    );
  }

  Widget buildCartSummary(CartManager cart, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Total",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const Spacer(),
          Chip(
            label: Text(
              "\$${cart.totalAmount.toStringAsFixed(2)}",
              style: TextStyle(
                color: Theme.of(context).primaryTextTheme.headline6?.color,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          TextButton(
            onPressed: cart.totalAmount <= 0
                ? null
                : () {
                    context.read<OrdersManager>().addOrder(
                          cart.products,
                          cart.totalAmount,
                        );
                    cart.clear();
                  },
            style: TextButton.styleFrom(
              textStyle: TextStyle(color: Theme.of(context).primaryColor),
            ),
            child: const Text("ORDER NOW"),
          )
        ],
      ),
    );
  }

  Widget buildCartDetails(CartManager cart) {
    return ListView(
      children: cart.productEntries
          .map(
            (entry) => CartItemCard(
              productId: entry.key,
              cardItem: entry.value,
            ),
          )
          .toList(),
    );
  }
}
