import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:satria_optik_admin/provider/lens_provider.dart';

class LensPage extends StatelessWidget {
  static const String page = 'lens';

  const LensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LensProvider>(
      builder: (context, provider, child) {
        if (provider.state == ConnectionState.active) {
          return GridView.count(
            crossAxisCount: 2,
            children: List.generate(
              7,
              (index) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: const Card(),
              ),
            ),
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
              return Card(
                child: Image.network(
                  provider.lenses![index].imageUrl!,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
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
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: const Card(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image_rounded,
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
