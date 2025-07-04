import 'package:carma/core/utils/Utils.dart';
import 'package:carma/features/odometer/domain/use_cases/analyze_odometer_with_ai_use_case.dart';
import 'package:carma/features/odometer/domain/use_cases/get_odometer_reading_use_case.dart';
import 'package:carma/features/odometer/domain/use_cases/update_odometer_reading_use_case.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_event.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OdometerBloc extends Bloc<OdometerEvent, OdometerState> {
  final GetOdometerReadingUseCase _getOdometerReadingUseCase;
  final UpdateOdometerReadingUseCase _updateOdometerReadingUseCase;
  final AnalyzeOdometerWithAiUseCase _analyzeOdometerWithAiUseCase;

  OdometerBloc(this._getOdometerReadingUseCase, this._updateOdometerReadingUseCase, this._analyzeOdometerWithAiUseCase)
      : super(const Initial()) {
    on<GetOdometerReading>((event, emit) async {
      final result = await _getOdometerReadingUseCase.execute();
      result.fold((left) {
        emit(OdometerReadingError(left.message));
      }, (right) {
        String latestReading = (right.isNotEmpty) ? right[0].reading : '000000';
        String latestNote = (right.isNotEmpty) ? right[0].notes : '--';
        emit(GotOdometerReading(
          pastReadings: (right.isNotEmpty) ? right.sublist(1) : right,
          latestReading: latestReading,
          notes: latestNote,
        ));
      });
    });

    on<UpdateOdometerReading>((event, emit) async {
      String formattedNewReading = (double.tryParse(event.reading)?.round() ?? 0).toString().padLeft(6, '0');
      final result =
          await _updateOdometerReadingUseCase.execute(formattedNewReading, Utils.getCurrentDate(), event.notes);
      await result.fold((left) {
        emit(OdometerReadingError(left.message));
      }, (right1) async {
        final result = await _getOdometerReadingUseCase.execute();
        result.fold((left) {
          emit(OdometerReadingError(left.message));
        }, (right2) {
          String latestReading = (right2.isNotEmpty) ? right2[0].reading : '000000';
          String latestNotes = (right2.isNotEmpty) ? right2[0].notes : '--';
          emit(UpdatedOdometerReading(
            pastReadings: (right2.isNotEmpty) ? right2.sublist(1) : right2,
            updatedReading: latestReading,
            notes: latestNotes,
          ));
        });
      });
    });

    on<UpdateAIOdometerReading>((event, emit) async {
      String formattedNewReading = (double.tryParse(event.reading)?.round() ?? 0).toString().padLeft(6, '0');
      final result =
          await _updateOdometerReadingUseCase.execute(formattedNewReading, Utils.getCurrentDate(), event.notes);
      await result.fold((left) {
        emit(OdometerReadingError(left.message));
      }, (right1) async {
        final result = await _getOdometerReadingUseCase.execute();
        result.fold((left) {
          emit(OdometerReadingError(left.message));
        }, (right2) {
          String latestReading = (right2.isNotEmpty) ? right2[0].reading : '000000';
          String latestNotes = (right2.isNotEmpty) ? right2[0].notes : '--';
          emit(UpdatedAIOdometerReading(
            pastReadings: (right2.isNotEmpty) ? right2.sublist(1) : right2,
            updatedReading: latestReading,
            notes: latestNotes,
          ));
        });
      });
    });

    on<AnalyzeOdometerWithAI>((event, emit) async {
      final result = await _analyzeOdometerWithAiUseCase.execute(event.file);

      result.fold((left) {
        emit(AnalyzeOdometerWithAIError(left.message));
      }, (right) {
        String formattedNewReading = (double.tryParse(right)?.round() ?? 0).toString().padLeft(6, '0');
        emit(AnalyzedOdometerWithAI(formattedNewReading));
      });
    });
  }
}
