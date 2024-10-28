class Ingredient {
  final String name;
  final String measure; // Par exemple, "g", "ml", "cuillère"

  Ingredient({required this.name, required this.measure});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['strIngredient'] ?? '',
      measure: json['strMeasure'] ?? '',
    );
  }
}
