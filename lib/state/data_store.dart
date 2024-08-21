import 'package:get_storage/get_storage.dart';

abstract mixin class DataStore {
  final box = GetStorage();

  void save(String key);

  void recover(String key);
}
