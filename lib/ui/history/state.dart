import '../../core/models/history_model.dart';

class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoaded extends HistoryState {
  HistoryLoaded({required List<HistoryModel> model});

  get model => null;
}

class HistoryError extends HistoryState {
  String errorMessage;
  HistoryError({required this.errorMessage});
}
