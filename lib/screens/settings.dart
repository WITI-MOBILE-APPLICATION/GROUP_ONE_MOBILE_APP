// @dart=2.17
// import 'package:flutter/material.dart';

// class SettingScreen extends StatefulWidget {
//   const SettingScreen({super.key});

//   @override
//   _SettingScreenState createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   String selectedLanguage = 'English';
//   bool notificationsEnabled = true;
//   bool downloadHighQuality = true;
//   bool downloadUsingWifi = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0B0C1E),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0B0C1E),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         centerTitle: true,
//         title: const Text(
//           'Setting',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//         child: Column(
//           children: [
//             _buildSettingItem(
//               title: 'Language',
//               subtitle: selectedLanguage,
//               icon: Icons.language,
//               onTap: () {
//                 _showLanguageOptions();
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildSwitchSettingItem(
//               title: 'Notification',
//               icon: Icons.notifications_outlined,
//               value: notificationsEnabled,
//               onChanged: (value) {
//                 setState(() {
//                   notificationsEnabled = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildSwitchSettingItem(
//               title: 'Download in high quality',
//               icon: Icons.high_quality_outlined,
//               value: downloadHighQuality,
//               onChanged: (value) {
//                 setState(() {
//                   downloadHighQuality = value;
//                 });
//               },
//             ),
//             const SizedBox(height: 16),
//             _buildSwitchSettingItem(
//               title: 'Download using only Wi-Fi',
//               icon: Icons.wifi,
//               value: downloadUsingWifi,
//               onChanged: (value) {
//                 setState(() {
//                   downloadUsingWifi = value;
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingItem({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required VoidCallback onTap,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1B2E),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         leading: Container(
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(
//             color: Colors.grey.withOpacity(0.2),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             icon,
//             color: Colors.white,
//             size: 18,
//           ),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: TextStyle(
//             color: Colors.grey[400],
//             fontSize: 12,
//           ),
//         ),
//         trailing: const Icon(
//           Icons.chevron_right,
//           color: Colors.grey,
//           size: 20,
//         ),
//         onTap: onTap,
//       ),
//     );
//   }

//   Widget _buildSwitchSettingItem({
//     required String title,
//     required IconData icon,
//     required bool value,
//     required Function(bool) onChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color(0xFF1A1B2E),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         leading: Container(
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(
//             color: Colors.grey.withOpacity(0.2),
//             shape: BoxShape.circle,
//           ),
//           child: Icon(
//             icon,
//             color: Colors.white,
//             size: 18,
//           ),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         trailing: Switch(
//           value: value,
//           onChanged: onChanged,
//           activeColor: Colors.orange,
//           activeTrackColor: Colors.orange.withOpacity(0.3),
//         ),
//       ),
//     );
//   }

//   void _showLanguageOptions() {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF1A1B2E),
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Select Language',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildLanguageOption('English'),
//             _buildLanguageOption('Spanish'),
//             _buildLanguageOption('French'),
//             _buildLanguageOption('German'),
//             _buildLanguageOption('Chinese'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLanguageOption(String language) {
//     return ListTile(
//       title: Text(
//         language,
//         style: TextStyle(
//           color: selectedLanguage == language ? Colors.orange : Colors.white,
//           fontWeight: selectedLanguage == language
//               ? FontWeight.bold
//               : FontWeight.normal,
//         ),
//       ),
//       trailing: selectedLanguage == language
//           ? const Icon(Icons.check, color: Colors.orange)
//           : null,
//       onTap: () {
//         setState(() {
//           selectedLanguage = language;
//         });
//         Navigator.pop(context);
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_localizations.dart';
import 'language_provider.dart';
import 'language_selection_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String selectedLanguage = 'English';
  bool notificationsEnabled = true;
  bool downloadHighQuality = true;
  bool downloadUsingWifi = true;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final appLocalizations = AppLocalizations.of(context);

    // Get the current language name based on the locale
    String getCurrentLanguageName() {
      switch (languageProvider.locale.languageCode) {
        case 'en':
          return 'English';
        case 'de':
          return 'German';
        case 'hi':
          return 'Hindi';
        case 'id':
          return 'Indonesia';
        case 'it':
          return 'Italy';
        case 'ja':
          return 'Japan';
        case 'ko':
          return 'Korean';
        default:
          return 'English';
      }
    }

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
          appLocalizations?.translate('settings') ?? 'Settings',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            _buildSettingItem(
              title: appLocalizations?.translate('language') ?? 'Language',
              subtitle: getCurrentLanguageName(),
              icon: Icons.language,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LanguageScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildSwitchSettingItem(
              title:
                  appLocalizations?.translate('notification') ?? 'Notification',
              icon: Icons.notifications_outlined,
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSwitchSettingItem(
              title: appLocalizations?.translate('download_high_quality') ??
                  'Download in high quality',
              icon: Icons.high_quality_outlined,
              value: downloadHighQuality,
              onChanged: (value) {
                setState(() {
                  downloadHighQuality = value;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSwitchSettingItem(
              title: appLocalizations?.translate('download_wifi_only') ??
                  'Download using only Wi-Fi',
              icon: Icons.wifi,
              value: downloadUsingWifi,
              onChanged: (value) {
                setState(() {
                  downloadUsingWifi = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: Colors.grey,
          size: 20,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchSettingItem({
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1B2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }
}
