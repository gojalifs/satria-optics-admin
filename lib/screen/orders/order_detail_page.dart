import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/custom/common_function.dart';
import 'package:satria_optik_admin/model/address.dart';

import 'package:satria_optik_admin/model/order.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatelessWidget {
  static String route = '/order-detail';

  const OrderDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Consumer<OrderProvider>(
              builder: (context, value, child) {
                OrderModel order = value.order;
                Address address = value.order.address!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order.id}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _RowData(
                        title: 'Customer Name',
                        data: order.address?.receiverName ?? '-'),
                    _RowData(title: 'Payment ID', data: '${order.paymentId}'),
                    _RowData(
                      title: 'Grand Total',
                      data: formatToRupiah('${order.subTotal}'),
                    ),
                    _RowData(
                      title: 'Ordered At',
                      data: timeFormat(order.orderMadeTime),
                    ),
                    _RowData(
                      title: 'Paid At',
                      data: timeFormat(order.paymentMadeTime),
                    ),
                    _RowData(
                      title: 'Grand Total',
                      data: formatToRupiah('${order.total}'),
                    ),
                    _RowData(
                        title: 'Finished At',
                        data: timeFormat(order.orderFinishTime)),
                    const Divider(),
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      elevation: 3,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: order.cartProduct?.length ?? 0,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            var product = order.cartProduct![index];
                            var frame = order.cartProduct![index].product;
                            var lens = order.cartProduct![index].lens;
                            var minusData = order.cartProduct?[index].minusData;
                            return Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          frame.colors?[product.color]['url'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            child: Text(frame.name!),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            child: Text(product.color),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            child: Text(lens.name!),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                            ),
                                            child: Text(
                                              formatToRupiah(
                                                  '${product.totalPrice}'),
                                            ),
                                          ),
                                          if (minusData!.leftEyeMinus!.isEmpty)
                                            const Text('Normal Lens (Plain)'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                if (minusData.leftEyeMinus!.isNotEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Divider(),
                                  ),
                                if (minusData.leftEyeMinus!.isNotEmpty)
                                  Column(
                                    children: [
                                      const Text(
                                        'Lens Detail',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      _RowData(
                                        title: 'Left Eye Minus',
                                        data: minusData.leftEyeMinus!,
                                      ),
                                      _RowData(
                                        title: 'Right Eye Minus',
                                        data: minusData.rightEyeMinus!,
                                      ),
                                      _RowData(
                                        title: 'Left Eye Plus',
                                        data: minusData.leftEyePlus!,
                                      ),
                                      _RowData(
                                        title: 'Right Eye Minus',
                                        data: minusData.rightEyePlus!,
                                      ),
                                    ],
                                  ),
                                if (minusData.recipePath!.isNotEmpty)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            minusData.recipePath!,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons
                                                      .error_outline_rounded),
                                                  Text('Failed getting image'),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      const Expanded(
                                        flex: 3,
                                        child:
                                            Text('Recipe Image, Tap To Zoom'),
                                      ),
                                    ],
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const Divider(thickness: 3),
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          order.receiptNumber ?? '',
                          style: const TextStyle(fontSize: 18),
                        ),
                        IconButton(
                          onPressed: order.receiptNumber!.contains('Update')
                              ? null
                              : () async {
                                  await Clipboard.setData(
                                    ClipboardData(text: order.receiptNumber!),
                                  );
                                  if (context.mounted) {
                                    CherryToast.info(
                                      toastPosition: Position.bottom,
                                      animationDuration:
                                          const Duration(milliseconds: 500),
                                      title: const Text('Recipt Copied'),
                                    ).show(context);
                                  }
                                },
                          icon: const Icon(Icons.copy_rounded),
                        ),
                      ],
                    ),
                    Text('Shipper : ${order.shipper}'),
                    Text(
                      address.receiverName,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(address.phone),
                    Text('${address.street} ${address.village}'),
                    Text(address.detail),
                    Text('${address.subdistrict} ${address.city}'),
                    Text('${address.province} ${address.postalCode}'),
                    if (order.orderStatus == 'packing')
                      Column(
                        children: [
                          // TODO implement print, if possible
                          // SizedBox(
                          //   width: double.maxFinite,
                          //   child: ElevatedButton.icon(
                          //     onPressed: () {
                          //       var printerGroup = 'printer';
                          //       showDialog(
                          //         context: context,
                          //         builder: (context) {
                          //           return AlertDialog(
                          //             content: Column(
                          //               mainAxisSize: MainAxisSize.min,
                          //               children: [
                          //                 const Text('Finding for a printer'),
                          //                 const CircularProgressIndicator
                          //                     .adaptive(),
                          //                 RadioListTile.adaptive(
                          //                   value: 'HP',
                          //                   groupValue: printerGroup,
                          //                   onChanged: (value) {},
                          //                 ),
                          //                 RadioListTile.adaptive(
                          //                   value: 'EPSON',
                          //                   groupValue: printerGroup,
                          //                   onChanged: (value) {},
                          //                 ),
                          //               ],
                          //             ),
                          //           );
                          //         },
                          //       );
                          //     },
                          //     icon: const Icon(Icons.print_rounded),
                          //     label: const Text('Print Address'),
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                  ),
                                  onPressed: () {
                                    showCustomDialog(
                                        context, value.order, false);
                                  },
                                  child: const Text(
                                    'Cancel Order',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Consumer<OrderProvider>(
                                  builder: (context, value, child) =>
                                      ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .tertiaryContainer,
                                    ),
                                    onPressed: () {
                                      showCustomDialog(
                                          context, value.order, true);
                                    },
                                    child: const Text(
                                      'Input Receipt',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (order.orderStatus == 'Shipping')
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            var url = Uri.parse(
                                'https://cekresi.com/?noresi=${order.receiptNumber}');
                            if (!await launchUrl(url)) {
                              if (context.mounted) {
                                CherryToast.error(
                                  toastPosition: Position.bottom,
                                  title: const Text(
                                      "Couldn't track receipt number"),
                                ).show(context);
                              }
                            }
                          },
                          child: const Text('Track The Order'),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCustomDialog(
      BuildContext context, OrderModel order, bool isSend) {
    TextEditingController controller =
        TextEditingController(text: isSend ? order.receiptNumber : null);
    var key = GlobalKey<FormState>();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          Consumer<OrderProvider>(
            builder: (context, value, child) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Theme.of(context).colorScheme.tertiaryContainer,
              ),
              onPressed: () async {
                if (!key.currentState!.validate()) {
                  return;
                }
                try {
                  if (isSend) {
                    // await insert receipt
                    await value.insertReceipt(true, controller.text.trim());
                  } else {
                    // await cancel order
                    await value.insertReceipt(true, controller.text.trim());
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    CherryToast.success(
                      title: Text(isSend ? 'Receipt Added' : 'Order Cancelled'),
                    ).show(context);
                  }
                } catch (e) {
                  CherryToast.error(title: Text('$e')).show(context);
                }
              },
              child: const Text('Send'),
            ),
          ),
        ],
        content: Form(
          key: key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isSend ? 'Input Receipt' : 'Give the Reason',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller,
                minLines: 1,
                maxLines: isSend ? 1 : 3,
                textInputAction: isSend ? TextInputAction.go : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ),
                onTapOutside: (event) {
                  primaryFocus?.unfocus();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowData extends StatelessWidget {
  final String title;
  final String data;

  const _RowData({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
          ),
          Text(
            data,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
