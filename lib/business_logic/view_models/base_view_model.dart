import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_db/business_logic/utils/constants/enums.dart';

class BaseModel extends Cubit {
  BaseModel(initialState) : super(initialState);

  ViewState _state = ViewState.idle;

  @override
  ViewState get state => _state;
  bool get isBusy => _state == ViewState.busy;

  void setState(ViewState viewState) {
    _state = viewState;
    emit(state);
  }
}
