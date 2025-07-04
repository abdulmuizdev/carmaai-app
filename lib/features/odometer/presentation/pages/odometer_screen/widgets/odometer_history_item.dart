import 'package:carma/common/widgets/grey_circle.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class OdometerHistoryItem extends StatelessWidget {
  final String reading;
  final String notes;
  final String? imageAsset;
  final String date;
  final bool? isLast;
  const OdometerHistoryItem({super.key, required this.reading, this.imageAsset, required this.notes, required this.date, this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          // onPressed();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          height: 30,
                          // child: const GreyCircle(isSelected: false, imageAsset: Icons.speed_outlined),
                          child: GreyCircle(isSelected: true, imageAsset: imageAsset),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    reading,
                                    style: TextStyle(
                                      fontFamily: 'Digital7',
                                      color: AppColors.secondary,
                                      fontSize:25,
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(
                                      // fontFamily: 'Digital7',
                                      color: AppColors.secondary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              // const SizedBox(height: 5),
                              Text(
                                (notes.isEmpty) ? '--' : notes,
                                style: TextStyle(
                                  color: AppColors.secondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // if (!(widget.isLast))
            if (!(isLast ?? false))
              Container(
                width: MediaQuery.of(context).size.width,
                height: 0.5,
                color: AppColors.primary.withOpacity(0.2),
              )
          ],
        ),
      ),
    );
  }
}
