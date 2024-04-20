import 'package:ble_project/models/entities/user_entity.dart';
import 'package:ble_project/models/enums/load_status.dart';
import 'package:ble_project/utils/isar_storage_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(const UsersState());

  Future<void> loadInitialData() async {
    emit(state.copyWith(
      loadDataStatus: LoadStatus.initial,
    ));

    try {
      final isarStorage = IsarStorageUtil();
      final data = await isarStorage.getUsers();

      emit(
        state.copyWith(
          loadDataStatus: LoadStatus.success,
          listUser: data,
        ),
      );
    } catch (e, s) {
      emit(state.copyWith(
        loadDataStatus: LoadStatus.failure,
      ));
    }
  }
}
