import 'package:intl/intl.dart';

String formatToRupiah(String data) {
  NumberFormat formatToRupiah = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
  );
  var price = double.parse(data);
  return formatToRupiah.format(price);
}
