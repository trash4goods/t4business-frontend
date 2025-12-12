import 'settings_item.dart';

class SettingsCategoryModel {
  final String id;
  final String title;
  final List<SettingsItemModel> items;

  const SettingsCategoryModel({
    required this.id,
    required this.title,
    required this.items,
  });
}