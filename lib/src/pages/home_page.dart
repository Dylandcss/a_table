import 'dart:convert';

import 'package:a_table/src/pages/recipe_page.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

import '../class/recipe.dart';

class TrendingRecipeList extends StatefulWidget {
  const TrendingRecipeList({super.key});

  @override
  State<TrendingRecipeList> createState() => _TrendingRecipeListState();
}

class _TrendingRecipeListState extends State<TrendingRecipeList> {
  late Future<List<Recipe>> recipes;

  Future<List<Recipe>> fetchRecipes() async {
    try {
      final response = await http.get(Uri.parse(
          'https://s5-5032.nuage-peda.fr/projets_sio2/B2/Quesque/api_a_table/API_Recipes.php'));

      if (response.statusCode == 200) {
        final body = response.body;
        // print("API Response: $body"); // Log de la réponse brute

        final List<dynamic> data = jsonDecode(body);

        return data.map((item) => Recipe.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (error) {
      // print("Error: $error");
      throw Exception('Error fetching recipes: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    recipes = fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: FutureBuilder<List<Recipe>>(
            future: recipes,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        child: ListTile(
                      title: Text(
                        snapshot.data![index].name,
                        style: const TextStyle(fontFamily: 'Poppins'),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(snapshot.data![index].imageUrl),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios_rounded),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipePage(
                                      recipeId: snapshot.data![index].id)));
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                    ));
                  },
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}
