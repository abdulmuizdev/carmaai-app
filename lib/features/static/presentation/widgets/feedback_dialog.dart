import 'package:carma/core/di/injection.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/core/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class FeedbackDialog extends StatelessWidget {
  FeedbackDialog({super.key});

  TextEditingController _controller = TextEditingController();

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
              'Feedback',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
              softWrap: true, // Ensures the text wraps
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.4),
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(5),
              child: TextField(
                controller: _controller,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Please give us some suggestions, we will improve and do better!',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: AppColors.secondary.withOpacity(0.4),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                style: TextStyle(
                  color: AppColors.secondary,
                  fontSize: 14,
                  overflow: TextOverflow.visible,
                  fontWeight: FontWeight.normal,
                ),
              ),
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
            onTap: () async {
              if (_controller.text.isNotEmpty) {
                print('sending feedback ${_controller.text}');
                await locator<Mixpanel>().track('Feedback', properties: {"Message" : _controller.text});
                print('sent feedback');
                Utils.playSound('sounds/submit.wav');
                Navigator.of(context).pop();
              }else {
                print('text is empty cute girl');
              }
            },
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(12),
              child: Center(
                child: Text(
                  'Submit',
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
                  'No, Thanks',
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
