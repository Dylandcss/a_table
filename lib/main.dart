import 'package:a_table/src/pages/home_page.dart';
import 'package:a_table/src/pages/search_recipe_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  // Liste des pages correspondantes
  final List<Widget> _pages = const [
    TrendingRecipeList(),
    SearchRecipePage(),
    Center(child: Text("Favorites recipes")), // Placeholder pour la page des favoris
  ];

  // Change l'index courant
  void setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text([
            "Trending recipes",
            "Search recipes",
            "Favorites recipes"
          ][_currentIndex]),
        ),
        body: _pages[_currentIndex], // Utilise la liste des pages
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: setCurrentIndex,
          selectedItemColor: Colors.orange,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorites",
            ),
          ],
        ),
      ),
    );
  }
}
