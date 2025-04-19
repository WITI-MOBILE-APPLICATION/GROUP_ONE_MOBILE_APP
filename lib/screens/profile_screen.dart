import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 4; // Default to 'Me' tab

  void _navigateToPage(BuildContext context, String pageTitle) {
    if (pageTitle == 'Help') {
      Navigator.pushNamed(context, '/help');
    } else if (pageTitle == 'Setting') {
      Navigator.pushNamed(context, '/settings');
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: Container(),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 20),
                // Profile Image
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      image: const DecorationImage(
                        image: NetworkImage('https://picsum.photos/300/200?random=movie'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // User Name
                const Center(
                  child: Text(
                    'Millia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // User Handle
                const Center(
                  child: Text(
                    '@millia',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Menu Items
                _buildMenuItem(Icons.person_outline, 'My Profile', true),
                _buildMenuItem(Icons.notifications_outlined, 'Notification', false),
                _buildMenuItem(Icons.history, 'History', false),
                _buildMenuItem(Icons.card_membership_outlined, 'My Subscription', false),
                _buildMenuItem(Icons.settings_outlined, 'Setting', false),
                _buildMenuItem(Icons.help_outline, 'Help', false),
              ],
            ),
          ),
          // Bottom Navigation Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 38, 41, 62),
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
    return GestureDetector(
      onTap: () => _navigateToPage(context, title),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isBoxed ? const Color.fromARGB(255, 38, 41, 62) : const Color(0xFF2a2a3e),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color.fromARGB(255, 133, 133, 133).withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 72, 73, 81),
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
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Update selected index
        });
        if (label == 'Me') {
          // Already on ProfileScreen, no navigation needed
          return;
        }
        _navigateToPage(context, label);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index ? const Color.fromARGB(255, 254, 253, 253).withOpacity(0.7) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? const Color.fromARGB(255, 252, 250, 250).withOpacity(0.7) : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}