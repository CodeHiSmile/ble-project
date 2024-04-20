import 'dart:async';
import 'dart:math';

import 'package:ble_project/models/enums/load_status.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'logs_state.dart';

class LogsCubit extends Cubit<LogsState> {
  LogsCubit() : super(const LogsState());

  Future<void> receivedData(List<int> data) async {
    List<int> listDataConvert = [];

    emit(state.copyWith(
      loadDataStatus: LoadStatus.initial,
    ));

    try {
      List<List<int>> listData = state.listData ?? [];

      for (int i = 0; i < data.length; i += 2) {
        late int soundNumber;
        final numberResult = combineTwo8BitNumbers(
          data[i],
          data[i + 1],
        );

        if (numberResult > 32768) {
          soundNumber = numberResult - 65536;
        } else {
          soundNumber = numberResult;
        }
        //
        // final temp = soundNumber;
        // if (temp < state.min) {
        //   state.copyWith(min: temp);
        // }
        //
        // if (temp > state.max) {
        //   print("max hihi: $temp");
        //   state.copyWith(max: temp);
        // }

        listDataConvert.add(soundNumber);
      }

      listData.addAll([listDataConvert]);

      emit(
        state.copyWith(
          loadDataStatus: LoadStatus.success,
          listData: listData,
        ),
      );
    } catch (e, s) {
      emit(state.copyWith(
        loadDataStatus: LoadStatus.failure,
      ));
    }
  }

  void resetData() {
    state.copyWith(
      loadDataStatus: LoadStatus.loading,
    );

    emit(
      state.copyWith(
        loadDataStatus: LoadStatus.success,
        listData: [],
      ),
    );
  }

  int combineTwo8BitNumbers(int highByte, int lowByte) {
    int result = highByte << 8;
    result |= lowByte;
    return result;
  }
}
