import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'profile_screen.dart';

class NationalElectricForm extends StatefulWidget {
  const NationalElectricForm({Key? key}) : super(key: key);

  @override
  State<NationalElectricForm> createState() => _NationalElectricFormState();
}

class _NationalElectricFormState extends State<NationalElectricForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedIdentityProof;
  String? _selectedAddressProof;
  String? _selectedBankProof;
  String? _selectedIncomeProof;
  String? _selectedVehicleProof;
  String? _identityFile;
  String? _addressFile;
  String? _bankFile;
  String? _incomeFile;
  String? _vehicleFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();

  final List<String> _identityProofTypes = [
    'Aadhar Card',
    'Voter ID',
    'PAN Card',
  ];

  final List<String> _addressProofTypes = [
    'Voter ID',
    'Ration Card',
  ];

  final List<String> _bankProofTypes = [
    'Active Savings Account',
    'Bank Passbook Copy',
    'IFSC Code of the bank branch',
  ];

  final List<String> _incomeProofTypes = [
    'Income Tax Returns for the last two years',
    'Balance Sheet and Profit & Loss Account',
    'Bank statements of the current account',
    'Business registration certificates',
  ];

  final List<String> _vehicleProofTypes = [
    'Vehicle Registration Certificate (RC)',
    'Vehicle Insurance Document',
  ];

  Future<void> _pickFile(String type) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'pdf'],
      );

      if (result != null) {
        setState(() {
          switch (type) {
            case 'identity':
              _identityFile = result.files.single.name;
              break;
            case 'address':
              _addressFile = result.files.single.name;
              break;
            case 'bank':
              _bankFile = result.files.single.name;
              break;
            case 'income':
              _incomeFile = result.files.single.name;
              break;
            case 'vehicle':
              _vehicleFile = result.files.single.name;
              break;
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  Widget _buildDropdownWithUpload({
    required String label,
    required String type,
    required String? selectedValue,
    required List<String> items,
    required String? fileName,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                value: selectedValue,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: items.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: onChanged,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an option';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: InkWell(
                  onTap: () => _pickFile(type),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        fileName != null ? Icons.check_circle : Icons.upload_file,
                        color: fileName != null ? Colors.green : Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      const Text('Upload', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        if (fileName != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              'File: $fileName',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B4B3C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'National Electric Mobility Mission',
          style: TextStyle(
            color: Color(0xFF1B4B3C),
            fontWeight: FontWeight.bold,
          ),
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
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildDropdownWithUpload(
                label: 'Identity Proof',
                type: 'identity',
                selectedValue: _selectedIdentityProof,
                items: _identityProofTypes,
                fileName: _identityFile,
                onChanged: (value) => setState(() => _selectedIdentityProof = value),
              ),
              const SizedBox(height: 20),

              _buildDropdownWithUpload(
                label: 'Address Proof',
                type: 'address',
                selectedValue: _selectedAddressProof,
                items: _addressProofTypes,
                fileName: _addressFile,
                onChanged: (value) => setState(() => _selectedAddressProof = value),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _bankAccountController,
                decoration: const InputDecoration(
                  labelText: 'Bank Account Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter bank account number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildDropdownWithUpload(
                label: 'Bank Account Details',
                type: 'bank',
                selectedValue: _selectedBankProof,
                items: _bankProofTypes,
                fileName: _bankFile,
                onChanged: (value) => setState(() => _selectedBankProof = value),
              ),
              const SizedBox(height: 20),

              _buildDropdownWithUpload(
                label: 'Income Proof',
                type: 'income',
                selectedValue: _selectedIncomeProof,
                items: _incomeProofTypes,
                fileName: _incomeFile,
                onChanged: (value) => setState(() => _selectedIncomeProof = value),
              ),
              const SizedBox(height: 20),

              _buildDropdownWithUpload(
                label: 'Vehicle-Related Documents',
                type: 'vehicle',
                selectedValue: _selectedVehicleProof,
                items: _vehicleProofTypes,
                fileName: _vehicleFile,
                onChanged: (value) => setState(() => _selectedVehicleProof = value),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        _identityFile != null &&
                        _addressFile != null &&
                        _bankFile != null &&
                        _incomeFile != null &&
                        _vehicleFile != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Application Submitted Successfully')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields and upload all documents'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B4B3C),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Submit Application'),
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
    _nameController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }
}