import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik_admin/model/glass_frame.dart';
import 'package:satria_optik_admin/provider/product_provider.dart';
import 'package:satria_optik_admin/screen/products/add_frame_stock_screen.dart';

class ProductDetailPage extends StatelessWidget {
  static String route = '/product-detail';

  const ProductDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> productTiles = [];

    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProductProvider>(
          builder: (context, value, child) => Text(value.frame.name!),
        ),
      ),
      body: ListView(
        children: [
          const Center(
            child: Text(
              'Product Data',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, value, child) {
              var frame = value.frame;
              return ListView(
                primary: false,
                shrinkWrap: true,
                children: [
                  ProductDetailTile(
                      title: 'Frame Name', detail: '${frame.name}'),
                  ProductDetailTile(
                      title: 'Frame Description',
                      detail: '${frame.description}'),
                  ProductDetailTile(
                      title: 'Frame Gender', detail: '${frame.gender}'),
                  ProductDetailTile(
                      title: 'Frame Material', detail: '${frame.material}'),
                  ProductDetailTile(
                      title: 'Frame Price', detail: '${frame.price}'),
                  ProductDetailTile(
                      title: 'Frame Rating', detail: '${frame.rating}'),
                  ProductDetailTile(
                      title: 'Frame Shape', detail: '${frame.shape}'),
                  ProductDetailTile(
                    title: 'Frame Stock',
                    detail: 'Tap To See The Details',
                    isStock: true,
                    frameData: frame,
                  ),
                  ProductDetailTile(
                      title: 'Frame Type', detail: '${frame.type}'),
                ],
              );
            },
          ),
          ListView.separated(
            itemCount: productTiles.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) => productTiles[index],
          ),
          const Divider(),
          const Text('Frame Images'),
          Consumer<ProductProvider>(
            builder: (context, value, child) => ImageGrid(
              frame: value.frame,
              isColor: false,
            ),
          ),
          const Text('Frame Images By Color'),
          Consumer<ProductProvider>(
            builder: (context, value, child) => ImageGrid(
              frame: value.frame,
              isColor: true,
            ),
          ),
        ],
      ),
    );
  }
}

class ImageGrid extends StatelessWidget {
  final GlassFrame frame;
  final bool isColor;

  const ImageGrid({
    Key? key,
    required this.frame,
    required this.isColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String>? images = [];
    if (isColor) {
      images = frame.colors?.entries.map((e) {
        Map<String, dynamic> colorData = e.value;
        String url = colorData['url'];
        return url;
      }).toList();
    } else {
      images = frame.imageUrl;
    }

    return GridView.builder(
      itemCount: isColor ? images?.length : images!.length + 1,
      padding: const EdgeInsets.symmetric(vertical: 10),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == images!.length && !isColor) {
          return Container(
            width: double.maxFinite,
            margin: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            await picker(context, takeCamera: true);
                          },
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_camera_rounded),
                              Text('Camera'),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await picker(context, takeCamera: false);
                          },
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.photo_rounded),
                              Text('Gallery'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.add_circle_rounded,
                color: Colors.black,
                size: 50,
              ),
            ),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Image.network(
                images[index],
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image_rounded);
                },
              ),
            ),
            if (!isColor)
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Colors.white.withOpacity(0.7),
                    ),
                  ),
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          Consumer<ProductProvider>(
                            builder: (context, value, child) => TextButton(
                              onPressed: () async {
                                await value.deleteMainImage(images![index]);
                                frame.imageUrl?.remove(images[index]);
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                              child: value.state == ConnectionState.active
                                  ? const SizedBox(
                                      width: 50,
                                      child: LinearProgressIndicator(),
                                    )
                                  : const Text('Yes, delete'),
                            ),
                          ),
                        ],
                        title: const Text('Are you sure to delete?'),
                        content: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.network(images![index]),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_forever_rounded),
                ),
              ),
          ],
        );
      },
    );
  }

  Future picker(BuildContext context, {required bool takeCamera}) async {
    String path = await Provider.of<ProductProvider>(
      context,
      listen: false,
    ).pickImage(takeCamera: takeCamera);
    if (context.mounted) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await Provider.of<ProductProvider>(context, listen: false)
                      .uploadMainImage(path);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    CherryToast.info(
                      title: const Text('Image Uploaded'),
                    ).show(context);
                  }
                } catch (e) {
                  CherryToast.error(title: Text('$e')).show(context);
                }
              },
              child: Consumer<ProductProvider>(
                builder: (context, value, child) {
                  if (value.state == ConnectionState.active) {
                    return const SizedBox(
                        width: 50, child: LinearProgressIndicator());
                  }
                  return const Text('Upload');
                },
              ),
            ),
          ],
          content: SizedBox(
            width: 300,
            height: 300,
            child: Image.file(File(path), fit: BoxFit.cover),
          ),
        ),
      );
    }
  }
}

class ProductDetailTile extends StatelessWidget {
  final String title;
  final String detail;
  final bool? isStock;
  final GlassFrame? frameData;

  const ProductDetailTile({
    Key? key,
    required this.title,
    required this.detail,
    this.isStock = false,
    this.frameData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: detail);
    return InkWell(
      onTap: () {
        if (isStock!) {
          Provider.of<ProductProvider>(context, listen: false).tempvariantData =
              frameData!.colors!;
          Navigator.of(context).pushNamed(
            AddFrameStockPage.route,
            arguments: frameData?.colors,
          );
          return;
        }
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              Consumer<ProductProvider>(
                builder: (context, value, child) => ElevatedButton(
                  onPressed: () async {
                    String mapKey = '';
                    value.frame.toMap().forEach((key, value) {
                      if (value.toString() == detail) {
                        mapKey = key;
                        return;
                      }
                    });
                    var update = await Provider.of<ProductProvider>(context,
                            listen: false)
                        .updateFrame(
                      {
                        'key': mapKey,
                        'value': controller.text.trim(),
                      },
                    );
                    if (context.mounted) {
                      if (update) {
                        Navigator.of(context).pop();
                        CherryToast.success(
                          title: const Text('Success Update Data'),
                        ).show(context);
                      } else {
                        CherryToast.error(
                          title: const Text('Error while updating data'),
                        ).show(context);
                      }
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                if (!isStock!)
                  TextFormField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 5,
                    onTapOutside: (event) {
                      primaryFocus?.unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: title,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      detail,
                    ),
                  ),
                  const Expanded(
                    child: Icon(Icons.edit_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
