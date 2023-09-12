// import 'package:e_commerce_store_karkhano/core/models/admin_model_data.dart';
// import 'package:e_commerce_store_karkhano/ui/admin_panel/admin_get_data/state.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../core/services/database.dart';
//
// class AdminGetDataCubit extends Cubit<AdminGetDataState> {
//   AdminGetDataCubit() : super(AdminGetDataInitial());
//
// // Define a list variable to hold the data
//   List<AdminModel> dataList = [];
//
//   Future<void> fetchData() async {
//     try {
//       emit(AdminGetDataLoading());
//       print('fetchData: Loading state emitted');
//
//       // Fetch data from your database service
//       final data = await DataBaseServices().getAdminData();
//       print('fetchData: Data fetched');
//
//       // Populate the list with the retrieved data
//       dataList = data;
//
//       emit(AdminGetDataLoaded(dataList));
//       print('fetchData: Loaded state emitted');
//     } catch (e) {
//       emit(AdminGetDataError('Error fetching data: $e'));
//       print('fetchData: Error state emitted');
//     }
//   }
//
//   Future<void> deleteData(String documentId) async {
//     try {
//       emit(AdminGetDataLoading());
//       print('deleteData: Loading state emitted');
//
//       await DataBaseServices().deleteData(documentId);
//       print('deleteData: Data deleted');
//
//       final data = await DataBaseServices().getAdminData();
//       print('deleteData: Data fetched after deletion');
//
//       emit(AdminGetDataLoaded(data));
//       print('deleteData: Loaded state emitted');
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//       emit(AdminGetDataError('Error deleting data: $e'));
//       print('deleteData: Error state emitted');
//     }
//   }
//
//   Future<void> editAdminData(
//       String documentId, Map<String, dynamic> updatedData) async {
//     try {
//       emit(AdminGetDataLoading());
//       print('editAdminData: Loading state emitted');
//
//       await DataBaseServices().updateAdminData(documentId, updatedData);
//       print('editAdminData: Data updated in Firestore');
//
//       final data = await DataBaseServices().getAdminData();
//       print('editAdminData: Data fetched after edit');
//
//       // Populate the list with the retrieved data
//       dataList = data;
//
//       emit(AdminGetDataLoaded(dataList));
//       print('editAdminData: Loaded state emitted with updated data');
//     } catch (e) {
//       if (kDebugMode) {
//         print(e.toString());
//       }
//       emit(AdminGetDataError('Error editing data: $e'));
//       print('editAdminData: Error state emitted');
//     }
//   }
// }
