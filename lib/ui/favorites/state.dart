import 'package:e_commerce_store_karkhano/core/models/admin_model_data.dart';

class FavoritesState {}

class FavoriteInitial extends FavoritesState {}

class FavoriteLoading extends FavoritesState {}

class FavoriteLoaded extends FavoritesState {
  FavoriteLoaded({required List<AdminModel> model});
}

class FavoriteError extends FavoritesState {
  FavoriteError({String errorMessage = ''});
}
