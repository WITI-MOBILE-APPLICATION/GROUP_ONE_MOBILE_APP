import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

// Model for settings data
class SettingsData {
  final bool downloadInHighQuality;
  final bool downloadUsingWifiOnly;
  final String selectedLanguage;
  final bool notificationEnabled;

  SettingsData({
    required this.downloadInHighQuality,
    required this.downloadUsingWifiOnly,
    required this.selectedLanguage,
    required this.notificationEnabled,
  });

  factory SettingsData.fromJson(Map<String, dynamic> json) {
    return SettingsData(
      downloadInHighQuality: json['downloadInHighQuality'] ?? false,
      downloadUsingWifiOnly: json['downloadUsingWifiOnly'] ?? false,
      selectedLanguage: json['selectedLanguage'] ?? 'English',
      notificationEnabled: json['notificationEnabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'downloadInHighQuality': downloadInHighQuality,
      'downloadUsingWifiOnly': downloadUsingWifiOnly,
      'selectedLanguage': selectedLanguage,
      'notificationEnabled': notificationEnabled,
    };
  }
}

// Provider to manage settings state
class SettingsProvider with ChangeNotifier {
  bool _downloadInHighQuality = false;
  bool _downloadUsingWifiOnly = false;
  String _selectedLanguage = 'English';
  bool _notificationEnabled = true;

  bool get downloadInHighQuality => _downloadInHighQuality;
  bool get downloadUsingWifiOnly => _downloadUsingWifiOnly;
  String get selectedLanguage => _selectedLanguage;
  bool get notificationEnabled => _notificationEnabled;

  void setDownloadInHighQuality(bool value) {
    _downloadInHighQuality = value;
    notifyListeners();
    _saveSettings();
  }

  void setDownloadUsingWifiOnly(bool value) {
    _downloadUsingWifiOnly = value;
    notifyListeners();
    _saveSettings();
  }

  void setSelectedLanguage(String value) {
    _selectedLanguage = value;
    notifyListeners();
    _saveSettings();
  }

  void setNotificationEnabled(bool value) {
    _notificationEnabled = value;
    notifyListeners();
    _saveSettings();
  }

  // Fetch settings from backend
  Future<void> fetchSettings() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://your-backend-api/settings');
      if (response.statusCode == 200) {
        final settings = SettingsData.fromJson(response.data);
        _downloadInHighQuality = settings.downloadInHighQuality;
        _downloadUsingWifiOnly = settings.downloadUsingWifiOnly;
        _selectedLanguage = settings.selectedLanguage;
        _notificationEnabled = settings.notificationEnabled;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching settings: $e');
    }
  }

  // Save settings to backend
  Future<void> _saveSettings() async {
    try {
      final dio = Dio();
      final settings = SettingsData(
        downloadInHighQuality: _downloadInHighQuality,
        downloadUsingWifiOnly: _downloadUsingWifiOnly,
        selectedLanguage: _selectedLanguage,
        notificationEnabled: _notificationEnabled,
      );
      await dio.post('https://your-backend-api/settings', data: settings.toJson());
    } catch (e) {
      print('Error saving settings: $e');
    }
  }
}

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    // Fetch settings when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      settingsProvider.fetchSettings();
    });

    // List of languages with their corresponding flag emojis
    final Map<String, String> languageFlags = {
      'English': '🇺🇸',
      'Spanish': '🇪🇸',
      'French': '🇫🇷',
      'German': '🇩🇪',
      'Chinese': '🇨🇳',
      'Japanese': '🇯🇵',
      'Korean': '🇰🇷',
      'Italian': '🇮🇹',
      'Portuguese': '🇵🇹',
      'Russian': '🇷🇺',
      'Arabic': '🇸🇦',
      'Hindi': '🇮🇳',
      'Swahili': '🇰🇪',
      'Dutch': '🇳🇱',
    };

    // Common container style for wrapped boxes
    final boxDecoration = BoxDecoration(
      color: const Color(0xFF2a2a3e),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color.fromARGB(255, 10, 10, 10).withOpacity(0.2)),
    );

    // Fixed height for all boxes
    const double boxHeight = 72.0;

    // Label style to match all labels
    const labelStyle = TextStyle(
      color: Color(0xFFe0e0e0),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    );

    // Function to show the searchable language dialog
    void showLanguageDialog(BuildContext context) {
      final TextEditingController searchController = TextEditingController();
      List<String> filteredLanguages = languageFlags.keys.toList();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: const Color(0xFF2a2a3e),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: const Text(
                  '',
                  style: TextStyle(color: Color(0xFFe0e0e0)),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Search bar
                      TextField(
                        controller: searchController,
                        style: const TextStyle(color: Color(0xFFe0e0e0), fontSize: 10), // Further reduced font size
                        decoration: InputDecoration(
                          hintText: 'Search language...',
                          hintStyle: const TextStyle(color: Color(0xFF9e9e9e), fontSize: 10), // Further reduced hint font size
                          prefixIcon: const Icon(Icons.search, color: Color(0xFFe0e0e0), size: 16), // Further reduced icon size
                          filled: true,
                          fillColor: const Color(0xFF1a1a2e),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6), // Reduced border radius
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0), // Further reduced padding
                        ),
                        onChanged: (value) {
                          setState(() {
                            filteredLanguages = languageFlags.keys
                                .where((language) => language.toLowerCase().contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      // Language list
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: filteredLanguages.length,
                          itemBuilder: (context, index) {
                            final language = filteredLanguages[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  settingsProvider.setSelectedLanguage(language);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1a1a2e),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 28,
                                        height: 28,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                        child: Center(
                                          child: Text(
                                            languageFlags[language]!,
                                            style: const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        language,
                                        style: const TextStyle(color: Color(0xFFe0e0e0), fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Color(0xFFe0e0e0)),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'settings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                      ),
                ),
              ),
              const SizedBox(height: 32),
              // Language Section (Wrapped Box)
              Container(
                height: boxHeight,
                width: double.infinity,
                decoration: boxDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          const Text(
                            'Language',
                            style: labelStyle,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Consumer<SettingsProvider>(
                              builder: (context, provider, child) {
                                return GestureDetector(
                                  onTap: () => showLanguageDialog(context),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              languageFlags[provider.selectedLanguage]!,
                                              style: const TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          provider.selectedLanguage,
                                          style: const TextStyle(color: Color(0xFFe0e0e0), fontSize: 12),
                                        ),
                                        const Spacer(),
                                        const Icon(Icons.arrow_drop_down, color: Color(0xFFe0e0e0)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Notification Section (Wrapped Box with Toggle)
              Container(
                height: boxHeight,
                width: double.infinity,
                decoration: boxDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          const Text(
                            'Notification',
                            style: labelStyle,
                          ),
                        ],
                      ),
                      Consumer<SettingsProvider>(
                        builder: (context, provider, child) {
                          return Switch(
                            value: provider.notificationEnabled,
                            onChanged: (value) {
                              provider.setNotificationEnabled(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Download in High Quality Section (Wrapped Box)
              Container(
                height: boxHeight,
                width: double.infinity,
                decoration: boxDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          const Text(
                            'Download in High Quality',
                            style: labelStyle,
                          ),
                        ],
                      ),
                      Consumer<SettingsProvider>(
                        builder: (context, provider, child) {
                          return Switch(
                            value: provider.downloadInHighQuality,
                            onChanged: (value) {
                              provider.setDownloadInHighQuality(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Download Using Only Wi-Fi Section (Wrapped Box)
              Container(
                height: boxHeight,
                width: double.infinity,
                decoration: boxDecoration,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          const Text(
                            'Download Using Only Wi-Fi',
                            style: labelStyle,
                          ),
                        ],
                      ),
                      Consumer<SettingsProvider>(
                        builder: (context, provider, child) {
                          return Switch(
                            value: provider.downloadUsingWifiOnly,
                            onChanged: (value) {
                              provider.setDownloadUsingWifiOnly(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}