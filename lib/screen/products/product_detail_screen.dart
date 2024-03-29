import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik_admin/model/glass_frame.dart';
import 'package:satria_optik_admin/provider/product_provider.dart';
import 'package:satria_optik_admin/screen/products/add_frame_stock_screen.dart';

enum GenderValue { man, woman }

class ProductDetailPage extends StatelessWidget {
  final bool isAdd;
  static String route = '/product-detail';

  const ProductDetailPage({
    Key? key,
    required this.isAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> productTiles = [];

    return Scaffold(
      appBar: AppBar(
        title: isAdd
            ? const Text('Add New Data')
            : Consumer<ProductProvider>(
                builder: (context, value, child) => Text('${value.frame.name}'),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<ProductProvider>(
        builder: (context, value, child) => value.frame.isFilled()
            ? isAdd
                ? Consumer<ProductProvider>(
                    builder: (context, value, child) => FloatingActionButton(
                      onPressed: value.frame.isFilled() ||
                              value.state != ConnectionState.active
                          ? () {
                              print(value.frame.isFilled());
                              Provider.of<ProductProvider>(context,
                                      listen: false)
                                  .addProduct();
                              Navigator.of(context).pop();
                            }
                          : null,
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: value.state != ConnectionState.active
                          ? const Text('Save')
                          : const CircularProgressIndicator(),
                    ),
                  )
                : Consumer<ProductProvider>(
                    builder: (context, value, child) => FloatingActionButton(
                      onPressed: value.state == ConnectionState.active
                          ? null
                          : () async {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog.adaptive(
                                  title: const Text(
                                      "Are you sure to delete this product?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await value.deleteProduct();
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text("Yes, delete"),
                                    ),
                                  ],
                                ),
                              );
                            },
                      child: value.state == ConnectionState.active
                          ? const CircularProgressIndicator.adaptive()
                          : const Icon(Icons.delete_forever),
                    ),
                  )
            : FloatingActionButton(
                onPressed: null,
                backgroundColor: Colors.grey.shade400,
                child: const Text("Save"),
              ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(
          bottom: 84,
          left: 18,
          right: 18,
        ),
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
                    title: 'Frame Name',
                    detail: frame.name ?? '',
                    isAdd: isAdd,
                  ),
                  ProductDetailTile(
                      title: 'Frame Description',
                      detail: frame.description ?? '',
                      isAdd: isAdd),
                  ProductDetailTile(
                      title: 'Frame Gender',
                      detail: frame.gender ?? '',
                      isAdd: isAdd),
                  ProductDetailTile(
                      title: 'Frame Material',
                      detail: frame.material ?? '',
                      isAdd: isAdd),
                  ProductDetailTile(
                      title: 'Frame Price',
                      detail: (frame.price ?? 0).toString(),
                      isAdd: isAdd),
                  ProductDetailTile(
                      title: 'Frame Rating',
                      detail: frame.rating ?? '',
                      isAdd: isAdd),
                  ProductDetailTile(
                      title: 'Frame Shape',
                      detail: frame.shape ?? '',
                      isAdd: isAdd),
                  isAdd
                      ? const SizedBox()
                      : ProductDetailTile(
                          title: 'Frame Stock',
                          detail: 'Tap To See The Details',
                          isStock: true,
                          frameData: frame,
                          isAdd: isAdd),
                  ProductDetailTile(
                      title: 'Frame Type',
                      detail: frame.type ?? '',
                      isAdd: isAdd),
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
          isAdd
              ? const Text(
                  '''For other detail, please change in '''
                  '''change detail page''',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                )
              : const Text('Frame Images'),
          isAdd
              ? const SizedBox()
              : Consumer<ProductProvider>(
                  builder: (context, value, child) => ImageGrid(
                    frame: value.frame,
                    isColor: false,
                  ),
                ),
          isAdd ? const SizedBox() : const Text('Frame Images By Color'),
          isAdd
              ? const SizedBox()
              : Consumer<ProductProvider>(
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
      itemCount: isColor ? images?.length : (images?.length ?? 0) + 1,
      padding: const EdgeInsets.symmetric(vertical: 10),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == images?.length && !isColor) {
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
                images?[index] ?? '',
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
                    if (images?[index] != null) {
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
                    }
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
  final bool isAdd;
  final bool? isStock;
  final GlassFrame? frameData;

  const ProductDetailTile({
    Key? key,
    required this.title,
    required this.detail,
    required this.isAdd,
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
          builder: (context) {
            var gender = GenderValue.man.name;
            return AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                Consumer<ProductProvider>(
                  builder: (context, value, child) => ElevatedButton(
                    onPressed: value.state == ConnectionState.active
                        ? null
                        : () async {
                            String mapKey = '';
                            value.frame.toMap().forEach((key, value) {
                              if (value.toString() == detail) {
                                mapKey = key;
                                return;
                              }
                            });
                            if (isAdd) {
                              print('$mapKey d');

                              switch (title) {
                                case 'Frame Name':
                                  value.frame = value.frame
                                      .copyWith(name: controller.text.trim());

                                  break;
                                case 'Frame Description':
                                  value.frame = value.frame.copyWith(
                                      description: controller.text.trim());
                                  break;
                                case 'Frame Material':
                                  value.frame = value.frame.copyWith(
                                      material: controller.text.trim());
                                  break;
                                case 'Frame Price':
                                  value.frame = value.frame.copyWith(
                                      price: int.parse(controller.text.trim()));
                                  break;
                                case 'Frame Rating':
                                  value.frame = value.frame
                                      .copyWith(rating: controller.text.trim());
                                  break;
                                case 'Frame Shape':
                                  value.frame = value.frame
                                      .copyWith(shape: controller.text.trim());
                                  break;
                                case 'Frame Type':
                                  value.frame = value.frame
                                      .copyWith(type: controller.text.trim());
                                  break;
                                default:
                              }

                              Navigator.of(context).pop();
                            } else {
                              bool updateStatus = false;
                              if (title == 'Frame Price') {
                                updateStatus =
                                    await Provider.of<ProductProvider>(context,
                                            listen: false)
                                        .updateFrame(
                                  {
                                    'key': mapKey,
                                    'value': int.parse(controller.text.trim()),
                                  },
                                );
                              } else {
                                updateStatus =
                                    await Provider.of<ProductProvider>(context,
                                            listen: false)
                                        .updateFrame(
                                  {
                                    'key': mapKey,
                                    'value': controller.text.trim(),
                                  },
                                );
                              }
                              if (context.mounted) {
                                if (updateStatus) {
                                  Navigator.of(context).pop();
                                  CherryToast.success(
                                    title: const Text('Success Update Data'),
                                  ).show(context);
                                } else {
                                  CherryToast.error(
                                    title:
                                        const Text('Error while updating data'),
                                  ).show(context);
                                }
                              }
                            }
                          },
                    child: value.state == ConnectionState.active
                        ? const CircularProgressIndicator()
                        : const Text('Save'),
                  ),
                ),
              ],
              content: StatefulBuilder(
                builder: (context, setState) => Consumer<ProductProvider>(
                  builder: (context, productProv, child) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      if (!isStock! && title != "Frame Gender")
                        TextFormField(
                          controller: controller,
                          minLines: 1,
                          maxLines: 5,
                          textInputAction: TextInputAction.done,
                          onTapOutside: (event) {
                            primaryFocus?.unfocus();
                          },
                          inputFormatters: title == 'Frame Price'
                              ? [FilteringTextInputFormatter.digitsOnly]
                              : null,
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
                      if (title == "Frame Gender")
                        RadioListTile(
                          value: GenderValue.man.name,
                          groupValue: gender,
                          onChanged: (value) {
                            gender = value.toString();
                            productProv.frame = productProv.frame.copyWith(
                              gender: "Laki-laki",
                            );
                            setState(() {});
                          },
                          title: const Text('Laki-Laki'),
                        ),
                      if (title == "Frame Gender")
                        RadioListTile(
                          value: GenderValue.woman.name,
                          groupValue: gender,
                          onChanged: (value) {
                            gender = value.toString();
                            productProv.frame = productProv.frame.copyWith(
                              gender: "Perempuan",
                            );
                            setState(() {});
                          },
                          title: const Text('Perempuan'),
                        )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
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
