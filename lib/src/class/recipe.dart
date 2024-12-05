import 'ingredient.dart';

class Recipe {
  final int id;
  final String name;
  final String instructions;
  final String imageUrl;
  final List<Ingredient> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.instructions,
    required this.imageUrl,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final List<dynamic> ingredientList = json['ingredients'] as List<dynamic>;
    final List<Ingredient> ingredients =
        ingredientList.map((item) => Ingredient.fromJson(item)).toList();

    return Recipe(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] as String,
      instructions: json['instructions'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      ingredients: ingredients,
    );
  }
}
