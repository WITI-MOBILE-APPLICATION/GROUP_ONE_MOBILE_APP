// @dart=2.17

import 'package:flutter/material.dart';
import 'app_localizations.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  List<HistoryItem> historyItems = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadHistoryData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistoryData() async {
    setState(() {
      isLoading = true;
    });

    // Simulate loading history data
    await Future.delayed(const Duration(milliseconds: 800));

    // Sample history data
    setState(() {
      historyItems = [
        HistoryItem(
          id: '1',
          title: 'Avengers: Endgame',
          category: 'Movies',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          thumbnail: 'https://picsum.photos/id/231/200/300',
          duration: '2h 32m',
          action: HistoryAction.watched,
        ),
        HistoryItem(
          id: '2',
          title: 'Breaking Bad Season 4',
          category: 'TV Shows',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          thumbnail: 'https://picsum.photos/id/232/200/300',
          duration: '46m',
          action: HistoryAction.paused,
          progress: 0.7,
        ),
        HistoryItem(
          id: '3',
          title: 'The Dark Knight',
          category: 'Movies',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          thumbnail: 'https://picsum.photos/id/233/200/300',
          duration: '2h 32m',
          action: HistoryAction.watched,
        ),
        HistoryItem(
          id: '4',
          title: 'Friends Season 3',
          category: 'TV Shows',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          thumbnail: 'https://picsum.photos/id/234/200/300',
          duration: '22m',
          action: HistoryAction.paused,
          progress: 0.3,
        ),
        HistoryItem(
          id: '5',
          title: 'Inception',
          category: 'Movies',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          thumbnail: 'https://picsum.photos/id/235/200/300',
          duration: '2h 28m',
          action: HistoryAction.watched,
        ),
        HistoryItem(
          id: '6',
          title: 'Stranger Things Season 2',
          category: 'TV Shows',
          timestamp: DateTime.now().subtract(const Duration(days: 4)),
          thumbnail: 'https://picsum.photos/id/236/200/300',
          duration: '51m',
          action: HistoryAction.paused,
          progress: 0.9,
        ),
      ];
      isLoading = false;
    });
  }

  Future<void> _refreshHistory() async {
    await _loadHistoryData();
  }

  void _clearAllHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1B2E),
        title: Text(
          AppLocalizations.of(context)!.translate('clear_history_title') ??
              'Clear History',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          AppLocalizations.of(context)!.translate('clear_history_confirm') ??
              'Are you sure you want to clear all your viewing history? This action cannot be undone.',
          style: const TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.translate('cancel') ?? 'Cancel',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                historyItems.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!
                            .translate('history_cleared') ??
                        'History cleared',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context)!.translate('clear') ?? 'Clear',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  List<HistoryItem> _getFilteredItems(HistoryAction? actionFilter) {
    if (actionFilter == null) {
      return historyItems;
    }
    return historyItems.where((item) => item.action == actionFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF06041F),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.translate('history') ?? 'History',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: historyItems.isEmpty ? null : _clearAllHistory,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.translate('All') ?? 'All'),
            Tab(
                text: AppLocalizations.of(context)!.translate('Watched') ??
                    'Watched'),
            Tab(
                text: AppLocalizations.of(context)!.translate('In progress') ??
                    'In Progress'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : TabBarView(
              controller: _tabController,
              children: [
                _buildHistoryList(_getFilteredItems(null)),
                _buildHistoryList(_getFilteredItems(HistoryAction.watched)),
                _buildHistoryList(_getFilteredItems(HistoryAction.paused)),
              ],
            ),
    );
  }

  Widget _buildHistoryList(List<HistoryItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.history,
              size: 70,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.translate('no_history') ??
                  'No viewing history',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                AppLocalizations.of(context)!
                        .translate('history_empty_message') ??
                    'Your viewing history will appear here',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshHistory,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Dismissible(
            key: Key(item.id),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                historyItems
                    .removeWhere((historyItem) => historyItem.id == item.id);
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1B2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Image.network(
                          item.thumbnail,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[800],
                            child: const Icon(Icons.image_not_supported,
                                color: Colors.white),
                          ),
                        ),
                        if (item.action == HistoryAction.paused)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: LinearProgressIndicator(
                              value: item.progress,
                              backgroundColor: Colors.grey[800],
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.red),
                              minHeight: 3,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                item.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                item.duration,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                item.action == HistoryAction.watched
                                    ? Icons.check_circle_outline
                                    : Icons.pause_circle_outline,
                                color: item.action == HistoryAction.watched
                                    ? Colors.green
                                    : Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.action == HistoryAction.watched
                                    ? (AppLocalizations.of(context)!
                                            .translate('watched') ??
                                        'Watched')
                                    : (AppLocalizations.of(context)!
                                            .translate('continue_watching') ??
                                        'Continue Watching'),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: item.action == HistoryAction.watched
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getTimeAgo(item.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 7) {
      return '${time.day}/${time.month}/${time.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}

enum HistoryAction {
  watched,
  paused,
}

class HistoryItem {
  final String id;
  final String title;
  final String category;
  final DateTime timestamp;
  final String thumbnail;
  final String duration;
  final HistoryAction action;
  final double progress;

  HistoryItem({
    required this.id,
    required this.title,
    required this.category,
    required this.timestamp,
    required this.thumbnail,
    required this.duration,
    required this.action,
    this.progress = 1.0,
  });
}
