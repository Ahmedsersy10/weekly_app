// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/models/item_details_model.dart';
import 'package:weekly_dash_board/views/widgets/item_details.dart';

class IncomDetailsList extends StatelessWidget {
  const IncomDetailsList({super.key});
  static const items = [
    ItemDetailsModel(
      title: 'Desin service',
      value: '40%',
      color: Color(0xff208bc7),
    ),
    ItemDetailsModel(
      title: 'Desine Product',
      value: '25%',
      color: Color(0xff4db7f2),
    ),
    ItemDetailsModel(
      title: 'Product roylti',
      value: '20%',
      color: Color(0xff064060),
    ),
    ItemDetailsModel(title: 'Other', value: '22%', color: Color(0xffe2decd)),
  ];
  @override
  Widget build(BuildContext context) {
    log(MediaQuery.of(context).size.width.toString());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((e) => ItemDetails(itemDetailsModel: e)).toList(),
    );
  }
}
