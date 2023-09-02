import '../../../core/models/admin_model_data.dart';

abstract class AdminGetDataState {}

class AdminGetDataInitial extends AdminGetDataState {}

class AdminGetDataLoading extends AdminGetDataState {}

class AdminGetDataLoaded extends AdminGetDataState {
  final List<AdminModel> data;

  AdminGetDataLoaded(this.data);
}

class AdminGetDataError extends AdminGetDataState {
  final String error;

  AdminGetDataError(this.error);
}
