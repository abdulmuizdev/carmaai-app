import 'package:flutter/material.dart';

class CarmaProgressBar extends StatelessWidget {
  final double progress; // Progress value between 0 and 1

  const CarmaProgressBar({required this.progress, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        return Stack(
          children: [
            // Background container
            Container(
              width: maxWidth,
              height: 7,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Optional: Background color
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            // Foreground progress bar
            Container(
              width: maxWidth * progress, // Scales with progress
              height: 7,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        );
      },
    );
  }
}
