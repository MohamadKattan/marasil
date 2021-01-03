// this class useing in chatScreen if user send Image if loading for show circlprogress or idel for stop

import 'package:flutter/cupertino.dart';
import 'package:marasil/enum/view_state.dart';
class ImageUploadProvider with ChangeNotifier{
  ViewState _viewState = ViewState.IDLE;
  ViewState get getViewStata =>_viewState;

  void setToLoading (){
    _viewState =ViewState.LOADING;
    notifyListeners();
  }
  void setToIdle(){
    _viewState=ViewState.IDLE;
    notifyListeners();
  }

}