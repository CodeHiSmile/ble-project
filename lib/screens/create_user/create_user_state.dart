part of 'create_user_cubit.dart';

class CreateUserState extends Equatable {
  final LoadStatus loadDataStatus;

  const CreateUserState({
    this.loadDataStatus = LoadStatus.initial,
  });

  @override
  List<Object?> get props => [
        loadDataStatus,
      ];

  CreateUserState copyWith({
    LoadStatus? loadDataStatus,
  }) {
    return CreateUserState(
      loadDataStatus: loadDataStatus ?? this.loadDataStatus,
    );
  }
}
