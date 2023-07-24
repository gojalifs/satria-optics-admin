import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:satria_optik_admin/model/address.dart';

import 'package:satria_optik_admin/model/order.dart';
import 'package:satria_optik_admin/provider/order_provider.dart';

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
                    _RowData(title: 'Grand Total', data: '${order.total}'),
                    _RowData(
                      title: 'Ordered At',
                      data: '${order.orderMadeTime?.toDate()}',
                    ),
                    _RowData(
                      title: 'Paid At',
                      data: '${order.paymentMadeTime?.toDate()}',
                    ),
                    _RowData(title: 'Grand Total', data: '${order.total}'),
                    _RowData(
                        title: 'Finished At',
                        data: '${order.orderFinishTime?.toDate()}'),
                    const Divider(),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: order.cartProduct?.length ?? 0,
                      itemBuilder: (context, index) {
                        var product = order.cartProduct![index];
                        var frame = order.cartProduct![index].product;
                        var lens = order.cartProduct![index].lens;
                        var minusData = order.cartProduct?[index].minusData;
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 150,
                                  height: 150,
                                  child: Image.network(
                                    frame.colors?[product.color],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      child: Text('${product.totalPrice}'),
                                    ),
                                    if (minusData!.leftEyeMinus!.isEmpty)
                                      const Text('Normal Lens (Plain)'),
                                  ],
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Image.network(
                                      minusData.recipePath!,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.error_outline_rounded),
                                            Text('Failed getting image'),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  const Text('Recipe Image, Tap To Zoom'),
                                ],
                              ),
                          ],
                        );
                      },
                    ),
                    const Divider(thickness: 3),
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
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
                    SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          var printerGroup = 'printer';
                          // TODO implement print, if possible
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('Finding for a printer'),
                                    const CircularProgressIndicator.adaptive(),
                                    RadioListTile.adaptive(
                                      value: 'HP',
                                      groupValue: printerGroup,
                                      onChanged: (value) {},
                                    ),
                                    RadioListTile.adaptive(
                                      value: 'EPSON',
                                      groupValue: printerGroup,
                                      onChanged: (value) {},
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.print_rounded),
                        label: const Text('Print Address'),
                      ),
                    ),
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
                              showCustomDialog(context, value.order, false);
                            },
                            child: const Text(
                              'Cancel Order',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Consumer<OrderProvider>(
                            builder: (context, value, child) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                              ),
                              onPressed: () {
                                showCustomDialog(context, value.order, true);
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
