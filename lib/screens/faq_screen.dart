import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4B3C),
        title: const Text(
          'FAQ',
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
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4B3C),
                ),
              ),
              const SizedBox(height: 20),
              _buildFAQItem(
                'What is Seva Setu?',
                'Seva Setu is a platform that connects citizens with government schemes and benefits they are eligible for. It acts as a bridge between your rights and you.',
              ),
              _buildFAQItem(
                'How do I know which schemes I\'m eligible for?',
                'Based on your profile information (age, income, location, etc.), Seva Setu automatically shows you schemes you might be eligible for. You can also use our chat assistant for personalized guidance.',
              ),
              _buildFAQItem(
                'How do I apply for schemes?',
                'Each scheme has detailed instructions and an "Apply Now" button. Follow the steps, submit required documents, and track your application status through your profile.',
              ),
              _buildFAQItem(
                'What documents do I need?',
                'Common documents include Aadhaar card, income certificate, and residence proof. Specific requirements are listed with each scheme.',
              ),
              _buildFAQItem(
                'Is my data secure?',
                'Yes, we follow strict security protocols and privacy guidelines to protect your personal information. Data is encrypted and only used for scheme verification.',
              ),
              _buildFAQItem(
                'How can I update my profile?',
                'Go to the Profile section from the bottom navigation bar. Click on "Edit Profile" to update your information.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8FAE0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B4B3C),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: const TextStyle(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 