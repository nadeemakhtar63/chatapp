//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Calling/voice_calling/Observer.dart';
import '../../Calling/voice_calling/optional_constants.dart';

getStatusTime(val, BuildContext context) {
  final observer = Provider.of<Observer>(context, listen: false);
  if (val is int) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(val);
    String at = observer.is24hrsTimeformat == true
            ? DateFormat('HH:mm').format(date)
            : DateFormat.jm().format(date),
        when = getWhen(date, context);
    return '$when, $at';
  }
  return '';
}

getWhen(date, BuildContext context) {
  DateTime now = DateTime.now();
  String when;
  if (date.day == now.day)
    when =  'today';
  else if (date.day == now.subtract(Duration(days: 1)).day)
    when = ( 'yesterday');
  else
    when = IsShowNativeTimDate == true
        ?  DateFormat.MMMM().format(date) +
            ' ' +
            DateFormat.d().format(date)
        : DateFormat.MMMd().format(date);
  return when;
}

getJoinTime(val, BuildContext context) {
  if (val is int) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(val);
    String when = IsShowNativeTimDate == true
        ?  DateFormat.MMMM().format(date) +
            ' ' +
            DateFormat.d().format(date) +
            ', ' +
            DateFormat.y().format(date)
        : DateFormat.yMMMd().format(date);
    return '$when';
  }
  return '';
}
