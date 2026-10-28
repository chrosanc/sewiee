import 'package:flutter/cupertino.dart';
import 'package:sewiee/presentation/widget/loading/loading_dialog.dart';
import 'package:sewiee/presentation/widget/loading/loading_manager.dart';

class DialogManager {
  DialogManager(
      this._globalNavigationKey,
      this._loadingManager,
      );

  final GlobalKey<NavigatorState> _globalNavigationKey;
  final LoadingManager _loadingManager;

  BuildContext get _globalContext => _globalNavigationKey.currentState!.context;

  void init(){
    _loadingManager.loadingStream.listen(_onLoadingStateChanged);


  }

  void _onLoadingStateChanged(bool isLoading){
    if(isLoading) {
      LoadingDialog.show(_globalContext);
    } else {
      LoadingDialog.hide(_globalContext);
    }
  }
}