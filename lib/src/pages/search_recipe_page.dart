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

  Future<List<Recipe>> fetchRecipes(String query) async {
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?i=$query'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['meals'] != null && (data['meals'] as List).isNotEmpty) {
        return (data['meals'] as List).map((item) => Recipe.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Échec du chargement des recettes');
    }
  }

  void _onSearchChanged() {
    final query = _controller.text;
    if(query.isNotEmpty){
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
        Expanded( // Use Expanded to take available space
          child: FutureBuilder<List<Recipe>>(
            future: recipes,
            builder: (context, response) {
              if (response.hasData && response.data != null) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: response.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(child:ListTile(
                      title: Text(response.data![index].name, style: const TextStyle(
                          fontFamily: 'Poppins'
                      ),),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(response.data![index].thumb),
                      ) ,
                      trailing: IconButton(icon: const Icon(Icons.arrow_forward_ios_rounded), onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage(recipeId: response.data![index].id)));
                      },),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ));
                  },
                );
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