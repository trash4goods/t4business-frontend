enum RuleFormMode {
  create,
  edit;

  String get title {
    switch (this) {
      case RuleFormMode.create:
        return 'Create Rule';
      case RuleFormMode.edit:
        return 'Edit Rule';
    }
  }

  String get saveButtonText {
    switch (this) {
      case RuleFormMode.create:
        return 'Save';
      case RuleFormMode.edit:
        return 'Update Rule';
    }
  }

  bool get isEdit => this == RuleFormMode.edit;
  bool get isCreate => this == RuleFormMode.create;
}