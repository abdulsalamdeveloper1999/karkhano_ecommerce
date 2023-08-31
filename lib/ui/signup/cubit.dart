import 'package:bloc/bloc.dart';

import 'state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState().init());
}
