part of 'users_cubit.dart';

class UsersState extends Equatable {
  final LoadStatus loadDataStatus;
  final List<UserEntity>? listUser;

  const UsersState({
    this.loadDataStatus = LoadStatus.initial,
    this.listUser,
  });

  @override
  List<Object?> get props => [
        loadDataStatus,
        listUser,
      ];

  UsersState copyWith({
    LoadStatus? loadDataStatus,
    List<UserEntity>? listUser,
  }) {
    return UsersState(
      loadDataStatus: loadDataStatus ?? this.loadDataStatus,
      listUser: listUser ?? this.listUser,
    );
  }
}
