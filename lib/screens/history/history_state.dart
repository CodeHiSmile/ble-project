part of 'history_cubit.dart';

class HistoryState extends Equatable {
  final LoadStatus loadDataStatus;
  final List<LogsEntity>? logs;

  const HistoryState({
    this.loadDataStatus = LoadStatus.initial,
    this.logs,
  });

  @override
  List<Object?> get props => [
        loadDataStatus,
        logs,
      ];

  HistoryState copyWith({
    LoadStatus? loadDataStatus,
    List<LogsEntity>? logs,
  }) {
    return HistoryState(
      loadDataStatus: loadDataStatus ?? this.loadDataStatus,
      logs: logs ?? this.logs,
    );
  }
}
