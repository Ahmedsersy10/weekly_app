// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/transction_mdel.dart';
import 'package:weekly_dash_board/views/widgets/transction_item.dart';

class TransctionHistoryListView extends StatelessWidget {
  const TransctionHistoryListView({super.key});
  static const items = [
    TransctionMdel(
      title: 'Cash Withdrawal',
      date: '13 Ar, 2022',
      amount: r'$20,129 ',
      isWathDrawl: true,
    ),
    TransctionMdel(
      title: 'Landing Page Project',
      date: '13 Ar, 2022',
      amount: r'$20,129 ',
      isWathDrawl: false,
    ),
    TransctionMdel(
      title: 'Juni Mobile App Project',
      date: '13 Ar, 2022',
      amount: r'$20,129 ',
      isWathDrawl: false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((e) => TransctionItem(transctionMdel: e)).toList(),
    );
  }
}

class TransctionHistoryListViewUi extends StatelessWidget {
  const TransctionHistoryListViewUi({super.key});
  static const items = [
    TransctionMdel(
      title: 'Cash Withdrawal',
      date: '13 Ar, 2022',
      amount: r'$20,129 ',
      isWathDrawl: true,
    ),
    TransctionMdel(
      title: 'Landing Page Project',
      date: '13 Ar, 2022',
      amount: r'$20,129 ',
      isWathDrawl: false,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((e) => TransctionItem(transctionMdel: e)).toList(),
    );
  }
}
