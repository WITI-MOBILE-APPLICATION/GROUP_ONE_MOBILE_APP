import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<String> helpTopics = [
    'How to contact customer support moviestart',
    'How to unsubscribe from moviestart',
    'How to subscribe to moviestart',
    'Can’t watch moviestart',
    'What is moviestart?',
  ];
  List<String> filteredHelpTopics = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredHelpTopics = helpTopics;
    searchController.addListener(() {
      filterHelpTopics();
    });
  }

  // Filter help topics based on search input
  void filterHelpTopics() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredHelpTopics = helpTopics
          .where((topic) => topic.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Center(
                child: Text(
                  'Help',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        color: const Color(0xFFe0e0e0),
                      ),
                ),
              ),
              const SizedBox(height: 24),
              // Search Bar
              TextField(
                controller: searchController,
                style: const TextStyle(color: Color(0xFFe0e0e0), fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Get help',
                  hintStyle: const TextStyle(color: Color(0xFF9e9e9e), fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFe0e0e0), size: 20),
                  filled: true,
                  fillColor: const Color(0xFF2a2a3e),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                ),
              ),
              const SizedBox(height: 24),
              // Top Answers Section
              const Text(
                'Top answers',
                style: TextStyle(
                  color: Color(0xFFe0e0e0),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filteredHelpTopics.isEmpty
                    ? const Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(color: Color(0xFFe0e0e0), fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredHelpTopics.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                print('Tapped on: ${filteredHelpTopics[index]}');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2a2a3e),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        filteredHelpTopics[index],
                                        style: const TextStyle(
                                          color: Color(0xFFe0e0e0),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Color(0xFFe0e0e0),
                                      size: 16,
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
      ),
    );
  }
}