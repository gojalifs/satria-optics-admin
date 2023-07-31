import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik_admin/provider/product_provider.dart';

class LensPage extends StatelessWidget {
  static const String page = 'lens';

  const LensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, product, child) {
        if (product.state == ConnectionState.active) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return EasyRefresh(
          onRefresh: () async {
            await product.getProducts(page);
          },
          child: GridView.builder(
            itemCount: product.lenses.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => const Card(),
          ),
        );
      },
    );
  }
}
