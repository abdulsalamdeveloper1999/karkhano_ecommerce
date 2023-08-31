import 'package:bloc/bloc.dart';

import 'state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesState().init());
}
