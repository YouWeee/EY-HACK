import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dashboard_screen.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _annualIncomeController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSource;
  final _ageController = TextEditingController();
  PlatformFile? _selectedFile;

  // List of categories
  final List<String> _categories = [
    'sc',
    'st',
    'obc',
    'general',
  ];

  // List of income sources
  final List<String> _incomeSources = [
    'Agriculture',
    'Teaching',
    'Business',
    'Corporate Job',
    'Healthcare',
    'Freelancing & Gig Economy',
    'Sports & Fitness',
    'Hospitality & Tourism',
    'Finance & Investments',
    'Technology & Software Development',
    'Media & Entertainment',
  ];

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error picking document'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildDocumentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    _selectedFile?.name ?? 'No file chosen',
                    style: TextStyle(
                      color: _selectedFile != null ? Colors.black : Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _pickDocument,
                icon: const Icon(Icons.attach_file),
                label: const Text('Choose File'),
              ),
            ],
          ),
        ),
        if (_selectedFile != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Selected file: ${_selectedFile!.name} (${(_selectedFile!.size / 1024).toStringAsFixed(2)} KB)',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FAE0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Tell us about Income',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _annualIncomeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Annual Income (in ₹)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  prefixText: '₹ ',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter your annual income';
                  }
                  if (int.tryParse(value!) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: _selectedSource,
                decoration: const InputDecoration(
                  labelText: 'Source of Income',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _incomeSources
                    .map((source) => DropdownMenuItem(
                          value: source,
                          child: Text(source),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSource = value;
                  });
                },
                validator: (value) {
                  if (value == null) return 'Please select a source of income';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: _categories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null) return 'Please select a category';
                  return null;
                },
              ),
              const SizedBox(height: 15),

              const Text(
                'Document Upload',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              _buildDocumentField(),
              const SizedBox(height: 15),

              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Age is required';
                  return null;
                },
              ),
              const SizedBox(height: 30),

              Center(
                child: SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _selectedFile != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardScreen(),
                          ),
                        );
                      } else if (_selectedFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please upload a document'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Next page',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _annualIncomeController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}