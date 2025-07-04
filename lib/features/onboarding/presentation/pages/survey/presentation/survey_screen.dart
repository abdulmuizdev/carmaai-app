import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/onboarding/presentation/pages/paint_points/pain_points_screen.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:onboarding/onboarding.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  int currentIndex = 0;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();

    locator<Mixpanel>().track('Screen Opened', properties: {
      'Screen Name' : 'Survey Screen',
    });
    locator<Mixpanel>().track('Survey Index', properties: {
      'Index': 0,
    });
  }


  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> questions = [
      {
        'question': 'What you want to manage?',
        'answers': ['Car', 'Bike', 'Truck / Bus', 'Other']
      },
      {
        'question': 'What is your goal?',
        'answers': [
          'Know my lifetime spending',
          'Track Expenses / Income',
          'Track Odometer',
          'All'
        ]
      },
      {
        'question': 'Do you know lifetime expense of your vehicle?',
        'answers': ['Yes', 'No']
      },
    ];
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  // Adjust the radius as needed
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 100, // Optional: set the width
                    height: 100, // Optional: set the height
                    fit: BoxFit.cover, // Optional: choose the fit for the image
                  ),
                )),
            Onboarding(
              swipeableBody: List.generate(questions.length, (index) {
                final questionData = questions[index];

                return Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        questionData['question'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                      SizedBox(height: 50),
                      ...questionData['answers'].map((answer) {
                        int answerIndex =
                            questionData['answers'].indexOf(answer);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 5),
                          child: GestureDetector(
                            onTap: () {
                              locator<Mixpanel>().track('Answer Clicked', properties: {
                                'Question' : questionData,
                                'Answer' : answer,
                              });
                              locator<Mixpanel>().track('Survey Index', properties: {
                                'Index': index,
                              });
                              setState(() {
                                selectedIndex = answerIndex;
                              });
                              Future.delayed(const Duration(seconds: 1), () {
                                if (currentIndex != questions.length - 1) {
                                  setState(() {
                                    currentIndex = index + 1;
                                    selectedIndex = -1;
                                  });
                                } else {
                                  // Survey is finished
                                  if (context.mounted) {
                                    _navigateToPainPointsScreen(context);
                                  }
                                }
                              });
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: (selectedIndex == answerIndex)
                                        ? AppColors.primary
                                        : AppColors.secondary
                                            .withValues(alpha: 0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Center(
                                child: Text(
                                  answer,
                                  style: TextStyle(
                                    color: AppColors.secondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }),
              startIndex: currentIndex,
              onPageChanges:
                  (netDragDistance, pagesLength, currentIndex, slideDirection) {
                // This is triggered whenever the user swipes.
                setState(() {
                  this.currentIndex = currentIndex;
                });
              },
              buildHeader: (context, netDragDistance, pagesLength, currentIndex,
                  setIndex, slideDirection) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${currentIndex + 1} of $pagesLength",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: AppColors.secondary,
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(Icons.skip_next),
                      //   onPressed: () {
                      //     if (currentIndex < pagesLength - 1) {
                      //       setIndex(currentIndex + 1);
                      //     }
                      //   },
                      // ),
                    ],
                  ),
                );
              },
              // buildFooter: (context, netDragDistance, pagesLength, currentIndex,
              //     setIndex, slideDirection) {
              //   return Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         IconButton(
              //           icon: Icon(
              //             Icons.arrow_back,
              //             color: AppColors.secondary,
              //           ),
              //           onPressed: () {
              //             if (currentIndex > 0) {
              //               setIndex(currentIndex - 1);
              //             }
              //           },
              //         ),
              //         IconButton(
              //           icon: Icon(
              //             Icons.arrow_forward,
              //             color: AppColors.secondary,
              //           ),
              //           onPressed: () {
              //             if (currentIndex < pagesLength - 1) {
              //               setIndex(currentIndex + 1);
              //             }
              //           },
              //         ),
              //       ],
              //     ),
              //   );
              // },
              animationInMilliseconds: 300, // Adjust animation speed
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToPainPointsScreen(context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PainPointsScreen()));
  }
}
