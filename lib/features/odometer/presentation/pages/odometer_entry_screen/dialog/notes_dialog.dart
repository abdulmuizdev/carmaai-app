import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NotesDialog extends StatefulWidget {
  final Function(String notes) onDonePressed;

  const NotesDialog({super.key, required this.onDonePressed});

  @override
  State<NotesDialog> createState() => _NotesDialogState();
}

class _NotesDialogState extends State<NotesDialog> {
  final TextEditingController _notesController = TextEditingController();

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
            padding: const EdgeInsets.all(22),
            child: Text(
              'Want to mention anything?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
              softWrap: true, // Ensures the text wraps
            ),
          ),
          SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 14,
                  decoration: BoxDecoration(
                    color: const Color(0xFfD3D2D7),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 18),
                      Text(
                        'Note:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.secondary,
                        ),
                      ),
                      SizedBox(width: 9),
                      Expanded(
                        child: TextField(
                          controller: _notesController,
                          decoration: InputDecoration(
                            hintText: 'E.g, Changed Oil',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(width: 9),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '(optional)',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: AppColors.secondary.withOpacity(0.5),
                    ),
                  ),
                )
              ],
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
              widget.onDonePressed(_notesController.text);
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
