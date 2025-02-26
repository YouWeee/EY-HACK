import 'package:flutter/material.dart';

class AdminStatisticsScreen extends StatelessWidget {
  const AdminStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FAE0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4B3C),
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Application Statistics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4B3C),
              ),
            ),
            const SizedBox(height: 20),
            
            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Users',
                    '150',
                    Icons.people_outline,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    'Active Applications',
                    '90',
                    Icons.description_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Approved',
                    '55',
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    '5',
                    Icons.pending_outlined,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // Popular Schemes Section
            const Text(
              'Most Applied Schemes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4B3C),
              ),
            ),
            const SizedBox(height: 15),
            _buildSchemeCard(
              'PM Awas Yojana',
              '40 applications',
              '75% approval rate',
            ),
            _buildSchemeCard(
              'PM Kisan Samman Nidhi',
              '30 applications',
              '82% approval rate',
            ),
            _buildSchemeCard(
              'Ayushman Bharat',
              '20 applications',
              '68% approval rate',
            ),
            
            const SizedBox(height: 30),
            
            // State-wise Distribution
            const Text(
              'State-wise Distribution',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B4B3C),
              ),
            ),
            const SizedBox(height: 15),
            _buildStateCard('Madhya Pradesh', '55'),
            _buildStateCard('Maharashtra', '28'),
            _buildStateCard('Gujarat', '27'),
            _buildStateCard('Rajasthan', '23'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, {Color color = const Color(0xFF1B4B3C)}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(String title, String applications, String approvalRate) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1B4B3C), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                applications,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE8FAE0),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              approvalRate,
              style: const TextStyle(
                color: Color(0xFF1B4B3C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateCard(String state, String users) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            state,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '$users users',
            style: const TextStyle(
              color: Color(0xFF1B4B3C),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
} 