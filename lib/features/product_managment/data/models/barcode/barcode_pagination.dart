class BarcodePaginationModel {
  final int? count;
  final bool? hasNext;
  final int? page;
  final int? perPage;

  BarcodePaginationModel({this.count, this.hasNext, this.page, this.perPage});

  factory BarcodePaginationModel.fromJson(Map<String, dynamic> json) =>
      BarcodePaginationModel(
        count: json['count'] as int?,
        hasNext: json['has_next'] as bool?,
        page: json['page'] as int?,
        perPage: json['per_page'] as int?,
      );

  Map<String, dynamic> toJson() => {
    'count': count,
    'has_next': hasNext,
    'page': page,
    'per_page': perPage,
  };
}
