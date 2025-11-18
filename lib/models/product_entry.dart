// To parse this JSON data, do
//
//     final productEntry = productEntryFromJson(jsonString);

import 'dart:convert';

List<ProductEntry> productEntryFromJson(String str) => List<ProductEntry>.from(json.decode(str).map((x) => ProductEntry.fromJson(x)));

String productEntryToJson(List<ProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductEntry {
    String model;
    int pk;
    Fields fields;

    ProductEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    int price;
    String description;
    String thumbnail;
    String category;
    dynamic categoryOther;
    bool isFeatured;
    int stock;
    String rating;
    String brand;
    int user;

    Fields({
        required this.name,
        required this.price,
        required this.description,
        required this.thumbnail,
        required this.category,
        required this.categoryOther,
        required this.isFeatured,
        required this.stock,
        required this.rating,
        required this.brand,
        required this.user,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        price: json["price"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        category: json["category"],
        categoryOther: json["category_other"],
        isFeatured: json["is_featured"],
        stock: json["stock"],
        rating: json["rating"],
        brand: json["brand"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "price": price,
        "description": description,
        "thumbnail": thumbnail,
        "category": category,
        "category_other": categoryOther,
        "is_featured": isFeatured,
        "stock": stock,
        "rating": rating,
        "brand": brand,
        "user": user,
    };
}
