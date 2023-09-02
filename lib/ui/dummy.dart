import 'package:e_commerce_store_karkhano/core/models/admin_model_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/services/database.dart';

class DropDownAndData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataCubit(),
      child: DropDownAndDataView(),
    );
  }
}

class DropDownAndDataView extends StatelessWidget {
  String selectedCategory = "All";
  // Initially, "All" category selected
  List<String> options = ['Electronics', 'Crockery', 'Dresses'];

  // @override
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DataCubit()..fetchData(selectedCategory),
      child: BlocConsumer<DataCubit, DataState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: <Widget>[
                  DropdownButton<String>(
                    value: selectedCategory,
                    onChanged: (newValue) {
                      selectedCategory = newValue!;
                      context.read<DataCubit>().fetchData(selectedCategory);
                    },
                    items: ['All', ...options]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<DataCubit>().fetchData(selectedCategory);
                    },
                    child: Text('Retrieve Data'),
                  ),
                  BlocBuilder<DataCubit, DataState>(
                    builder: (context, state) {
                      if (state is DataLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is DataLoaded) {
                        final retrievedData = state.data;
                        return Expanded(
                          child: ListView.builder(
                            itemCount: retrievedData.length,
                            itemBuilder: (context, index) {
                              final data = retrievedData[index];
                              return ListTile(
                                title: Text('${data.adminTitle}'),
                                // Add more widgets to display other data fields
                              );
                            },
                          ),
                        );
                      } else if (state is DataError) {
                        return Text('Error: ${state.error}');
                      } else {
                        return Text('No data available');
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Define the possible states for data retrieval
abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<AdminModel> data;

  DataLoaded(this.data);
}

class DataError extends DataState {
  final String error;

  DataError(this.error);
}

// Define events to trigger data retrieval
abstract class DataEvent {}

class FetchDataEvent extends DataEvent {
  final String selectedCategory;

  FetchDataEvent(this.selectedCategory);
}

class DataCubit extends Cubit<DataState> {
  final DataBaseServices _databaseService = DataBaseServices();

  DataCubit() : super(DataInitial());

  void fetchData(String selectedCategory) async {
    emit(DataLoading());
    try {
      final data = await _databaseService.getData(selectedCategory);
      emit(DataLoaded(data));
    } catch (e) {
      emit(DataError('Error fetching data: $e'));
    }
  }
}
