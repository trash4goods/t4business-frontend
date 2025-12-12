import 'product_file_entity.dart';

class ScannedProductEntity {
  final String? name;
  final String? brand;
  final String? instructions;
  final List<ProductFileEntity> middleImages;
  final String? lastImageUrl;
  final List<ProductFileEntity>? files;

  ScannedProductEntity({
    this.name,
    this.brand,
    this.instructions,
    this.middleImages = const [],
    this.lastImageUrl,
    this.files,
  });
}