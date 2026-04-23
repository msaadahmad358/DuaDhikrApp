import 'package:flutter/material.dart';
import '../models/dua_item.dart';
import '../widgets/dua_card.dart';
import 'detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<DuaItem> allDuas;
  final List<String> favoriteIds;
  final Function(DuaItem) onToggleFavorite;
  final String selectedLanguage;

  const FavoritesScreen({
    super.key,
    required this.allDuas,
    required this.favoriteIds,
    required this.onToggleFavorite,
    required this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteDuas = allDuas
        .where((dua) => favoriteIds.contains(dua.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Favorites'), centerTitle: true),
      body: favoriteDuas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the heart icon to add duas',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favoriteDuas.length,
              itemBuilder: (context, index) => DuaCard(
                dua: favoriteDuas[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(
                        dua: favoriteDuas[index],
                        onToggleFavorite: onToggleFavorite,
                        selectedLanguage: selectedLanguage,
                      ),
                    ),
                  );
                },
                onFavoriteToggle: () => onToggleFavorite(favoriteDuas[index]),
              ),
            ),
    );
  }
}
