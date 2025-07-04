import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


class TypeSelectionTab extends StatefulWidget {
  final Function(int selectedIndex) onSelectionChange;
  const TypeSelectionTab({super.key, required this.onSelectionChange});

  @override
  State<TypeSelectionTab> createState() => _TypeSelectionTabState();
}

class _TypeSelectionTabState extends State<TypeSelectionTab> {
  bool isExpenseSelected = true; // Default selected tab
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTab(
          title: 'Expenses',
          isFirst: true,
          isSelected: isExpenseSelected,
          onTap: () {
            setState(() {
              isExpenseSelected = true;
              widget.onSelectionChange(0);
            });
          },
          fillColor: AppColors.secondary,
          borderColor: AppColors.secondary,
        ),
        SizedBox(width: 0), // Space between tabs
        _buildTab(
          title: 'Income',
          isFirst: false,
          isSelected: !isExpenseSelected,
          onTap: () {
            setState(() {
              isExpenseSelected = false;
              widget.onSelectionChange(1);
            });
          },
          fillColor: AppColors.secondary,
          borderColor: AppColors.secondary,
        ),
      ],
    );
  }
  Widget _buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    required Color fillColor,
    required Color borderColor,
    required bool isFirst,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2.3,
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 34),
        decoration: BoxDecoration(
          color: isSelected ? fillColor : Colors.transparent,
          border: Border.all(color: borderColor, width: 1),
          borderRadius: isFirst ? const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)) :
            const BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: isSelected ? AppColors.white : AppColors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
