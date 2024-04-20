import 'package:ble_project/models/entities/log_entity.dart';
import 'package:ble_project/models/enums/load_status.dart';
import 'package:ble_project/utils/isar_storage_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(const HistoryState());

  Future<void> loadInitialData(int? userId) async {
    emit(state.copyWith(
      loadDataStatus: LoadStatus.initial,
    ));
    try {
      final isarStorage = IsarStorageUtil();

      final result = await isarStorage.getLogs(userId);

      emit(state.copyWith(
        logs: result,
        loadDataStatus: LoadStatus.success,
      ));
    } catch (e, s) {
      //Todo: should print exception here
      emit(state.copyWith(loadDataStatus: LoadStatus.failure));
    }
  }
}
