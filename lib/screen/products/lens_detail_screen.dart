import 'dart:io';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik_admin/provider/lens_provider.dart';

class LensDetailPage extends StatelessWidget {
  static String route = '/lens-detail';
  const LensDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<LensProvider>(
          builder: (context, value, child) => Text('${value.lens.name}'),
        ),
      ),
      body: ListView(
        children: [
          const Center(
            child: Text(
              'Lens Data',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Consumer<LensProvider>(
            builder: (context, provider, child) {
              var lens = provider.lens;
              var keys = lens.toMap().keys.toList();
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  DetailRow(
                    title: 'Lens Name',
                    detail: '${lens.name}',
                    mapKey: keys[1],
                  ),
                  const Divider(),
                  DetailRow(
                    title: 'Description',
                    detail: '${lens.description}',
                    mapKey: keys[2],
                  ),
                  const Divider(),
                  DetailRow(
                    title: 'price',
                    detail: '${lens.price}',
                    mapKey: keys[4],
                  ),
                  const Divider(),
                  DetailRow(
                    title: 'Image',
                    detail: '${lens.imageUrl}',
                    mapKey: keys[3],
                    image: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(lens.imageUrl!),
                    ),
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String title;
  final String detail;
  final Widget? image;
  final String mapKey;

  const DetailRow({
    Key? key,
    required this.title,
    required this.detail,
    this.image,
    required this.mapKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: detail);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back'),
                ),
                if (image != null)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => const BottomPicker(),
                      );
                    },
                    child: const Text('Change Picture'),
                  ),
                Consumer<LensProvider>(
                  builder: (context, value, child) => TextButton(
                    onPressed: () async {
                      var data = controller.text;
                      await Provider.of<LensProvider>(context, listen: false)
                          .updateLens(mapKey, data);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: value.state == ConnectionState.active
                        ? const SizedBox(
                            width: 50,
                            child: LinearProgressIndicator(),
                          )
                        : const Text('Save'),
                  ),
                ),
              ],
              title: Text('Change $title'),
              content: image ?? TextField(controller: controller),
            ),
          );
        },
        child: Row(
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
                    child: image != null ? image! : Text(detail),
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

class BottomPicker extends StatelessWidget {
  const BottomPicker({super.key});

  Future picker(BuildContext context, {required bool takeCamera}) async {
    String path = await Provider.of<LensProvider>(
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
                  await Provider.of<LensProvider>(context, listen: false)
                      .uploadImage();
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
              child: Consumer<LensProvider>(
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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
