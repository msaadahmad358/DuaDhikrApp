import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomDrawer extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChange;
  final VoidCallback onHome;
  final VoidCallback onFavorites;

  const CustomDrawer({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChange,
    required this.onHome,
    required this.onFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: primaryPink,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildHeader(),
                    const Divider(color: Colors.white24),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(24, 16, 24, 8),
                      child: Text(
                        'MENU',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    _buildMenuItem(Icons.home, 'Home', onHome),
                    _buildMenuItem(Icons.favorite, 'Favorites', onFavorites),
                    _buildLanguageSection(),
                    _buildAboutSection(),
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        '© $appYear Hafiz Apps',
                        style: TextStyle(
                          color: Colors.white.withAlpha(128),
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              image: const DecorationImage(image: AssetImage(iconPath)),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            appName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version $appVersion',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 22, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  Widget _buildLanguageSection() {
    return ExpansionTile(
      leading: const Icon(Icons.language, size: 22, color: Colors.white),
      title: const Text('Translation', style: TextStyle(color: Colors.white)),
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              ListTile(
                title: const Text(
                  'English',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Radio<String>(
                  value: 'en',
                  groupValue: selectedLanguage,
                  onChanged: (value) => onLanguageChange('en'),
                  activeColor: Colors.white,
                ),
                onTap: () => onLanguageChange('en'),
              ),
              const Divider(color: Colors.white24),
              ListTile(
                title: const Text(
                  'Urdu',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Radio<String>(
                  value: 'ur',
                  groupValue: selectedLanguage,
                  onChanged: (value) => onLanguageChange('ur'),
                  activeColor: Colors.white,
                ),
                onTap: () => onLanguageChange('ur'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return ExpansionTile(
      leading: const Icon(Icons.info_outline, size: 22, color: Colors.white),
      title: const Text('About Us', style: TextStyle(color: Colors.white)),
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text(
                'Authentic Duas and Dhikr from Quran and Hadith. Carefully verified for accuracy.',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildContactIcon(Icons.email_outlined, contactEmail),
                  const SizedBox(width: 32),
                  _buildContactIcon(Icons.language, website),
                ],
              ),
              const SizedBox(height: 12),
              Text(contactEmail, style: const TextStyle(color: Colors.white60)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactIcon(IconData icon, String text) {
    return InkWell(
      onTap: () => debugPrint('Contact: $text'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(38),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22, color: Colors.white70),
      ),
    );
  }
}
