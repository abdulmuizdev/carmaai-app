import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectionDialog extends StatefulWidget {
  final String label;
  final List<String> list;
  final String initialSelectedString;
  final Function(String selectedString) onDonePressed;

  const SelectionDialog({
    super.key,
    required this.label,
    required this.list,
    required this.initialSelectedString,
    required this.onDonePressed,
  });

  @override
  State<SelectionDialog> createState() => _SelectionDialogState();
}

class _SelectionDialogState extends State<SelectionDialog> {
  late String _selectedString;
  @override
  void initState() {
    super.initState();
    _selectedString = widget.initialSelectedString;
    print('selected string is this $_selectedString');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
              softWrap: true, // Ensures the text wraps
            ),
          ),
          Container(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 50.0, // Height of each item
              scrollController: FixedExtentScrollController(initialItem: widget.list.indexOf(_selectedString)),
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedString = widget.list[index];

                });
              },
              children: widget.list.map((String option) {
                return Center(child: Text(option));
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            height: 0.5,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              widget.onDonePressed(_selectedString);
            },
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 0.5,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
