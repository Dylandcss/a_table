class Ingredient {
  final int id;
  final String name;
  final double quantity;
  final String? unit;

  Ingredient({
    required this.id,
    required this.name,
    required this.quantity,
    this.unit,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? 'Unknown',
      quantity: json['quantity'] is double
          ? json['quantity']
          : double.parse(json['quantity'].toString()),
      unit: json['unit'] as String?, // Peut être null
    );
  }
}
