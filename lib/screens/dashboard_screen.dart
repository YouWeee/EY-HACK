import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'medical_schemes_screen.dart';
import 'vehicle_schemes_screen.dart';
import 'family_schemes_screen.dart';
import 'personal_schemes_screen.dart';
import 'gpt_screen.dart';
import 'available_schemes_screen.dart';
import 'faq_screen.dart';
import 'help_support_screen.dart';

class DashboardScreen extends StatelessWidget {
  final String userName;
  const DashboardScreen({super.key, this.userName = 'Priya'});

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Section with Profile and Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Replace this CircleAvatar
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: IconButton(
                            icon: const Icon(Icons.person, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, $userName',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'LET\'S HELP YOU LOOK AT THE',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const Text(
                            'SCHEMES YOU ARE ELIGIBLE FOR',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.chat_outlined),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.smart_toy_outlined,
                                            color: Color(0xFF1B4B3C),
                                            size: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Chat Assistant',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1B4B3C),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      
                                      // Content
                                      const Text(
                                        'Hello! I\'m your Seva Setu assistant.\nHow can I help you today?',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'I can help you with:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      const Text('• Finding suitable schemes'),
                                      const Text('• Application process'),
                                      const Text('• Document requirements'),
                                      const Text('• Eligibility criteria'),
                                      
                                      const SizedBox(height: 24),
                                      
                                      // Buttons
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text(
                                              'Close',
                                              style: TextStyle(
                                                color: Color(0xFF1B4B3C),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => const GptScreen(),
                                                ),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF1B4B3C),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text(
                                              'Start Chat',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // Location Card
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B4B3C),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Icon(Icons.location_on, color: Colors.white),
                    ),
                    const Text(
                      'Madhya Pradesh',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 40), // Spacer
                  ],
                ),
              ),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search Scheme',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Available Schemes Section
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8FAE0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AvailableSchemesScreen(
                          state: 'Madhya Pradesh',
                          age: 28,
                          gender: 'Female',
                          annualIncome: 120000,
                          category: 'OBC',
                        ),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available schemes for priya',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.info_outline),
                    ],
                  ),
                ),
              ),

              // Recommended Schemes Section
             const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recommended Schemes →',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {

                      },
                  ),
                ],
              ),

              // Scheme Categories
              const SizedBox(height: 20),
                // First Row: Personal and Medical
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PersonalSchemesScreen(),
                                ),
                            );
                          
                        },
                        child: _buildCategoryCard(
                          icon: Icons.person,
                          title: 'Personal',
                          color: const Color(0xFFE8FAE0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MedicalSchemesScreen(),
                              ),
                            );
                          
                        },
                        child: _buildCategoryCard(
                          icon: Icons.medical_services,
                          title: 'Medical',
                          color: const Color(0xFFE8FAE0),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Second Row: Family and Vehicle
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const FamilySchemesScreen(),
                                    
                                ),
                            );
                        },
                        child: _buildCategoryCard(
                          icon: Icons.family_restroom,
                          title: 'Family',
                          color: const Color(0xFFE8FAE0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VehicleSchemesScreen(),
                            ),
                          );
                        },
                        child: _buildCategoryCard(
                          icon: Icons.agriculture,
                          title: 'Vehicle',
                          color: const Color(0xFFE8FAE0),
                        ),
                      ),
                    ),
                  ],
                ),
            const SizedBox(height: 20),
                const Text(
                  'Learn More about →',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // Scheme List
                const SizedBox(height: 15),
                _buildClickableSchemeItem('FAQ'),
                _buildClickableSchemeItem('HELP AND SUPPORT'),
               

                const SizedBox(height: 80), // Bottom spacing for navigation bar
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1B4B3C),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: 0,
         onTap: (index) {
            if (index ==1){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
            }
          
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildClickableSchemeItem(String title) {
    return Builder(
      builder: (BuildContext context) {
        return InkWell(
          onTap: () {
            if (title == 'FAQ') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FAQScreen(),
                ),
              );
            } else if (title == 'HELP AND SUPPORT') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HelpSupportScreen(),
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFE8FAE0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Icon(Icons.info_outline, size: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, size: 30),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}