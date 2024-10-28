import 'Ingredient.dart';

class Recipe {
  final int id;
  final String name;
  final String category;
  final String instructions;
  final String thumb;
  final String video;
  final List<Ingredient> ingredients; // Ajout de la liste des ingrédients

  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.instructions,
    required this.thumb,
    required this.video,
    required this.ingredients, // Ajout des ingrédients au constructeur
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];

    for (int i = 1; i <= 20; i++) { // On suppose un maximum de 20 ingrédients
      final ingredientName = json['strIngredient$i'];
      final ingredientMeasure = json['strMeasure$i'];
      if (ingredientName != null && ingredientName.isNotEmpty) {
        ingredients.add(Ingredient(name: ingredientName, measure: ingredientMeasure ?? ''));
      }
    }

    return Recipe(
      id: json['idMeal'] != null ? int.parse(json['idMeal']) : 0,
      name: json['strMeal'] ?? 'Unknown',
      category: json['strCategory'] ?? 'Unknown',
      instructions: json['strInstructions'] ?? 'No instructions provided.',
      thumb: json['strMealThumb'] ?? '',
      video: json['strYoutube'] ?? '',
      ingredients: ingredients,
    );
  }
}
