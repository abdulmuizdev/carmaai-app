import 'package:carma/common/presentation/bloc/google_sign_in_bloc.dart';
import 'package:carma/common/presentation/bloc/google_sign_in_event.dart';
import 'package:carma/core/theme/app_colors.dart';
import 'package:carma/features/google_sign_in/presentation/widgets/profile_cell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignedInScreen extends StatelessWidget {
  final String? name;
  final String email;
  final String id;
  final BuildContext blocContext;

  const SignedInScreen({
    super.key,
    required this.name,
    required this.email,
    required this.id,
    required this.blocContext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (name != null) ...[
                  ProfileCell(label: 'Name', value: name!),
                ],
                ProfileCell(label: 'Email', value: email),
                ProfileCell(label: 'Id', value: id, isLast: true),
              ],
            ),
          ),
          const Spacer(),
          const Spacer(),
          TextButton(
            onPressed: () {
              blocContext.read<GoogleSignInBloc>().add(const SignOut());
            },
            child: Text(
              'Sign Out',
              style: TextStyle(
                color: AppColors.secondary.withOpacity(0.5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Call a confirmation dialog
              blocContext.read<GoogleSignInBloc>().add(const DeleteAccount());
            },
            child: Text(
              'Delete account',
              style: TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
