// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:weekly_dash_board/models/all_expenses_Item_model.dart';
import 'package:weekly_dash_board/views/widgets/active_all_expenses_item.dart';
import 'package:weekly_dash_board/views/widgets/in_active_all_expenses_item.dart';

class AllExpensesItem extends StatefulWidget {
  const AllExpensesItem({
    super.key,
    required this.itemModel,
    required this.isSelected,
  });
  final AllExpensesItemModel itemModel;
  final bool isSelected;

  @override
  // ignore: library_private_types_in_public_api
  _AllExpensesItemState createState() => _AllExpensesItemState();
}

class _AllExpensesItemState extends State<AllExpensesItem> {
  bool _isVisible = false;

  @override
  void initState() {
    _isVisible = widget.isSelected;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AllExpensesItem oldWidget) {
    if (widget.isSelected != oldWidget.isSelected) {
      setState(() {
        _isVisible = widget.isSelected;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 600),
      firstChild: InActiveAllExpensesItem(itemModel: widget.itemModel),
      secondChild: ActiveAllExpensesItem(itemModel: widget.itemModel),
      crossFadeState: _isVisible
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
    );
  }
}
