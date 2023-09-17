import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../core/services/database.dart';
import 'state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  String selectedCategory = "All";
  void fetchData(String selectedCategory) async {
    emit(HomeLoaded());
    try {
      final data = await _databaseService.getData(selectedCategory);
      emit(HomeGetLoaded(data: data));
    } catch (e) {
      emit(HomeDataError('Error fetching data: $e'));
    }
  }

  final DataBaseServices _databaseService = DataBaseServices();

  List<Map<String, dynamic>> categories = [
    {'text': 'All', 'icon': 'assets/icons_images/category.png'},
    {'text': 'Dresses', 'icon': 'assets/icons_images/dress.png'},
    {'text': 'Electronics', 'icon': 'assets/icons_images/processor.png'},
    {'text': 'Crockery', 'icon': 'assets/icons_images/crockery.png'},
  ];

  TextEditingController searchController = TextEditingController();

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }

  int selectedContainer = 0;
  String category = 'All';

  void updateContainerColor(int index, selected) async {
    selectedContainer = index;
    selectedCategory = selected;
    try {
      final data = await _databaseService.getData(selectedCategory);
      emit(HomeGetLoaded(data: data));
    } catch (e) {
      emit(HomeDataError('Error fetching data: $e'));
    }
  }

  List<Map<String, dynamic>> filteredData = []; // Add this property

  void filterData(String text) async {
    emit(HomeLoaded()); // Emit a loading state
    try {
      // Filter the data from the database service
      final data = await _databaseService.getData(selectedCategory);
      final filteredData = data.where((product) {
        final title = product.adminTitle?.toLowerCase() ?? '';
        final search = text.toLowerCase();
        return title.contains(search);
      }).toList();

      emit(HomeGetLoaded(data: filteredData)); // Emit the filtered data
    } catch (e) {
      emit(HomeDataError('Error filtering data: $e'));
    }
  }
}
