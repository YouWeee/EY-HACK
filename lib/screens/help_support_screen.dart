import 'package:flutter/material.dart';
import 'gpt_screen.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4B3C),
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How can we help you?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4B3C),
                ),
              ),
              const SizedBox(height: 20),
              
              // Contact Options
              _buildContactOption(
                context,
                icon: Icons.chat_bubble_outline,
                title: 'Chat with Us',
                subtitle: 'Start a conversation with our support team',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GptScreen(),
                    ),
                  );
                },
              ),
              
              _buildContactOption(
                context,
                icon: Icons.email_outlined,
                title: 'Email Support',
                subtitle: 'support@sevasetu.com',
                onTap: () {
                  // Implement email functionality
                },
              ),
              
              _buildContactOption(
                context,
                icon: Icons.phone_outlined,
                title: 'Call Us',
                subtitle: 'Toll-Free: 1800-XXX-XXXX',
                onTap: () {
                  // Implement call functionality
                },
              ),
              
              const SizedBox(height: 30),
              
              // Common Issues Section
              const Text(
                'Common Issues',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4B3C),
                ),
              ),
              const SizedBox(height: 15),
              
              _buildIssueCard(
                'Application Status',
                'Track your scheme application status',
                Icons.assignment_outlined,
              ),
              
              _buildIssueCard(
                'Document Upload',
                'Issues with uploading documents',
                Icons.upload_file_outlined,
              ),
              
              _buildIssueCard(
                'Technical Support',
                'App-related technical issues',
                Icons.computer_outlined,
              ),
              
              const SizedBox(height: 30),
              
              // Office Address
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8FAE0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Office Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Seva Setu Office\n'
                      'Street Address\n'
                      'City, State - PIN\n'
                      'India',
                      style: TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      color: const Color(0xFFE8FAE0),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1B4B3C)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  Widget _buildIssueCard(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF1B4B3C), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1B4B3C)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 