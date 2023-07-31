import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik_admin/provider/product_provider.dart';

class AddFrameStockPage extends StatefulWidget {
  static String route = '/add-stock';
  final Map<String, dynamic> colorData;
  const AddFrameStockPage({
    Key? key,
    required this.colorData,
  }) : super(key: key);

  @override
  State<AddFrameStockPage> createState() => _AddFrameStockPageState();
}

class _AddFrameStockPageState extends State<AddFrameStockPage> {
  TextEditingController colorController = TextEditingController();
  TextEditingController stockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          children: [
            Consumer<ProductProvider>(
              builder: (context, value, child) {
                Map<String, dynamic> colorData = value.tempVariantData!;
                return DataTable(
                  showBottomBorder: true,
                  columns: const [
                    DataColumn(label: Text('Color')),
                    DataColumn(label: Text('Stock')),
                    DataColumn(label: Text('Image')),
                  ],
                  rows: colorData.entries.map(
                    (e) {
                      var color = e.key;
                      Map<String, dynamic> data = e.value;
                      String stock = data['qty'];
                      String url = data['url'];
                      return DataRow(
                        cells: [
                          DataCell(Text(color)),
                          DataCell(
                            TextFormField(initialValue: stock),
                          ),
                          DataCell(
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      showProductDialog(
                                        context,
                                        color,
                                        data,
                                      );
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      padding: const EdgeInsets.all(5),
                                      child: Consumer<ProductProvider>(
                                        builder: (context, value, child) {
                                          String? path =
                                              colorData[color]['tempPath'];
                                          if (path != null &&
                                              path.toString().isNotEmpty) {
                                            return Image.file(
                                              File(path),
                                            );
                                          }
                                          return Image.network(
                                            url,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(Icons
                                                    .image_not_supported_rounded),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        content: const Text(
                                            'This action will immediately delete data from database, are you sure?'),
                                        title: const Text('Are You Sure?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              colorData.remove(color);
                                              value.deleteImage(color);
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Yes, delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                      Icons.highlight_remove_rounded),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                );
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: colorController,
                    decoration: const InputDecoration(hintText: 'New Color'),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: stockController,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'New Stock'),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Consumer<ProductProvider>(
                    builder: (context, value, child) {
                      Map<String, dynamic> colorData = value.tempVariantData!;
                      return ElevatedButton.icon(
                        onPressed: (colorController.text.isEmpty ||
                                stockController.text.isEmpty)
                            ? null
                            : () {
                                colorData[colorController.text.trim()] = {
                                  'qty': stockController.text.trim(),
                                  'url': '',
                                };
                                colorController.clear();
                                stockController.clear();
                                setState(() {});
                              },
                        icon: const Icon(
                          Icons.add_circle_rounded,
                          size: 30,
                        ),
                        label: const Text('Add'),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Consumer<ProductProvider>(
              builder: (context, value, child) => ElevatedButton(
                onPressed: value.state == ConnectionState.active
                    ? null
                    : () async {
                        await Provider.of<ProductProvider>(
                          context,
                          listen: false,
                        ).uploadImage();
                        setState(() {});
                      },
                child: value.state == ConnectionState.active
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Save Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showProductDialog(
      BuildContext context, String color, Map<String, dynamic> colorData) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<ProductProvider>(
        builder: (context, value, child) => AlertDialog(
          actions: [
            TextButton(
              onPressed: () async {
                value.image = null;
                colorData.remove('tempPath');
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Back'),
            ),
            Consumer<ProductProvider>(
              builder: (context, product, child) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  try {
                                    Navigator.of(context).pop();
                                    String path = await product.pickImage(
                                        takeCamera: true);

                                    colorData[color]['tempPath'] = path;
                                  } catch (e) {
                                    CherryToast.info(title: Text('$e'))
                                        .show(context);
                                  }
                                },
                                icon: const Icon(
                                  Icons.photo_camera_rounded,
                                ),
                              ),
                              const Text('Camera'),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  try {
                                    Navigator.of(context).pop();
                                    String path = await product.pickImage();

                                    colorData['tempPath'] = path;
                                  } catch (e) {
                                    CherryToast.info(title: Text('$e'))
                                        .show(context);
                                  }
                                },
                                icon: const Icon(Icons.photo_rounded),
                              ),
                              const Text('Gallery')
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Change Picture'),
              ),
            ),
            Consumer<ProductProvider>(
              builder: (context, product, child) => ElevatedButton.icon(
                onPressed: product.image == null
                    ? null
                    : () {
                        try {
                          colorData['tempPath'] = product.image!.path;
                          Navigator.of(context).pop();
                          setState(() {});
                        } catch (e) {
                          CherryToast.warning(
                            title: Text('$e'),
                          ).show(context);
                        }
                      },
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save'),
              ),
            ),
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 250,
                height: 250,
                padding: const EdgeInsets.all(20),
                child: Builder(
                  builder: (context) {
                    if (colorData['tempPath'] != null &&
                        (colorData['tempPath']).toString().isNotEmpty) {
                      return Image.file(File(value.image!.path));
                    }
                    return Image.network(
                      colorData['url'],
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.image_not_supported_rounded),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    colorController.dispose();
    stockController.dispose();
    super.dispose();
  }
}
