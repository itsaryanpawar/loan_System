import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/loan_application.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/progress_indicator_widget.dart';
import 'financial_details_screen.dart';

class BasicDetailsScreen extends StatefulWidget {
  final LoanApplication application;

  const BasicDetailsScreen({Key? key, required this.application})
      : super(key: key);

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate()) {
      widget.application.name = _nameController.text;
      widget.application.phoneNumber = _phoneController.text;
      widget.application.city = _cityController.text;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FinancialDetailsScreen(
            application: widget.application,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProgressIndicatorWidget(
                  currentStep: 2,
                  totalSteps: 4,
                ),
                const SizedBox(height: 32),

                const Text(
                  'Basic Details',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Tell us a bit about yourself',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                // ✅ Updated here
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        AppConstants.loanIcons[widget.application.loanType],
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        widget.application.loanType ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                CustomTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  validator: Validators.validateName,
                  prefixIcon: Icons.person_outline,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  label: 'Phone Number',
                  hint: 'Enter 10-digit mobile number',
                  controller: _phoneController,
                  validator: Validators.validatePhone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  label: 'City',
                  hint: 'Enter your city',
                  controller: _cityController,
                  validator: Validators.validateCity,
                  prefixIcon: Icons.location_city_outlined,
                ),

                const SizedBox(height: 32),

                CustomButton(
                  text: 'Continue',
                  onPressed: _continue,
                  icon: Icons.arrow_forward,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
