import 'package:flutter/material.dart';
import '../models/loan_application.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/progress_indicator_widget.dart';
import 'success_screen.dart';
import '../services/api_service.dart';

class EligibilityResultScreen extends StatelessWidget {
  final LoanApplication application;

  const EligibilityResultScreen({Key? key, required this.application})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isApproved = application.isApproved ?? false;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressIndicatorWidget(
                currentStep: 4,
                totalSteps: 4,
              ),
              const SizedBox(height: 32),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ✅ Result Icon
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: isApproved
                            ? AppColors.successGradient
                            : LinearGradient(
                                colors: [
                                  AppColors.warning,
                                  AppColors.warning.withValues(alpha: 0.8),
                                ],
                              ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isApproved ? Icons.check : Icons.hourglass_empty,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      isApproved ? 'Congratulations!' : 'Under Review',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      isApproved
                          ? 'You are eligible for ${application.loanType}'
                          : 'Your application is under review',
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 32),

                    // ✅ Application Summary Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                              'Loan Type', application.loanType ?? ''),
                          const Divider(height: 24),
                          _buildSummaryRow('Name', application.name ?? ''),
                          const Divider(height: 24),
                          _buildSummaryRow('Monthly Income',
                              '₹${application.monthlyIncome}'),
                          const Divider(height: 24),
                          _buildSummaryRow(
                              'Employment', application.employmentType ?? ''),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ✅ Success Info Box
                    if (isApproved)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.success),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Our team will contact you within 24 hours',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // ✅ Submit Button
              CustomButton(
                text: 'Submit Application',
                icon: Icons.send,
                onPressed: () async {
                  final apiService = ApiService();
                  final success =
                      await apiService.submitLoanApplication(application);

                  if (context.mounted) {
                    if (success) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuccessScreen(
                            application: application,
                          ),
                        ),
                        (route) => false,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to submit application. Please try again.',
                          ),
                          backgroundColor: AppColors.error,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
