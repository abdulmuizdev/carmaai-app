import 'package:carma/common/widgets/carma_app_bar.dart';
import 'package:carma/common/widgets/grey_circle.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/add_financial_screen/domain/entities/transaction_entity.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class TransactionDetailScreen extends StatefulWidget {
  final TransactionEntity entity;
  final VoidCallback onDeletePressed;

  const TransactionDetailScreen(
      {super.key, required this.entity, required this.onDeletePressed});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  void initState() {
    super.initState();

    locator<Mixpanel>().track('Screen Opened', properties: {
      'Screen Name' : 'Transaction Detail Screen',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                // height: 65,
                // height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.only(left: 18, right: 18, top: 18),
                    child: CarmaAppBar(label: 'Details'),
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Expanded(
                    //         child: GestureDetector(
                    //           onTap: () {
                    //             Utils.playSound('sounds/out.wav');
                    //             Navigator.of(context).pop();
                    //           },
                    //           child: Align(
                    //             alignment: Alignment.topLeft,
                    //             child: Text('Cancel'),
                    //             // Icon(Icons.arrow_back,
                    //             //     color: AppColors.white),
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Text(
                    //           'Details',
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             color: AppColors.white,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //       Expanded(
                    //         child: Text(
                    //           '',
                    //           textAlign: TextAlign.center,
                    //           style: TextStyle(
                    //             color: AppColors.white,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                  ),
                ),
              ),
              Expanded(
                child: SafeArea(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  const GreyCircle(isSelected: true),
                                  SizedBox(width: 18),
                                  Text(
                                    widget.entity.categoryName,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 36),
                              Expanded(
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Type: ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.secondary
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        SizedBox(height: 18),
                                        Text(
                                          'Amount: ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.secondary
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        SizedBox(height: 18),
                                        Text(
                                          'Date: ',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.normal,
                                            color: AppColors.secondary
                                                .withOpacity(0.5),
                                          ),
                                        ),
                                        if (widget.entity.notes.isNotEmpty) ...[
                                          SizedBox(height: 18),
                                          Text(
                                            'Notes: ',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: AppColors.secondary
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(width: 36),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (widget.entity.type == 0)
                                                ? 'Expense'
                                                : 'Income',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: AppColors.secondary
                                                  .withOpacity(1),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Text(
                                            ((widget.entity.type == 0)
                                                    ? '- '
                                                    : '+ ') +
                                                (Utils.formatNumber(
                                                        widget.entity.amount) ??
                                                    widget.entity.amount),
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: (widget.entity.type == 0)
                                                  ? AppColors.red
                                                  : AppColors.green,
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Text(
                                            widget.entity.date,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                              color: AppColors.secondary
                                                  .withOpacity(1),
                                            ),
                                          ),
                                          if (widget
                                              .entity.notes.isNotEmpty) ...[
                                            const SizedBox(height: 18),
                                            Text(
                                              widget.entity.notes,
                                              overflow: TextOverflow.visible,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal,
                                                color: AppColors.secondary
                                                    .withOpacity(1),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: TextButton(
                              onPressed: () {
                                widget.onDeletePressed();
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.red,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
