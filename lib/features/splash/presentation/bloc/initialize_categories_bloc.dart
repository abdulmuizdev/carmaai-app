import 'package:carma/features/splash/domain/use_cases/initialize_categories_use_case.dart';
import 'package:carma/features/splash/presentation/bloc/initialize_categories_event.dart';
import 'package:carma/features/splash/presentation/bloc/initialize_categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InitializeCategoriesBloc
    extends Bloc<InitializeCategoriesEvent, InitializeCategoriesState> {
  final InitializeCategoriesUseCase _initializeCategoriesUseCase;

  InitializeCategoriesBloc(this._initializeCategoriesUseCase)
      : super(const Initial()) {
    on<InitializeCategories>((event, emit) async {
      final result = await _initializeCategoriesUseCase.execute();
      result.fold((left) {
        emit(InitializeCategoriesError(left.message));
      }, (right) {
        emit(const InitializedCategories());
      });
    });
  }
}
