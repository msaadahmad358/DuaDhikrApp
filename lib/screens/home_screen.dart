import 'package:dua_dhikr/utils/constants.dart';
import 'package:flutter/material.dart';
import '../models/dua_item.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/dua_card.dart';
import 'favorites_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<DuaItem> _allDuas = [];
  List<DuaItem> _filteredDuas = [];
  List<String> _categories = [];
  List<String> _favoriteIds = [];
  List<String> _recentSearches = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _selectedLanguage = 'en';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await StorageService.getLanguage();
    final favorites = await StorageService.getFavorites();
    final searches = await StorageService.getRecentSearches();
    final duas = await DataService.loadDuas();

    for (var dua in duas) {
      dua.isFavorite = favorites.contains(dua.id);
    }

    setState(() {
      _allDuas = duas;
      _filteredDuas = duas;
      _categories = ['All', ...duas.map((d) => d.category).toSet().toList()];
      _favoriteIds = favorites;
      _recentSearches = searches;
      _selectedLanguage = prefs;
      _isLoading = false;
    });
  }

  void _saveFavorites() => StorageService.saveFavorites(_favoriteIds);
  void _saveRecentSearches() =>
      StorageService.saveRecentSearches(_recentSearches);
  void _saveLanguage(String lang) => StorageService.saveLanguage(lang);

  void _toggleFavorite(DuaItem dua) {
    setState(() {
      if (_favoriteIds.contains(dua.id)) {
        _favoriteIds.remove(dua.id);
        dua.isFavorite = false;
      } else {
        _favoriteIds.add(dua.id);
        dua.isFavorite = true;
      }
    });
    _saveFavorites();
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredDuas = _allDuas.where((dua) {
        final matchesCategory =
            _selectedCategory == 'All' || dua.category == _selectedCategory;
        final matchesSearch =
            _searchQuery.isEmpty ||
            dua.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            dua.arabicText.contains(_searchQuery);
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _addToRecentSearches(String query) {
    if (query.trim().isEmpty) return;
    setState(() {
      _recentSearches.remove(query);
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 5) _recentSearches.removeLast();
    });
    _saveRecentSearches();
  }

  void _changeLanguage(String lang) {
    setState(() => _selectedLanguage = lang);
    _saveLanguage(lang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        selectedLanguage: _selectedLanguage,
        onLanguageChange: _changeLanguage,
        onHome: () => Navigator.pop(context),
        onFavorites: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavoritesScreen(
                allDuas: _allDuas,
                favoriteIds: _favoriteIds,
                onToggleFavorite: _toggleFavorite,
                selectedLanguage: _selectedLanguage,
              ),
            ),
          ).then((_) => _loadData());
        },
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Dua & Dhikr'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    allDuas: _allDuas,
                    favoriteIds: _favoriteIds,
                    onToggleFavorite: _toggleFavorite,
                    selectedLanguage: _selectedLanguage,
                  ),
                ),
              ).then((_) => _loadData());
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryPink))
          : Column(
              children: [
                _buildSearchBar(),
                _buildCategories(),
                _buildResultInfo(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _filteredDuas.length,
                    itemBuilder: (context, index) => DuaCard(
                      dua: _filteredDuas[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              dua: _filteredDuas[index],
                              onToggleFavorite: _toggleFavorite,
                              selectedLanguage: _selectedLanguage,
                            ),
                          ),
                        ).then((_) => _loadData());
                      },
                      onFavoriteToggle: () =>
                          _toggleFavorite(_filteredDuas[index]),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search duas...',
          prefixIcon: const Icon(Icons.search, color: primaryPink),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _applyFilters();
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _applyFilters();
          });
        },
        onSubmitted: _addToRecentSearches,
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => _filterByCategory(category),
              backgroundColor: Colors.grey[100],
              selectedColor: primaryPink.withAlpha(26),
              labelStyle: TextStyle(
                color: isSelected ? primaryPink : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_filteredDuas.length} duas found',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          if (_selectedCategory != 'All')
            GestureDetector(
              onTap: () => _filterByCategory('All'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryPink.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.close, size: 12, color: primaryPink),
                    SizedBox(width: 4),
                    Text(
                      'Clear filter',
                      style: TextStyle(fontSize: 11, color: primaryPink),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
