import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'voucher_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String currentPlan = 'Free Plan';
  List<String> currentPlanFeatures = [
    'Basic access to movies',
    'Ads included',
    'Limited content availability',
  ];

  // Voucher details mapping to match VoucherScreen
  final Map<String, Map<String, dynamic>> planDetails = {
    'Premium Daily': {
      'features': [
        'Ad-free experience',
        'Access to all movies',
        'Exclusive content',
        'Cancel anytime',
      ],
    },
    'Premium Weekly': {
      'features': [
        'Ad-free experience',
        'Access to all movies',
        'Exclusive content',
        'Cancel anytime',
      ],
    },
    'Premium Monthly': {
      'features': [
        'Ad-free experience',
        'Access to all movies',
        'Exclusive content',
        'Cancel anytime',
      ],
    },
    'Premium Yearly': {
      'features': [
        'Ad-free experience',
        'Access to all movies',
        'Exclusive content',
        'Cancel anytime',
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _loadCurrentPlan();
  }

  Future<void> _loadCurrentPlan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedPlan = prefs.getString('currentPlan');
    if (savedPlan != null && planDetails.containsKey(savedPlan)) {
      setState(() {
        currentPlan = savedPlan;
        currentPlanFeatures =
            List<String>.from(planDetails[savedPlan]!['features']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF06041F),
      appBar: AppBar(
        backgroundColor: Color(0xFF06041F),
        elevation: 0,
        title: Text(
          'My Subscription',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Subscription Status (Expanded)
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Plan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.star_border,
                        color: Colors.yellow,
                        size: 40,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    currentPlan,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Features:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  ...currentPlanFeatures
                      .map((feature) => _buildFeatureItem(feature))
                      .toList(),
                  if (currentPlan == 'Free Plan') ...[
                    SizedBox(height: 10),
                    Text(
                      'Upgrade to unlock premium features!',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 20),

            // Upgrade Prompt
            Text(
              'Unlock More Features',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Upgrade your plan to enjoy an ad-free experience, access to all movies, and exclusive content.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 20),

            // Upgrade Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VoucherScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text(
                  'Upgrade Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            // Cancellation Policy
            Text(
              'Note: You can cancel your subscription anytime from this page.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// flutter build apk --debug