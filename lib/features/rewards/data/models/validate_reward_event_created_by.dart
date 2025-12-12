class ValidateRewardEventCreatedByModel {
  final int? id;
  final String? name;

  ValidateRewardEventCreatedByModel({
    this.id,
    this.name,
  });

  factory ValidateRewardEventCreatedByModel.fromJson(Map<String, dynamic> json) {
    return ValidateRewardEventCreatedByModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (name != null) 'name': name,
  };
}