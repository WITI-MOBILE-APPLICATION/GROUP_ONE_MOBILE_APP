import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  final String packageName;
  final double price;
  final String voucher;

  const PaymentScreen({
    Key? key,
    required this.packageName,
    required this.price,
    required this.voucher,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? selectedPaymentMethod;

  // Map to associate package names with their frequency suffixes
  final Map<String, String> frequencySuffixes = {
    'Premium Daily': '/day',
    'Premium Weekly': '/week',
    'Premium Monthly': '/month',
    'Premium Yearly': '/year',
  };

  // Method to show the payment successful dialog
  void _showPaymentSuccessDialog(BuildContext context) {
    // Format the current date as "DD MMMM YYYY"
    String formattedDate = DateFormat('dd MMMM yyyy').format(DateTime.now());

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2A2E43),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Confetti icon with box
              SvgPicture.string(
                '''
                <svg width="64" height="64" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <!-- Box -->
                  <rect x="6" y="8" width="12" height="8" rx="1" fill="#FFD700"/>
                  <path d="M6 10H18" stroke="#DAA520" stroke-width="1"/>
                  <!-- Confetti -->
                  <circle cx="8" cy="6" r="1" fill="#FF4500"/>
                  <circle cx="16" cy="6" r="1" fill="#FF4500"/>
                  <circle cx="12" cy="4" r="1" fill="#00FF00"/>
                  <path d="M10 4 L11 6" stroke="#FFFF00" stroke-width="1"/>
                  <path d="M14 4 L15 6" stroke="#FFFF00" stroke-width="1"/>
                  <path d="M9 5 L10 7" stroke="#FF69B4" stroke-width="1"/>
                  <path d="M15 5 L16 7" stroke="#FF69B4" stroke-width="1"/>
                </svg>
                ''',
                width: 64,
                height: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Congrats your\npackage is acti...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Active on $formattedDate',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Auto extend',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  // Navigate to the home screen
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home', // Replace with your actual home route
                    (route) => false, // Remove all previous routes
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
                  'WATCH NOW',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.grey, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Other',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the frequency suffix based on packageName
    String frequency = frequencySuffixes[widget.packageName] ?? '';

    return Scaffold(
      backgroundColor: Color(0xFF06041F),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 20),
              // Order Summary
              Text(
                'Order Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color(0xFF2A2E43),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.packageName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'INCLUDING TAX AND AUTO-RENEW',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '\$${widget.price.toStringAsFixed(0)}$frequency',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Voucher code input coming soon!')),
                            );
                          },
                          child: Text(
                            'HAVE A VOUCHER CODE?',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: selectedPaymentMethod != null
                              ? () {
                                  _showPaymentSuccessDialog(context);
                                }
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Please select a payment method first!')),
                                  );
                                },
                          child: Container(
                            width: 80,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: selectedPaymentMethod != null
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.5),
                            ),
                            child: Center(
                              child: Text(
                                'Apply',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${widget.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Payment Method
              Text(
                'Payment Method',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildPaymentOption('Google Pay'),
              _buildPaymentOption('Apple Pay'),
              _buildPaymentOption('Other'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String method) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            method,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Radio<String>(
            value: method,
            groupValue: selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                selectedPaymentMethod = value;
              });
            },
            activeColor: Colors.white,
            fillColor: MaterialStateProperty.all(Colors.white),
          ),
        ],
      ),
    );
  }
}