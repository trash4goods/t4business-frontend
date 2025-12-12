class FirebaseUserPendingTaskModel {
  String? text;
  PendingTaskType? type;
  PendingTaskStatus? status;

  FirebaseUserPendingTaskModel({this.text, this.type, this.status});

  factory FirebaseUserPendingTaskModel.fromJson(Map<String, dynamic> map) {
    return FirebaseUserPendingTaskModel(
      text: map['text'] as String?,
      type:
          map['type'] != null
              ? map['type'] == 'setPassword'
                  ? PendingTaskType.setPassword
                  : PendingTaskType.unknown
              : null,
      status:
          map['status'] != null
              ? PendingTaskStatus.values.byName(map['status'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'type': type?.name,
    'status': status?.name,
  };
}

enum PendingTaskType { setPassword, unknown }

enum PendingTaskStatus { pending, completed }
