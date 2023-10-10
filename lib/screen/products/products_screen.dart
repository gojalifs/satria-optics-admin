import 'package:cherry_toast/cherry_toast.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik_admin/provider/product_provider.dart';
import 'package:satria_optik_admin/screen/products/product_detail_screen.dart';

class ProductListPage extends StatelessWidget {
  static const String page = 'products';

  const ProductListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, product, child) {
        if (product.state == ConnectionState.active) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        return EasyRefresh(
          onRefresh: () async {
            try {
              product.isRefresh = true;
              await product.getProducts(page);
            } catch (e) {
              CherryToast.error(title: Text('$e')).show(context);
            }
          },
          child: GridView.builder(
            itemCount: product.frames.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              var frame = product.frames[index];
              return InkWell(
                onTap: () {
                  product.frame = frame;
                  Navigator.of(context)
                      .pushNamed(ProductDetailPage.route, arguments: false);
                },
                child: Card(
                  child: Stack(
                    children: [
                      if (frame.imageUrl != null && frame.imageUrl!.isNotEmpty)
                        SizedBox(
                          width: double.maxFinite,
                          height: double.maxFinite,
                          child: Image.network(
                            frame.imageUrl![0],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const ImageIcon(
                                AssetImage('assets/icons/glasses.png'),
                              );
                            },
                          ),
                        ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.5, 0.9],
                            colors: [
                              Colors.white.withOpacity(0),
                              Colors.grey.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        heightFactor: 8.5,
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          frame.name!,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
