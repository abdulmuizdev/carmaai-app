import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SettingsSwitchItem extends StatefulWidget {
  final String label;
  final String imageAsset;
  final bool isChecked;
  final Function(bool isChecked) onChanged;

  const SettingsSwitchItem({
    super.key,
    required this.label,
    required this.imageAsset,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  State<SettingsSwitchItem> createState() => _SettingsSwitchItemState();
}

class _SettingsSwitchItemState extends State<SettingsSwitchItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Image.asset(widget.imageAsset),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.label,
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          Theme(
            data: ThemeData(
              useMaterial3: true,
            ).copyWith(
              colorScheme: Theme.of(context).colorScheme.copyWith(outline: AppColors.secondary.withOpacity(0.5)),
            ),
            child: Switch(
              activeColor: AppColors.primary,
              inactiveThumbColor: AppColors.secondary.withOpacity(0.5),
              inactiveTrackColor: AppColors.secondary.withOpacity(0.1),
              value: widget.isChecked,
              onChanged: (isChecked) {
                widget.onChanged(isChecked);
              },
            ),
          ),
        ],
      ),
    );
  }
}
