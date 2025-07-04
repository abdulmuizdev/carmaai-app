import 'package:carma/features/profile/domain/use_cases/get_signed_in_user_info_use_case.dart';
import 'package:carma/features/profile/presentation/bloc/profile_event.dart';
import 'package:carma/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetSignedInUserInfoUseCase _getSignedInUserInfoUseCase;

  ProfileBloc(this._getSignedInUserInfoUseCase) : super(const Initial()) {
    on<GetSignedInUserInfo>((event, emit) async {
      emit(const GettingSignedInUserInfo());
      final result = await _getSignedInUserInfoUseCase.execute();

      result.fold((left){
        emit(SignedInUserInfoError(left.message));
      }, (right){
        emit(GotSignedInUserInfo(right));
      });
    });
  }

}