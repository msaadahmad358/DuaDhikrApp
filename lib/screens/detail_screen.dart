import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/dua_item.dart';
import '../utils/constants.dart';

class DetailScreen extends StatelessWidget {
  final DuaItem dua;
  final Function(DuaItem) onToggleFavorite;
  final String selectedLanguage;

  const DetailScreen({
    super.key,
    required this.dua,
    required this.onToggleFavorite,
    required this.selectedLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final meaningText = selectedLanguage == 'en'
        ? dua.englishMeaning
        : dua.urduMeaning;
    final languageLabel = selectedLanguage == 'en'
        ? 'English Translation'
        : 'Urdu Translation';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(dua.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              dua.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
            onPressed: () => onToggleFavorite(dua),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildArabicCard(),
            const SizedBox(height: 20),
            _buildTranslationCard(languageLabel, meaningText),
            const SizedBox(height: 16),
            _buildInfoRow(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildArabicCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: creamBg,
        borderRadius: BorderRadius.circular(largeRadius),
        border: Border.all(color: primaryPink.withAlpha(51)),
      ),
      child: Column(
        children: [
          Text(
            dua.arabicText,
            style: GoogleFonts.amiri(fontSize: 28, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            dua.transliteration,
            style: const TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTranslationCard(String label, String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(largeRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: primaryPink,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryPink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            text.isEmpty ? 'Translation not available' : text,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildInfoChip('Source', dua.source, Icons.book)),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoChip(
                'Authenticity',
                dua.authenticity,
                Icons.verified,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildInfoChip(
                'Reference',
                dua.reference,
                Icons.format_quote,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInfoChip('Occasion', dua.occasion, Icons.event),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label, String value, IconData icon) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: primaryPink),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
