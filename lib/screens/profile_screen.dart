import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Default to 'Me' tab

  void _navigateToPage(BuildContext context, String pageTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(pageTitle)),
          body: Center(
            child: Text(
              '$pageTitle Page',
              style: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 41, 41, 41)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Save', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Container(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Container(
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
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Antonio Renders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    '@rendersantonio',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _buildMenuItem(Icons.person_outline, 'My Profile', true),
                _buildMenuItem(Icons.notifications_outlined, 'Notification', false),
                _buildMenuItem(Icons.history, 'History', false),
                _buildMenuItem(Icons.card_membership_outlined, 'My Subscription', false),
                _buildMenuItem(Icons.settings_outlined, 'Setting', false),
                _buildMenuItem(Icons.help_outline, 'Help', false),
                _buildMenuItem(Icons.logout, 'Logout', false),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFF151630),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(context, Icons.home_outlined, 'Home', 0),
                _buildNavItem(context, Icons.search, 'Search', 1),
                _buildNavItem(context, Icons.bookmark_border, 'Bookmarks', 2),
                _buildNavItem(context, Icons.download_outlined, 'Downloads', 3),
                _buildNavItem(context, Icons.person, 'Me', 4), // 'Me' as active
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Modified _buildMenuItem to conditionally display box
  Widget _buildMenuItem(IconData icon, String title, bool isBoxed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: isBoxed ? const EdgeInsets.all(16) : EdgeInsets.zero,
      decoration: isBoxed
          ? BoxDecoration(
              color: const Color.fromARGB(255, 38, 41, 62),
              borderRadius: BorderRadius.circular(15),
            )
          : null,
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
             shape: BoxShape.circle,
color: const Color.fromARGB(255, 80, 81, 93),
            ),
            child: Icon(icon, color: const Color.fromARGB(255, 144, 143, 143), size: 20),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update selected index
        });
        _navigateToPage(context, label);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? const Color.fromARGB(255, 254, 253, 253).withOpacity(0.7) : Colors.grey, // Transparent black for active state
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? const Color.fromARGB(255, 252, 250, 250).withOpacity(0.7) : Colors.grey, // Transparent black for active state
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
