import '../../core/models/admin_model_data.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {}

class HomeGetLoaded extends HomeState {
  final List<AdminModel> data;

  HomeGetLoaded({required this.data});
}

class HomeDataError extends HomeState {
  final String error;

  HomeDataError(this.error);
}

// Define events to trigger data retrieval
abstract class DataEvent {}

class FetchDataEvent extends DataEvent {
  final String selectedCategory;

  FetchDataEvent(this.selectedCategory);
}

class HomeFiltered extends HomeState {
  final List<AdminModel> filteredData;

  HomeFiltered({required this.filteredData});
}
