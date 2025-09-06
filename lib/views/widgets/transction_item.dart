// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/util/app_style.dart';
import 'package:weekly_dash_board/util/transction_mdel.dart';

class TransctionItem extends StatelessWidget {
  const TransctionItem({super.key, required this.transctionMdel});
  final TransctionMdel transctionMdel;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3.5,
      child: Card(
        elevation: 0,
        color: const Color(0xfffafafa),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            transctionMdel.title,
            style: AppStyles.styleSemiBold16(context),
          ),
          subtitle: Text(
            transctionMdel.date,
            style: AppStyles.styleRegular16(
              context,
            ).copyWith(color: const Color(0xffaaaaaa)),
          ),
          trailing: Text(
            transctionMdel.amount,
            style: AppStyles.styleSemiBold20(context).copyWith(
              color: transctionMdel.isWathDrawl
                  ? const Color(0xfff3735e)
                  : const Color(0xff7cd87a),
            ),
          ),
        ),
      ),
    );
  }
}
