import 'package:pucardpg/blocs/app-init-bloc/app_init.dart';
import 'package:uuid/uuid.dart';

import '../data/app_shared_preferences.dart';

getSelectedLanguage(Initialized state, int index) {
  if (AppSharedPreferences().getSelectedLocale == null) {
    AppSharedPreferences().setSelectedLocale(
        state.appConfig.mdmsRes!.commonMasters!.stateInfo![0].languages.last.value);
  }
  final selectedLanguage = AppSharedPreferences().getSelectedLocale;
  final isSelected =
      state.appConfig.mdmsRes!.commonMasters!.stateInfo![0].languages[index].value ==
          selectedLanguage;

  return isSelected;
}

class IdGen {
  static const IdGen _instance = IdGen._internal();

  static IdGen get instance => _instance;

  /// Shorthand for [instance]
  static IdGen get i => instance;

  final Uuid uuid;

  const IdGen._internal() : uuid = const Uuid();

  String get identifier => uuid.v1();
}
