import 'package:bloc/bloc.dart';
import 'package:e_commerce_store_karkhano/core/models/admin_model_data.dart';
import 'package:e_commerce_store_karkhano/core/services/database.dart';
import 'package:flutter/foundation.dart';

import 'state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoriteInitial());
  List<AdminModel> fav = [];

  Future<void> getFavorites() async {
    emit(FavoriteInitial());
    try {
      fav = await DataBaseServices().getFav();
      emit(FavoriteLoaded(model: fav));
    } catch (e) {
      emit(FavoriteError(errorMessage: e.toString()));
    }
  }

  Future<void> delFavorites(useruid, index) async {
    emit(FavoriteInitial());
    try {
      await DataBaseServices().deleteFav(useruid);
      fav.removeAt(index);
      if (kDebugMode) {
        print('deleted');
      }
      emit(FavoriteLoaded(model: fav));
    } catch (e) {
      emit(FavoriteError(errorMessage: e.toString()));
    }
  }
}
