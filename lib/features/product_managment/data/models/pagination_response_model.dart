class PaginationMetadata {
  final int? count;
  final bool? hasNext;
  final int? page;
  final int? perPage;

  PaginationMetadata({this.count, this.hasNext, this.page, this.perPage});

  factory PaginationMetadata.fromJson(Map<String, dynamic> json) {
    return PaginationMetadata(
      count: json['count'] as int?,
      hasNext: json['has_next'] as bool?,
      page: json['page'] as int?,
      perPage: json['per_page'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (count != null) 'count': count,
    if (hasNext != null) 'has_next': hasNext,
    if (page != null) 'page': page,
    if (perPage != null) 'per_page': perPage,
  };

  PaginationMetadata copyWith({
    int? count,
    bool? hasNext,
    int? page,
    int? perPage,
  }) => PaginationMetadata(
    count: count ?? this.count,
    hasNext: hasNext ?? this.hasNext,
    page: page ?? this.page,
    perPage: perPage ?? this.perPage,
  );

  @override
  String toString() =>
      'PaginationMetadata(count: $count, hasNext: $hasNext, page: $page, perPage: $perPage})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginationMetadata &&
        other.count == count &&
        other.hasNext == hasNext &&
        other.page == page &&
        other.perPage == perPage;
  }

  @override
  int get hashCode => Object.hash(count, hasNext, page, perPage);
}

class PaginationResponseModel<T> {
  final PaginationMetadata pagination;
  final List<T> result;

  PaginationResponseModel({required this.pagination, required this.result});

  factory PaginationResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginationResponseModel<T>(
      pagination: PaginationMetadata.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
      result:
          (json['result'] as List<dynamic>)
              .map((item) => fromJsonT(item as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) => {
    'pagination': pagination.toJson(),
    'result': result.map((item) => toJsonT(item)).toList(),
  };

  PaginationResponseModel<T> copyWith({
    PaginationMetadata? pagination,
    List<T>? result,
  }) => PaginationResponseModel<T>(
    pagination: pagination ?? this.pagination,
    result: result ?? this.result,
  );

  @override
  String toString() =>
      'PaginationResponseModel(pagination: $pagination, result: $result)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginationResponseModel<T> &&
        other.pagination == pagination &&
        other.result == result;
  }

  @override
  int get hashCode => Object.hash(pagination, result);
}
