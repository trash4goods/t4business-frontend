import '../../../data/models/product.dart';

abstract class ProductsControllerInterface {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel?> getProductById(int id);
  Future<bool> createProduct(ProductModel product);
  Future<bool> updateProduct(ProductModel product);
  Future<bool> deleteProduct(int id);
  List<ProductModel> filterProductsByCategory(String category);
  List<String> getAllCategories();
  Future<String> uploadImage(String imagePath);
  Future<bool> validateBarcode(String barcode);
}
