import 'package:mobx/mobx.dart';

abstract class BaseStore {
  @observable
  String? errorMessage;

  @observable
  bool isRefreshing = false;

  @action
  void setError(String? error) {
    errorMessage = error;
  }

  @action
  void setRefreshing(bool refreshing) {
    isRefreshing = refreshing;
  }

  @action
  void clearError() {
    errorMessage = null;
  }

  @computed
  bool get hasError => errorMessage != null;
}
