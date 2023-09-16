import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_store_karkhano/core/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../../core/models/history_model.dart';
import 'state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial());

  List<HistoryModel> history = [];

  // Future<void> getFavorites() async {
  //   emit(HistoryInitial());
  //   try {
  //     history = await DataBaseServices().getHistory();
  //
  //     print(history.toList());
  //
  //     emit(HistoryLoaded(model: history));
  //   } catch (e) {
  //     print(e.toString());
  //     // emit(HistoryError(errorMessage: e.toString()));
  //   }
  // }
  Future<void> getDataFromFirestore() async {
    emit(HistoryInitial());
    try {
      var mdl = await DataBaseServices().getSpecificUserHistory();
      history.addAll(mdl);
      emit(HistoryLoaded(model: mdl));
      if (kDebugMode) {
        print(mdl.map((e) => e.title));
        print(history.map((e) => e.collectionUid));
        print(history.map((e) => e.userId));
        print(history.map((e) => e.quantity));
        print(history.map((e) => e.price));
        print(history.map((e) => e.images));
        print(history.map((e) => e.date));
        // print(history.map((e) => e.time));
      }
    } catch (e) {
      HistoryError(errorMessage: e.toString());
    }
  }

  String formatTime(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Invalid Time'; // Handle null timestamp if needed
    }

    try {
      DateTime dateTime = timestamp.toDate();
      String formattedTime =
          DateFormat('MMMM d, y ' 'at' ' h:mm:ss a ' 'UTCz').format(dateTime);
      return formattedTime;
    } catch (e) {
      return 'Invalid Time'; // Handle parsing errors
    }
  }

  String oneItemPrice(
      List<dynamic>? totalPrice, List<dynamic>? totalQuantity, index) {
    if (totalPrice == null ||
        totalPrice.isEmpty ||
        totalQuantity == null ||
        totalQuantity.isEmpty) {
      return 'Invalid Price'; // Handle empty or null lists if needed
    }

    double totalPriceValue =
        (totalPrice[index] as num).toDouble(); // Convert to double
    int totalQuantityValue = totalQuantity[index] as int;

    if (totalQuantityValue == 0) {
      return 'Invalid Quantity'; // Handle division by zero if needed
    }

    double singleItemPrice = totalPriceValue / totalQuantityValue;
    return singleItemPrice.toStringAsFixed(2); // Format to two decimal places
  }
}
