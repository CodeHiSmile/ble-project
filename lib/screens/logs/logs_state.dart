part of 'logs_cubit.dart';

class LogsState extends Equatable {
  final LoadStatus loadDataStatus;
  final List<List<int>>? listData;
  final int max;
  final int min;
  final List<FlSpot>? sinPoints;

  const LogsState({
    this.loadDataStatus = LoadStatus.initial,
    this.listData,
    this.max = 500,
    this.min = 0,
    this.sinPoints,
  });

  @override
  List<Object?> get props => [
        loadDataStatus,
        listData,
        min,
        max,
    sinPoints,
      ];

  LogsState copyWith({
    LoadStatus? loadDataStatus,
    List<List<int>>? listData,
    int? max,
    final int? min,
    List<FlSpot>? sinPoints,
  }) {
    return LogsState(
      loadDataStatus: loadDataStatus ?? this.loadDataStatus,
      listData: listData ?? this.listData,
      max: max ?? this.max,
      min: min ?? this.min,
      sinPoints: sinPoints ?? this.sinPoints,
    );
  }
}
