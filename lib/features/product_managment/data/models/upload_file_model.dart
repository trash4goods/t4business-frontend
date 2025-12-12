class UploadFileModel {
  final String? name;
  final String? base64;
  final String? url;
  final String? mimeType;
  final int? size;

  UploadFileModel({this.name, this.base64, this.url, this.mimeType, this.size});

  factory UploadFileModel.fromJson(Map<String, dynamic> json) {
    return UploadFileModel(
      name: json['name'] as String?,
      base64: json['base64'] as String?,
      url: json['url'] as String?,
      mimeType: json['mime_type'] as String?,
      size: json['size'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (base64 != null) 'base64': base64,
    if (url != null) 'url': url,
    if (mimeType != null) 'mime_type': mimeType,
    if (size != null) 'size': size,
  };

  UploadFileModel copyWith({
    String? name,
    String? base64,
    String? url,
    String? mimeType,
    int? size,
  }) => UploadFileModel(
    name: name ?? this.name,
    base64: base64 ?? this.base64,
    url: url ?? this.url,
    mimeType: mimeType ?? this.mimeType,
    size: size ?? this.size,
  );

  @override
  String toString() =>
      'UploadFileModel(name: $name, url: $url, mimeType: $mimeType, size: $size)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UploadFileModel &&
        other.name == name &&
        other.url == url &&
        other.mimeType == mimeType &&
        other.size == size;
  }

  @override
  int get hashCode => Object.hash(name, url, mimeType, size);
}
