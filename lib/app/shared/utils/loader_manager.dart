import 'package:get/get.dart';

mixin LoaderManager on GetxController {
  bool isLoading = false;
  void setIsLoading(bool newValue) {
    isLoading = newValue;
    update();
  }
}
