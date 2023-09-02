import 'package:bloc/bloc.dart';
import 'package:e_commerce_store_karkhano/ui/admin_panel/admin_get_data/state.dart';

import '../../../core/services/database.dart';

class AdminGetDataCubit extends Cubit<AdminGetDataState> {
  AdminGetDataCubit() : super(AdminGetDataInitial());

  Future<void> fetchData() async {
    try {
      emit(AdminGetDataLoading());

      final data = await DataBaseServices().getAdminData();

      emit(AdminGetDataLoaded(data));
    } catch (e) {
      emit(AdminGetDataError('Error fetching data: $e'));
    }
  }
}
