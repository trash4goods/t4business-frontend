class ManageTeamModel {
  final int? userId;
  String? roleName;
  final String? name;
  String? remove;
  bool? isMyAccount;

  ManageTeamModel({this.userId, this.roleName, this.name, this.remove, this.isMyAccount});

  factory ManageTeamModel.fromJson(Map<String, dynamic> json) {
    return ManageTeamModel(
      userId: json['user_id'] as int?,
      roleName: json['role_name'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'role_name': roleName,
    if (name != null) 'name': name,
    if (remove != null) 'remove': remove,
  };

  String get displayEmail => '$name@company.com';
  bool get isAccountPendingApproval => roleName == 'pending';

  factory ManageTeamModel.generateSingleMockMember({
    int? userId,
    String? roleName,
    String? name,
  }) => ManageTeamModel(userId: 764, roleName: 'pending', name: 'name');

  static List<ManageTeamModel> generateMockData() {
    return [
      ManageTeamModel(userId: 1, roleName: 'admin', name: 'userId01'),
      ManageTeamModel(userId: 765, roleName: 'member', name: 'userId08'),
      ManageTeamModel(userId: 766, roleName: 'member', name: 'userId07'),
    ];
  }
}
