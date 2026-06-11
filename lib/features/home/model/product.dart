import 'category.dart';
import 'tag.dart';
import '../../../core/utils/image_url.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final int stock;
  final String? description;
  final Category? category;
  final List<Tag> tags;
  final double? avgRating;
  final int? reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.stock,
    this.description,
    this.category,
    this.tags = const [],
    this.avgRating,
    this.reviewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        imageUrl: normalizeImageUrl(json['image_url'] as String?),
        stock: (json['stock'] ?? 0) as int,
        description: json['description'] as String?,
        category: json['category'] is Map<String, dynamic>
            ? Category.fromJson(json['category'] as Map<String, dynamic>)
            : null,
        tags: (json['tags'] as List<dynamic>?)
                ?.whereType<Map<String, dynamic>>()
                .map(Tag.fromJson)
                .toList() ??
            [],
        avgRating: (json['avg_rating'] as num?)?.toDouble(),
        reviewCount: json['review_count'] as int?,
      );
}
