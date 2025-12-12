import 'manage_team.dart';

class TeamModel {
  final List<ManageTeamModel>? team;

  TeamModel({this.team});

  factory TeamModel.fromJson(Map<String, dynamic> json) => TeamModel(
    team:
        json['team'] != null
            ? List<ManageTeamModel>.from(
              json['team'].map((x) => ManageTeamModel.fromJson(x)),
            )
            : null,
  );

  Map<String, dynamic> toJson() => {
    'team': team?.map((x) => x.toJson()).toList(),
  };
}
