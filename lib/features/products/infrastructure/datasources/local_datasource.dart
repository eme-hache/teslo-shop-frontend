import 'package:dio/dio.dart';

import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';

class LocalDatasource extends ProductsDatasource {
  late final Dio dio;
  final String token;

  LocalDatasource({required this.token})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $token'}));

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = productId == null ? 'POST' : 'PATCH';
      final String url = productId == null ? '/post' : '/products/$productId';

      productLike.remove('id');

      final response = await dio.request(
        url,
        data: productLike,
        options: Options(method: method),
      );

      return ProductMapper.jsonToEntity(response.data);
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id');

      return ProductMapper.jsonToEntity(response.data);
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) throw ProductNotFound();

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 10}) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];

    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
