// // test/integration_test.dart

// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:loan_lead_app/main.dart';
// import 'package:loan_lead_app/services/api_service.dart';

// void main() {
//   group('Complete Application Flow Integration Tests', () {
//     testWidgets('Complete successful loan application submission',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(const MyApp());

//       // Step 1: Start application
//       await tester.tap(find.text('Check Eligibility Now'));
//       await tester.pumpAndSettle();

//       // Step 2: Select Personal Loan
//       await tester.tap(find.text('Personal Loan'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Continue'));
//       await tester.pumpAndSettle();

//       // Step 3: Fill basic details
//       await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
//       await tester.enterText(find.byType(TextFormField).at(1), '9876543210');
//       await tester.enterText(find.byType(TextFormField).at(2), 'Mumbai');

//       await tester.tap(find.text('Continue').last);
//       await tester.pumpAndSettle();

//       // Step 4: Fill financial details
//       await tester.enterText(find.byType(TextFormField).first, '50000');

//       await tester.tap(find.text('Salaried'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Check Eligibility'));
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // Step 5: Verify eligibility result
//       expect(find.text('Congratulations!'), findsOneWidget);
//       expect(find.text('You are eligible for Personal Loan'), findsOneWidget);

//       // Step 6: Submit application
//       await tester.tap(find.text('Submit Application'));
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // Step 7: Verify success screen
//       expect(find.text('Application Submitted!'), findsOneWidget);
//       expect(find.text('Thank you for applying'), findsOneWidget);
//     });

//     testWidgets('Application with low income shows under review',
//         (WidgetTester tester) async {
//       await tester.pumpWidget(const MyApp());

//       // Navigate through the flow
//       await tester.tap(find.text('Check Eligibility Now'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Personal Loan'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Continue'));
//       await tester.pumpAndSettle();

//       await tester.enterText(find.byType(TextFormField).at(0), 'Jane Smith');
//       await tester.enterText(find.byType(TextFormField).at(1), '9123456789');
//       await tester.enterText(find.byType(TextFormField).at(2), 'Delhi');

//       await tester.tap(find.text('Continue').last);
//       await tester.pumpAndSettle();

//       // Enter low income (below eligibility threshold for personal loan)
//       await tester.enterText(find.byType(TextFormField).first, '20000');

//       await tester.tap(find.text('Self-Employed'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Check Eligibility'));
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // Verify under review status
//       expect(find.text('Under Review'), findsOneWidget);
//       expect(find.text('Your application is under review'), findsOneWidget);
//     });
//   });

//   group('Admin Dashboard Tests', () {
//     testWidgets('Admin dashboard displays submitted applications',
//         (WidgetTester tester) async {
//       // Clear existing data first
//       final apiService = ApiService();
//       await apiService.clearAllApplications();

//       await tester.pumpWidget(const MyApp());

//       // Submit an application first
//       await tester.tap(find.text('Check Eligibility Now'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Business Loan'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Continue'));
//       await tester.pumpAndSettle();

//       await tester.enterText(find.byType(TextFormField).at(0), 'Test User');
//       await tester.enterText(find.byType(TextFormField).at(1), '9999999999');
//       await tester.enterText(find.byType(TextFormField).at(2), 'Bangalore');

//       await tester.tap(find.text('Continue').last);
//       await tester.pumpAndSettle();

//       await tester.enterText(find.byType(TextFormField).first, '60000');
//       await tester.tap(find.text('Business Owner'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Check Eligibility'));
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       await tester.tap(find.text('Submit Application'));
//       await tester.pumpAndSettle(const Duration(seconds: 3));

//       // Go to home and then admin dashboard
//       await tester.tap(find.text('Back to Home'));
//       await tester.pumpAndSettle();

//       await tester.tap(find.text('Admin Dashboard'));
//       await tester.pumpAndSettle();

//       // Verify application is shown
//       expect(find.text('Test User'), findsOneWidget);
//       expect(find.text('Business Loan'), findsOneWidget);
//       expect(find.text('1'), findsAtLeastNWidgets(1)); // Total leads count
//     });
//   });

//   group('API Service Tests', () {
//     test('Eligibility check for Personal Loan with high income returns true',
//         () {
//       final apiService = ApiService();

//       final application = LoanApplication(
//         loanType: 'Personal Loan',
//         monthlyIncome: '30000',
//       );

//       final result = apiService.checkEligibility(application);
//       expect(result, true);
//     });

//     test('Eligibility check for Personal Loan with low income returns false',
//         () {
//       final apiService = ApiService();

//       final application = LoanApplication(
//         loanType: 'Personal Loan',
//         monthlyIncome: '20000',
//       );

//       final result = apiService.checkEligibility(application);
//       expect(result, false);
//     });

//     test('Eligibility check for Home Loan with sufficient income returns true',
//         () {
//       final apiService = ApiService();

//       final application = LoanApplication(
//         loanType: 'Home Loan',
//         monthlyIncome: '60000',
//       );

//       final result = apiService.checkEligibility(application);
//       expect(result, true);
//     });
//   });
// }
