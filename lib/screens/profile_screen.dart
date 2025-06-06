// @dart=2.17

import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'login_screen.dart';
import 'search_screen.dart';
import 'download_screen.dart';
import 'settings.dart';
import 'subscription_screen.dart';
import 'notification_screen.dart'; // Added import for NotificationScreen
import 'history_screen.dart'; // Added import for HistoryScreen
import '../services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4;
  String username = "Guest User";
  String handle = "Not Logged In";
  bool isLoggedIn = false;
  bool isLoading = true;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> refreshProfile() async {
    setState(() {
      isLoading = true;
    });
    await _initialize();
  }

  Future<void> _initialize() async {
    await _checkLoginStatus();
    await _loadUserData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _checkLoginStatus() async {
    final userJson = await _storage.read(key: 'current_user');
    setState(() {
      isLoggedIn = userJson != null;
    });

    debugPrint('----------------------------------------');
    debugPrint('LOGIN STATUS CHECK IN PROFILE SCREEN');
    debugPrint('User exists: $isLoggedIn');
    debugPrint('User JSON: $userJson');
    debugPrint('----------------------------------------');

    if (!isLoggedIn) {
      setState(() {
        username = AppLocalizations.of(context)!.translate('guest_user') ??
            "Guest User";
        handle = AppLocalizations.of(context)!.translate('not_logged_in') ??
            "Not Logged In";
      });
    }
  }

  Future<void> _loadUserData() async {
    final userJson = await _storage.read(key: 'current_user');
    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson);
        setState(() {
          username = userData['name'] ??
              (AppLocalizations.of(context)!.translate('guest_user') ??
                  "Guest User");
          handle = userData['email'] ??
              (AppLocalizations.of(context)!.translate('not_logged_in') ??
                  "Not Logged In");
          isLoggedIn = true;
        });
      } catch (e) {
        debugPrint('Error parsing user data: $e');
        setState(() {
          username = AppLocalizations.of(context)!.translate('guest_user') ??
              "Guest User";
          handle = AppLocalizations.of(context)!.translate('not_logged_in') ??
              "Not Logged In";
          isLoggedIn = false;
        });
      }
    } else {
      setState(() {
        username = AppLocalizations.of(context)!.translate('guest_user') ??
            "Guest User";
        handle = AppLocalizations.of(context)!.translate('not_logged_in') ??
            "Not Logged In";
        isLoggedIn = false;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    if (index == 0) {
      Navigator.of(context).pop();
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SearchScreen(apiKey: 'ab0608ff77e9b69c9583e1e673f95115'),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DownloadsPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        },
      );

      await _authService.signOut();

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('logged_out_success') ??
                'Logged Out Successfully',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );

      setState(() {
        isLoggedIn = false;
        username = AppLocalizations.of(context)!.translate('guest_user') ??
            "Guest User";
        handle = AppLocalizations.of(context)!.translate('not_logged_in') ??
            "Not Logged In";
      });
    } catch (e) {
      debugPrint('Error during logout: $e');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate('logout_error') ??
                'Error Logging Out: ${e.toString()}',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLogoutConfirmationModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF1A1B2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate('my_profile') ??
                        'My Profile',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    AppLocalizations.of(context)!
                            .translate('logout_confirmation') ??
                        'Are You Sure You Want to Logout?',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.translate('no') ?? 'No',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      logout(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate('yes_logout') ??
                          'Yes Logout',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C1E),
      bottomNavigationBar: Container(
        color: const Color(0xFF06041F),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF06041F),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.translate('home') ?? 'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label:
                  AppLocalizations.of(context)!.translate('search') ?? 'Search',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark),
              label:
                  AppLocalizations.of(context)!.translate('saved') ?? 'Saved',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.download),
              label: AppLocalizations.of(context)!.translate('downloads') ??
                  'Downloads',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: AppLocalizations.of(context)!.translate('profile') ??
                  'Profile',
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: refreshProfile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 25),
                        Text(
                          AppLocalizations.of(context)!
                                  .translate('my_profile') ??
                              'My Profile',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            image: const DecorationImage(
                              image: NetworkImage('https://picsum.photos/200'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          handle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            color: isLoggedIn
                                ? Colors.green.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!
                                    .translate('loggedin') ??
                                'Auth Status ${isLoggedIn ? (AppLocalizations.of(context)!.translate('logged_in') ?? "Logged In") : (AppLocalizations.of(context)!.translate('not_logged_in') ?? "Not Logged In")}',
                            style: TextStyle(
                              color: isLoggedIn ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        _buildMenuItem(
                            Icons.person_outline,
                            AppLocalizations.of(context)!
                                    .translate('my_profile') ??
                                'My Profile'),
                        _buildMenuItem(
                            Icons.notifications_outlined,
                            AppLocalizations.of(context)!
                                    .translate('notification') ??
                                'Notification'),
                        _buildMenuItem(
                            Icons.history,
                            AppLocalizations.of(context)!
                                    .translate('history') ??
                                'History'),
                        _buildMenuItem(
                            Icons.calendar_today_outlined,
                            AppLocalizations.of(context)!
                                    .translate('my_subscription') ??
                                'My Subscription'),
                        _buildMenuItem(
                            Icons.settings_outlined,
                            AppLocalizations.of(context)!
                                    .translate('settings') ??
                                'Settings'),
                        _buildMenuItem(
                            Icons.logout,
                            AppLocalizations.of(context)!.translate('logout') ??
                                'Logout'),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return GestureDetector(
      onTap: () {
        if (title ==
            (AppLocalizations.of(context)!.translate('settings') ??
                'Settings')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingScreen()),
          );
        } else if (title ==
            (AppLocalizations.of(context)!.translate('logout') ?? 'Logout')) {
          _showLogoutConfirmationModal(context);
        } else if (title ==
            (AppLocalizations.of(context)!.translate('my_subscription') ??
                'My Subscription')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SubscriptionScreen()),
          );
        } else if (title ==
            (AppLocalizations.of(context)!.translate('notification') ??
                'Notification')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationScreen()),
          );
        } else if (title ==
            (AppLocalizations.of(context)!.translate('history') ?? 'History')) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryScreen()),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1B2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
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
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
