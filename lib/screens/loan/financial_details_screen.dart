import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/loan_application.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/progress_indicator_widget.dart';
import '../eligibility/eligibility_result_screen.dart';
import '../../services/api_service.dart';

class FinancialDetailsScreen extends StatefulWidget {
  final LoanApplication application;

  const FinancialDetailsScreen({Key? key, required this.application})
      : super(key: key);

  @override
  State<FinancialDetailsScreen> createState() => _FinancialDetailsScreenState();
}

class _FinancialDetailsScreenState extends State<FinancialDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  String? selectedEmploymentType;
  bool _isLoading = false;

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  Future<void> _checkEligibility() async {
    if (_formKey.currentState!.validate() && selectedEmploymentType != null) {
      setState(() => _isLoading = true);

      widget.application.monthlyIncome = _incomeController.text;
      widget.application.employmentType = selectedEmploymentType;

      // Check eligibility
      final apiService = ApiService();
      final isEligible = apiService.checkEligibility(widget.application);
      widget.application.isApproved = isEligible;

      await Future.delayed(const Duration(seconds: 2)); // Simulate processing

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EligibilityResultScreen(
              application: widget.application,
            ),
          ),
        );
      }
    } else if (selectedEmploymentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select employment type'),
          backgroundColor: AppColors.error,
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
                  currentStep: 3,
                  totalSteps: 4,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Financial Details',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Help us understand your financial situation',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                /// Income Field
                CustomTextField(
                  label: 'Monthly Income',
                  hint: 'Enter your monthly income',
                  controller: _incomeController,
                  validator: Validators.validateIncome,
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.currency_rupee,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),

                const SizedBox(height: 24),

                /// Employment Type Label
                const Text(
                  'Employment Type',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                /// Employment Options
                ...AppConstants.employmentTypes.map((type) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildEmploymentCard(type),
                  );
                }).toList(),

                const SizedBox(height: 32),

                /// Button
                CustomButton(
                  text: 'Check Eligibility',
                  onPressed: _checkEligibility,
                  isLoading: _isLoading,
                  icon: Icons.verified_user,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmploymentCard(String type) {
    final isSelected = selectedEmploymentType == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedEmploymentType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          // ✅ UPDATED HERE
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE0E0E0),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Text(
              type,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
