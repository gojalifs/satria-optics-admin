import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatToRupiah(String data) {
  NumberFormat formatToRupiah = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
  );
  var price = double.parse(data);
  return formatToRupiah.format(price);
}

String timeFormat(Timestamp? time) {
  DateFormat timestampFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  if (time != null) {
    String formatted = timestampFormat.format(time.toDate());
    return formatted;
  }
  return '';
}

String hourFormat(Timestamp? time) {
  DateFormat dateFormat = DateFormat('HH:mm');
  if (time != null) {
    String formatted = dateFormat.format(time.toDate());
    return formatted;
  }
  return '';
}
