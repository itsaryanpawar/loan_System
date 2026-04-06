// test/widget_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loan_lead_app/main.dart';

void main() {
  testWidgets('App launches with home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app name is displayed
    expect(find.text('QuickLoan'), findsOneWidget);

    // Verify that the main heading is displayed
    expect(find.text('Get Instant Loan'), findsOneWidget);

    // Verify that the CTA button is displayed
    expect(find.text('Check Eligibility Now'), findsOneWidget);

    // Verify trust badges are displayed
    expect(find.text('100% Secure'), findsOneWidget);
    expect(find.text('Instant Approval'), findsOneWidget);
  });

  testWidgets('Navigation to loan type screen works',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Find and tap the Check Eligibility button
    final eligibilityButton = find.text('Check Eligibility Now');
    expect(eligibilityButton, findsOneWidget);

    await tester.tap(eligibilityButton);
    await tester.pumpAndSettle();

    // Verify navigation to loan type screen
    expect(find.text('Select Loan Type'), findsOneWidget);
    expect(find.text('Personal Loan'), findsOneWidget);
    expect(find.text('Business Loan'), findsOneWidget);
    expect(find.text('Home Loan'), findsOneWidget);
  });

  testWidgets('Loan type selection works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to loan type screen
    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    // Find and tap Personal Loan
    final personalLoanCard = find.text('Personal Loan');
    expect(personalLoanCard, findsOneWidget);

    await tester.tap(personalLoanCard);
    await tester.pumpAndSettle();

    // Tap continue button
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Verify navigation to basic details screen
    expect(find.text('Basic Details'), findsOneWidget);
  });

  testWidgets('Form validation works on basic details screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to basic details screen
    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Personal Loan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Try to continue without filling form
    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    // Verify validation messages appear
    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your phone number'), findsOneWidget);
    expect(find.text('Please enter your city'), findsOneWidget);
  });

  testWidgets('Phone number validation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to basic details screen
    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Personal Loan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Enter invalid phone number
    final phoneField = find.byType(TextFormField).at(1);
    await tester.enterText(phoneField, '123');

    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    // Verify validation message
    expect(find.text('Please enter a valid 10-digit phone number'),
        findsOneWidget);
  });

  testWidgets('Complete application flow works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Step 1: Navigate to loan type screen
    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    // Step 2: Select loan type
    await tester.tap(find.text('Personal Loan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Step 3: Fill basic details
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(1), '9876543210');
    await tester.enterText(find.byType(TextFormField).at(2), 'Mumbai');

    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    // Step 4: Verify navigation to financial details screen
    expect(find.text('Financial Details'), findsOneWidget);
  });

  testWidgets('Admin dashboard shows no applications initially',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to admin dashboard
    await tester.tap(find.text('Admin Dashboard'));
    await tester.pumpAndSettle();

    // Verify admin dashboard elements
    expect(find.text('Admin Dashboard'), findsOneWidget);
    expect(find.text('Total Leads'), findsOneWidget);
    expect(find.text('Approved'), findsOneWidget);
    expect(find.text('Under Review'), findsOneWidget);
  });

  testWidgets('Progress indicator shows correct step',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to loan type screen (Step 1)
    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    expect(find.text('Step 1 of 4'), findsOneWidget);

    // Navigate to basic details (Step 2)
    await tester.tap(find.text('Personal Loan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Step 2 of 4'), findsOneWidget);
  });

  testWidgets('Trust badges are displayed on home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify all trust badges
    expect(find.text('100% Secure'), findsOneWidget);
    expect(find.text('Instant Approval'), findsOneWidget);
    expect(find.text('Bank-Grade Security'), findsOneWidget);

    // Verify trust badge icons
    expect(find.byIcon(Icons.verified_user), findsWidgets);
    expect(find.byIcon(Icons.flash_on), findsWidgets);
    expect(find.byIcon(Icons.shield), findsWidgets);
  });

  testWidgets('All loan types are displayed correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    // Verify all loan types with their icons
    expect(find.text('Personal Loan'), findsOneWidget);
    expect(find.text('Business Loan'), findsOneWidget);
    expect(find.text('Home Loan'), findsOneWidget);

    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.business_center), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
  });

  testWidgets('Back navigation works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate forward
    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    // Verify we're on loan type screen
    expect(find.text('Select Loan Type'), findsOneWidget);

    // Navigate back
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Verify we're back on home screen
    expect(find.text('Get Instant Loan'), findsOneWidget);
  });

  testWidgets('Employment type selection works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to financial details screen
    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Personal Loan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Fill basic details
    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(1), '9876543210');
    await tester.enterText(find.byType(TextFormField).at(2), 'Mumbai');

    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    // Verify employment types are displayed
    expect(find.text('Salaried'), findsOneWidget);
    expect(find.text('Self-Employed'), findsOneWidget);
    expect(find.text('Business Owner'), findsOneWidget);
    expect(find.text('Freelancer'), findsOneWidget);
  });

  testWidgets('Income field only accepts numbers', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to financial details
    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Personal Loan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(1), '9876543210');
    await tester.enterText(find.byType(TextFormField).at(2), 'Mumbai');

    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    // Try to enter text in income field
    final incomeField = find.byType(TextFormField).first;
    await tester.enterText(incomeField, 'abc');
    await tester.pumpAndSettle();

    // The field should be empty as it only accepts digits
    final textField = tester.widget<TextFormField>(incomeField);
    expect(textField.controller?.text, isEmpty);
  });

  testWidgets('Name validation rejects numbers', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to basic details
    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Personal Loan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Enter name with numbers
    await tester.enterText(find.byType(TextFormField).at(0), 'John123');
    await tester.enterText(find.byType(TextFormField).at(1), '9876543210');
    await tester.enterText(find.byType(TextFormField).at(2), 'Mumbai');

    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    // Verify validation error
    expect(find.text('Name can only contain letters'), findsOneWidget);
  });

  testWidgets('Minimum income validation works', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Navigate to financial details
    await tester.tap(find.text('Check Eligibility Now'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Personal Loan'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'John Doe');
    await tester.enterText(find.byType(TextFormField).at(1), '9876543210');
    await tester.enterText(find.byType(TextFormField).at(2), 'Mumbai');

    await tester.tap(find.text('Continue').last);
    await tester.pumpAndSettle();

    // Enter income below minimum
    await tester.enterText(find.byType(TextFormField).first, '5000');

    await tester.tap(find.text('Salaried'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Check Eligibility'));
    await tester.pumpAndSettle();

    // Verify validation error
    expect(find.text('Income must be at least ₹10,000'), findsOneWidget);
  });
}
