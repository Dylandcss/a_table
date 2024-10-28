import 'dart:convert';
import 'package:flutter/material.dart';
import '../class/recipe.dart';
import 'package:http/http.dart' as http;

class RecipePage extends StatefulWidget {
  final int recipeId;

  const RecipePage({super.key, required this.recipeId});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late Future<Recipe?> recipe;

  Future<Recipe?> fetchRecipe() async {
    final response = await http.get(Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.recipeId}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['meals'] != null && (data['meals'] as List).isNotEmpty) {
        return Recipe.fromJson(data['meals'][0]);
      } else {
        return null; // Pas de recette trouvée
      }
    } else {
      throw Exception('Échec du chargement de la recette');
    }
  }

  @override
  void initState() {
    super.initState();
    recipe = fetchRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recette'),
      ),
      body: FutureBuilder<Recipe?>(
        future: recipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Aucune recette trouvée.'));
          } else {
            final recipeData = snapshot.data!;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(recipeData.thumb),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                    Text(recipeData.name, style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                    )),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                    Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(recipeData.instructions,style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                    ))),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
                    const Text('Ingrédients:', style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recipeData.ingredients.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ingredient = recipeData.ingredients[index];
                        return ListTile(
                          title: Text('${ingredient.name} (${ingredient.measure})'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
