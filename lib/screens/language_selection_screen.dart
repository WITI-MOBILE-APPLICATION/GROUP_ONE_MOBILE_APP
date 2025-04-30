// @dart=2.17

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_localizations.dart';
import 'language_provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<LanguageItem> _allLanguages;
  late List<LanguageItem> _filteredLanguages;

  @override
  void initState() {
    super.initState();
    _allLanguages = [
      LanguageItem(code: 'en', name: 'English', flagAsset: '🇺🇸'),
      LanguageItem(code: 'de', name: 'German', flagAsset: '🇩🇪'),
      LanguageItem(code: 'hi', name: 'Hindi', flagAsset: '🇮🇳'),
      LanguageItem(code: 'id', name: 'Indonesia', flagAsset: '🇮🇩'),
      LanguageItem(code: 'it', name: 'Italy', flagAsset: '🇮🇹'),
      LanguageItem(code: 'ja', name: 'Japan', flagAsset: '🇯🇵'),
      LanguageItem(code: 'ko', name: 'Korean', flagAsset: '🇰🇷'),
    ];
    _filteredLanguages = List.from(_allLanguages);

    _searchController.addListener(() {
      _filterLanguages();
    });
  }

  void _filterLanguages() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _filteredLanguages = List.from(_allLanguages);
      });
    } else {
      setState(() {
        _filteredLanguages = _allLanguages
            .where((lang) => lang.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLocale = languageProvider.locale;
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0C1E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          appLocalizations?.translate('select_language') ?? 'Select Language',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredLanguages.length,
                itemBuilder: (context, index) {
                  final language = _filteredLanguages[index];
                  final isSelected =
                      language.code == currentLocale.languageCode;

                  return _buildLanguageItem(
                    language: language,
                    isSelected: isSelected,
                    onTap: () {
                      languageProvider.setLocale(Locale(language.code));
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final appLocalizations = AppLocalizations.of(context);

    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          hintText: appLocalizations?.translate('search_language') ??
              'Search Language',
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildLanguageItem({
    required LanguageItem language,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Text(
          language.flagAsset,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(
          language.name,
          style: TextStyle(
            color: isSelected ? Colors.red : Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing:
            isSelected ? const Icon(Icons.check, color: Colors.red) : null,
        onTap: onTap,
      ),
    );
  }
}

class LanguageItem {
  final String code;
  final String name;
  final String flagAsset;

  LanguageItem({
    required this.code,
    required this.name,
    required this.flagAsset,
  });
}
