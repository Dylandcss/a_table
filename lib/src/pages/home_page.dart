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
    final response = await http
        .get(Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s='));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final recipesList = (data['meals'] as List).map((item) => Recipe.fromJson(item)).toList();
      return recipesList;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  @override
  void initState(){
    super.initState();
    recipes = fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded( // Use Expanded to take available space
          child: FutureBuilder<List<Recipe>>(
            future: recipes,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(child:ListTile(
                      title: Text(snapshot.data![index].name, style: const TextStyle(
                          fontFamily: 'Poppins'
                      ),),
                      subtitle: Text(snapshot.data![index].category, style: const TextStyle(
                          fontFamily: 'Poppins'),),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(snapshot.data![index].thumb),
                      ) ,
                      trailing: IconButton(icon: const Icon(Icons.arrow_forward_ios_rounded), onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RecipePage(recipeId: snapshot.data![index].id)));
                      },),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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