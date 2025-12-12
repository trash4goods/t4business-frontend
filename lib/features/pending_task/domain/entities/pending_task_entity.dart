// PendingTaskEntity - Domain entity for pending tasks
class PendingTaskEntity {
  final String? text;
  final PendingTaskType? type;
  final PendingTaskStatus? status;

  const PendingTaskEntity({
    this.text,
    this.type,
    this.status,
  });

  PendingTaskEntity copyWith({
    String? text,
    PendingTaskType? type,
    PendingTaskStatus? status,
  }) {
    return PendingTaskEntity(
      text: text ?? this.text,
      type: type ?? this.type,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PendingTaskEntity &&
        other.text == text &&
        other.type == type &&
        other.status == status;
  }

  @override
  int get hashCode => Object.hash(text, type, status);
}

enum PendingTaskType { setPassword, unknown }

enum PendingTaskStatus { pending, completed }