import 'package:flutter/material.dart';
import 'package:group_one_mobile_app/screens/payment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoucherScreen extends StatefulWidget {
  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  String? selectedVoucher;

  // Voucher details mapping
  final Map<String, Map<String, dynamic>> voucherDetails = {
    'Voucher 1': {'packageName': 'Premium Daily', 'price': 5.0},
    'Voucher 2': {'packageName': 'Premium Weekly', 'price': 50.0},
    'Voucher 3': {'packageName': 'Premium Monthly', 'price': 100.0},
    'Voucher 4': {'packageName': 'Premium Yearly', 'price': 900.0},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF06041F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'Choose your favorite package',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 30),
                _buildVoucherOption('Voucher 1'),
                _buildVoucherOption('Voucher 2'),
                _buildVoucherOption('Voucher 3'),
                _buildVoucherOption('Voucher 4'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVoucherOption(String voucherName) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF2A2E43),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: voucherName,
                      groupValue: selectedVoucher,
                      onChanged: (value) {
                        setState(() {
                          selectedVoucher = value;
                        });
                      },
                      activeColor: Colors.white,
                      fillColor: MaterialStateProperty.all(Colors.white),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          voucherDetails[voucherName]!['packageName'],
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          '\$${voucherDetails[voucherName]!['price'].toStringAsFixed(0)}',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Voucher code input coming soon!')),
                    );
                  },
                  child: Text(
                    'Have a voucher code?',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: selectedVoucher == voucherName
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          voucher: voucherName,
                          packageName: voucherDetails[voucherName]!['packageName'],
                          price: voucherDetails[voucherName]!['price'],
                        ),
                      ),
                    );
                  }
                : null,
            child: Container(
              width: 80,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: selectedVoucher == voucherName
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
    );
  }
}