import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'login_screen.dart';
import 'search_screen.dart';
import 'downloads_page.dart';
import '../services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'subscription_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Profile tab is selected by default (index 4)
  String username = "Guest User";
  String handle = "Not logged in";
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
        username = "Guest User";
        handle = "Not logged in";
      });
    }
  }

  Future<void> _loadUserData() async {
    final userJson = await _storage.read(key: 'current_user');
    if (userJson != null) {
      try {
        final userData = jsonDecode(userJson);
        setState(() {
          username = userData['name'] ?? "Guest User";
          handle = userData['email'] ?? "Not logged in";
          isLoggedIn = true;
        });
      } catch (e) {
        debugPrint('Error parsing user data: $e');
        setState(() {
          username = "Guest User";
          handle = "Not logged in";
          isLoggedIn = false;
        });
      }
    } else {
      setState(() {
        username = "Guest User";
        handle = "Not logged in";
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
        const SnackBar(
          content: Text('Logged out successfully',
              style: TextStyle(color: Colors.white)),
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
        username = "Guest User";
        handle = "Not logged in";
      });
    } catch (e) {
      debugPrint('Error during logout: $e');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error logging out: ${e.toString()}'),
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
                  const Text(
                    'My Profile',
                    style: TextStyle(
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
                  const Text(
                    'Are you sure you want to logout?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
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
                      child: const Text(
                        'NO',
                        style: TextStyle(
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
                    child: const Text(
                      'Yes, Logout',
                      style: TextStyle(
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

  // Navigation handler for menu items
  void _onMenuItemTapped(String title) {
    switch (title) {
      case 'My Profile':
        // Already on ProfileScreen, no action needed
        break;
      case 'My Subscription':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SubscriptionScreen()),
        );
        break;
      case 'Notification':
        // Navigate to Notification Screen (if implemented)
        break;
      case 'History':
        // Navigate to History Screen (if implemented)
        break;
      case 'Setting':
        // Navigate to Settings Screen (if implemented)
        break;
      case 'Logout':
        _showLogoutConfirmationModal(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06041F),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
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
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
            BottomNavigationBarItem(
                icon: Icon(Icons.download), label: 'Downloads'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
                        const Text(
                          'My Profile',
                          style: TextStyle(
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
                            'Auth Status: ${isLoggedIn ? "Logged In" : "Not Logged In"}',
                            style: TextStyle(
                              color: isLoggedIn ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        GestureDetector(
                          onTap: () => _onMenuItemTapped('My Profile'),
                          child: _buildMenuItem(Icons.person_outline, 'My Profile'),
                        ),
                        GestureDetector(
                          onTap: () => _onMenuItemTapped('Notification'),
                          child: _buildMenuItem(
                              Icons.notifications_outlined, 'Notification'),
                        ),
                        GestureDetector(
                          onTap: () => _onMenuItemTapped('History'),
                          child: _buildMenuItem(Icons.history, 'History'),
                        ),
                        GestureDetector(
                          onTap: () => _onMenuItemTapped('My Subscription'),
                          child: _buildMenuItem(
                              Icons.calendar_today_outlined, 'My Subscription'),
                        ),
                        GestureDetector(
                          onTap: () => _onMenuItemTapped('Setting'),
                          child: _buildMenuItem(Icons.settings_outlined, 'Setting'),
                        ),
                        GestureDetector(
                          onTap: () => _onMenuItemTapped('Logout'),
                          child: _buildMenuItem(Icons.logout, 'Logout'),
                        ),
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
    return Container(
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
    );
  }
}