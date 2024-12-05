import 'dart:convert';

import 'package:a_table/src/pages/recipe_page.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;

import '../class/recipe.dart';

class SearchRecipePage extends StatefulWidget {
  const SearchRecipePage({super.key});

  @override
  State<SearchRecipePage> createState() => _SearchRecipePageState();
}

class _SearchRecipePageState extends State<SearchRecipePage> {
  final TextEditingController _controller = TextEditingController();
  late Future<List<Recipe>>? recipes = Future.value([]);

  // Fonction qui appel l'api et qui retourne une liste de recettes selon une donnée passée en argument
  Future<List<Recipe>> fetchRecipes(String query) async {
    try {
      final response = await http.get(Uri.parse(
          'https://s5-5032.nuage-peda.fr/projets_sio2/B2/Quesque/api_a_table/API_Recipes.php?ingredient=$query'));

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

  void _onSearchChanged() {
    final query = _controller.text;
    if (query.isNotEmpty) {
      setState(() {
        recipes = fetchRecipes(query);
      });
    } else {
      setState(() {
        recipes = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            onChanged: (value) => _onSearchChanged(),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Entrer un ingrédient',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<Recipe>>(
            future: recipes,
            builder: (context, response) {
              if (response.hasData && response.data != null) {
                return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: response.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      // TODO : Trouver comment gérer l'affichage quand on ne trouve pas de recette
                      if (response.data!.isEmpty) {
                        return Center(child: Text('Aucune recette trouvée'));
                      } else {
                        return Card(
                            child: ListTile(
                          title: Text(
                            response.data![index].name,
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child:
                                Image.network(response.data![index].imageUrl),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RecipePage(
                                          recipeId: response.data![index].id)));
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                        ));
                      }
                    });
              } else if (response.hasError) {
                return Center(child: Text('${response.error}'));
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
