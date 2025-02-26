import 'package:flutter/material.dart';

class AvailableSchemesScreen extends StatelessWidget {
  final String state;
  final int age;
  final String gender;
  final double annualIncome;
  final String category;

  const AvailableSchemesScreen({
    super.key,
    required this.state,
    required this.age,
    required this.gender,
    required this.annualIncome,
    required this.category,
  });

  List<Map<String, dynamic>> _getEligibleSchemes() {
    List<Map<String, dynamic>> allSchemes = [
      {
        'name': 'Pradhan Mantri Awas Yojana',
        'eligibility': 'Annual income < ₹3,00,000',
        'category': ['sc', 'st', 'obc', 'general'],
        'status': 'Available',
        'icon': Icons.home,
      },
      {
        'name': 'National Electric Mobility Scheme',
        'eligibility': 'Age > 18',
        'category': ['general', 'obc'],
        'status': 'Available',
        'icon': Icons.electric_car,
      },
      {
        'name': 'Pradhan Mantri Jeevan Jyoti Yojana',
        'eligibility': 'Age between 18-50',
        'category': ['sc', 'st', 'obc', 'general'],
        'status': 'Available',
        'icon': Icons.health_and_safety,
      },
    ];

    return allSchemes.where((scheme) {
      bool categoryMatch = scheme['category'].contains(category.toLowerCase());
      bool ageMatch = true;
      bool incomeMatch = true;

      if (scheme['name'] == 'Pradhan Mantri Awas Yojana') {
        incomeMatch = annualIncome < 300000;
      }
      if (scheme['name'] == 'Pradhan Mantri Jeevan Jyoti Yojana') {
        ageMatch = age >= 18 && age <= 50;
      }
      if (scheme['name'] == 'National Electric Mobility Scheme') {
        ageMatch = age >= 18;
      }

      return categoryMatch && ageMatch && incomeMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final eligibleSchemes = _getEligibleSchemes();

    return Scaffold(
      backgroundColor: const Color(0xFFE8FAE0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B4B3C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Available Schemes',
          style: TextStyle(
            color: Color(0xFF1B4B3C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Card
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eligibility Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B4B3C),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow('State', state),
                  _buildInfoRow('Age', age.toString()),
                  _buildInfoRow('Gender', gender),
                  _buildInfoRow('Annual Income', '₹${annualIncome.toStringAsFixed(2)}'),
                  _buildInfoRow('Category', category.toUpperCase()),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Eligible Schemes (${eligibleSchemes.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4B3C),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // Schemes List
            ...eligibleSchemes.map((scheme) => _buildSchemeCard(scheme, context)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(Map<String, dynamic> scheme, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to scheme details
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B4B3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    scheme['icon'],
                    color: const Color(0xFF1B4B3C),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        scheme['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        scheme['eligibility'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B4B3C).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    scheme['status'],
                    style: const TextStyle(
                      color: Color(0xFF1B4B3C),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 