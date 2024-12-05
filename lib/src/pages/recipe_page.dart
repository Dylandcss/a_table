import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../class/recipe.dart';

class RecipePage extends StatefulWidget {
  final int recipeId;

  const RecipePage({super.key, required this.recipeId});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late Future<Recipe> recipe;

  Future<Recipe> fetchRecipe() async {
    try {
      final response = await http.get(Uri.parse(
          'https://s5-5032.nuage-peda.fr/projets_sio2/B2/Quesque/api_a_table/API_Recipes.php?id=${widget.recipeId}'));

      if (response.statusCode == 200) {
        final body = response.body;
        // print("API Response: $body");

        final Map<String, dynamic> data = jsonDecode(body);

        return Recipe.fromJson(data);
      } else {
        throw Exception('Failed to load recipe: ${response.statusCode}');
      }
    } catch (error) {
      // print("Error: $error");
      throw Exception('Error fetching recipe: $error');
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
      body: FutureBuilder<Recipe>(
        future: recipe,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Aucune recette trouvée.'));
          } else {
            final recipeData = snapshot.data!;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(recipeData.imageUrl),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                    Text(recipeData.name,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                        )),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0)),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(recipeData.instructions,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                            ))),
                    const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0)),
                    const Text('Ingrédients:',
                        style: TextStyle(
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
                          title: Text(
                              '${ingredient.name} (${ingredient.quantity} ${ingredient.unit ?? ''})'),
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
