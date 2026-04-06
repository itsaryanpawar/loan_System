import 'package:flutter/material.dart';
import '../models/loan_application.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/loan_type_card.dart';
import '../widgets/progress_indicator_widget.dart';
import 'basic_details_screen.dart';

class LoanTypeScreen extends StatefulWidget {
  final LoanApplication application;

  const LoanTypeScreen({Key? key, required this.application}) : super(key: key);

  @override
  State<LoanTypeScreen> createState() => _LoanTypeScreenState();
}

class _LoanTypeScreenState extends State<LoanTypeScreen> {
  String? selectedLoanType;

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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProgressIndicatorWidget(
                currentStep: 1,
                totalSteps: 4,
              ),
              const SizedBox(height: 32),
              const Text(
                'Select Loan Type',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose the type of loan you need',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: AppConstants.loanTypes.map((loanType) {
                    return LoanTypeCard(
                      title: loanType,
                      icon: AppConstants.loanIcons[loanType]!,
                      isSelected: selectedLoanType == loanType,
                      onTap: () {
                        setState(() {
                          selectedLoanType = loanType;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Continue',
                onPressed: selectedLoanType != null
                    ? () {
                        widget.application.loanType = selectedLoanType;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BasicDetailsScreen(
                              application: widget.application,
                            ),
                          ),
                        );
                      }
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a loan type'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
