import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:satria_optik_admin/provider/lens_provider.dart';
import 'package:satria_optik_admin/screen/products/lens_detail_screen.dart';

class LensPage extends StatelessWidget {
  static const String page = 'lens';

  const LensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LensProvider>(
      builder: (context, provider, child) {
        if (provider.state == ConnectionState.active) {
          return GridView.builder(
            itemCount: 5,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) => const ShimmerEffect(height: 150),
          );
        }
        return EasyRefresh(
          onRefresh: () async {
            await provider.getLenses();
          },
          child: GridView.builder(
            itemCount: provider.lenses?.length ?? 0,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) {
              var lens = provider.lenses![index];
              return InkWell(
                onTap: () {
                  provider.lens = lens;
                  Navigator.of(context).pushNamed(LensDetailPage.route);
                },
                child: LenseesCard(index: index),
              );
            },
          ),
        );
      },
    );
  }
}

class ShimmerEffect extends StatelessWidget {
  final double height;

  const ShimmerEffect({
    Key? key,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SizedBox(
        width: double.maxFinite,
        height: height,
        child: const Card(),
      ),
    );
  }
}

class LenseesCard extends StatelessWidget {
  final int index;

  const LenseesCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<LensProvider>(
        builder: (context, provider, child) => Image.network(
          provider.lenses![index].imageUrl!,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) {
              return child;
            }
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(seconds: 2),
              curve: Curves.easeOut,
              child: child,
            );
          },
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            return IndexedStack(
              index: loadingProgress == null ? 0 : 1,
              alignment: Alignment.center,
              children: <Widget>[
                child,
                const ShimmerEffect(height: double.infinity),
              ],
            );
          },
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.broken_image_rounded,
          ),
        ),
      ),
    );
  }
}
