class RewardResultFileCreatedByModel {
  final int? id;
  final String? name;

  RewardResultFileCreatedByModel({this.id, this.name});

  factory RewardResultFileCreatedByModel.fromJson(Map<String, dynamic> json) =>
      RewardResultFileCreatedByModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
