import 'dart:convert';
import 'package:dio/dio.dart';
import '../model/category.dart';
import '../model/product.dart';
import '../model/tag.dart';
import '../../../core/network/dio_client.dart';

class HomeRepository {
  final Dio _dio = DioClient.instance;

  // Normalize response: bisa berupa String (server tanpa Content-Type), Map, atau List
  Map<String, dynamic> _body(dynamic data) {
    final parsed = data is String ? jsonDecode(data) : data;
    if (parsed is Map<String, dynamic>) return parsed;
    // Beberapa endpoint return bare array → wrap supaya konsisten
    if (parsed is List) return {'data': parsed, 'count': parsed.length};
    throw Exception('Unexpected response type: ${parsed.runtimeType}');
  }

  // Return (produk, total count) untuk pagination
  Future<(List<Product>, int)> getProducts({
    String? q,
    String? categoryId,
    List<String> tagIds = const [],
    int limit = 5,
    int skip = 0,
  }) async {
    final params = <String, dynamic>{
      'limit': limit,
      'skip': skip,
      if (q != null && q.isNotEmpty) 'q': q,
      if (categoryId != null) 'category': categoryId,
      if (tagIds.isNotEmpty) 'tags[]': tagIds,
    };

    final res = await _dio.get('/api/products', queryParameters: params);
    final body = _body(res.data);
    final data = body['data'] as List<dynamic>;
    final count = body['count'] as int? ?? 0;
    final products = data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
    return (products, count);
  }

  Future<List<Category>> getCategories() async {
    final res = await _dio.get('/api/categories', queryParameters: {'limit': 100});
    final data = _body(res.data)['data'] as List<dynamic>;
    return data.map((e) => Category.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Tag>> getTags() async {
    final res = await _dio.get('/api/tags', queryParameters: {'limit': 100});
    final data = _body(res.data)['data'] as List<dynamic>;
    return data.map((e) => Tag.fromJson(e as Map<String, dynamic>)).toList();
  }
}
