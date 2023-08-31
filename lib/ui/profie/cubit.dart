import 'package:bloc/bloc.dart';

import 'state.dart';

class ProfieCubit extends Cubit<ProfieState> {
  ProfieCubit.ProfileCubit() : super(ProfieState().init());
}
