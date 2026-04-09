import 'package:flutter/material.dart';
import 'dart:math';

class EMICalculatorScreen extends StatefulWidget {
  const EMICalculatorScreen({Key? key}) : super(key: key);

  @override
  State<EMICalculatorScreen> createState() => _EMICalculatorScreenState();
}

class _EMICalculatorScreenState extends State<EMICalculatorScreen> {
  double _loanAmount = 100000;
  double _interestRate = 10;
  double _loanTenure = 12;

  double _monthlyEMI = 0;
  double _totalInterest = 0;
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _calculateEMI();
  }

  void _calculateEMI() {
    // EMI Formula: [P x R x (1+R)^N]/[(1+R)^N-1]
    double principal = _loanAmount;
    double rate = _interestRate / (12 * 100); // Monthly interest rate
    double tenure = _loanTenure;

    if (rate == 0) {
      _monthlyEMI = principal / tenure;
    } else {
      _monthlyEMI = (principal * rate * pow(1 + rate, tenure)) /
          (pow(1 + rate, tenure) - 1);
    }

    _totalAmount = _monthlyEMI * tenure;
    _totalInterest = _totalAmount - principal;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'EMI Calculator',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Result Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Monthly EMI',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '₹${_monthlyEMI.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildResultItem(
                        'Principal',
                        '₹${_loanAmount.toStringAsFixed(0)}',
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      _buildResultItem(
                        'Interest',
                        '₹${_totalInterest.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Loan Amount Slider
            _buildSliderSection(
              title: 'Loan Amount',
              value: _loanAmount,
              displayValue: '₹${_loanAmount.toStringAsFixed(0)}',
              min: 10000,
              max: 10000000,
              divisions: 999,
              onChanged: (value) {
                setState(() {
                  _loanAmount = value;
                  _calculateEMI();
                });
              },
            ),
            const SizedBox(height: 24),

            // Interest Rate Slider
            _buildSliderSection(
              title: 'Interest Rate (Per Annum)',
              value: _interestRate,
              displayValue: '${_interestRate.toStringAsFixed(1)}%',
              min: 1,
              max: 30,
              divisions: 290,
              onChanged: (value) {
                setState(() {
                  _interestRate = value;
                  _calculateEMI();
                });
              },
            ),
            const SizedBox(height: 24),

            // Loan Tenure Slider
            _buildSliderSection(
              title: 'Loan Tenure',
              value: _loanTenure,
              displayValue:
                  '${_loanTenure.toInt()} ${_loanTenure.toInt() == 1 ? 'Month' : 'Months'}',
              min: 1,
              max: 360,
              divisions: 359,
              onChanged: (value) {
                setState(() {
                  _loanTenure = value;
                  _calculateEMI();
                });
              },
            ),
            const SizedBox(height: 32),

            // Breakdown Card
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildBreakdownRow(
                    'Principal Amount',
                    '₹${_loanAmount.toStringAsFixed(0)}',
                    const Color(0xFF8B5CF6),
                  ),
                  const SizedBox(height: 12),
                  _buildBreakdownRow(
                    'Total Interest',
                    '₹${_totalInterest.toStringAsFixed(0)}',
                    const Color(0xFFEF4444),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  _buildBreakdownRow(
                    'Total Payment',
                    '₹${_totalAmount.toStringAsFixed(0)}',
                    const Color(0xFF10B981),
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Visual Chart
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Distribution',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          Expanded(
                            flex: (_loanAmount / _totalAmount * 100).toInt(),
                            child: Container(
                              color: const Color(0xFF8B5CF6),
                            ),
                          ),
                          Expanded(
                            flex: (_totalInterest / _totalAmount * 100).toInt(),
                            child: Container(
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem(
                        'Principal',
                        '${(_loanAmount / _totalAmount * 100).toStringAsFixed(1)}%',
                        const Color(0xFF8B5CF6),
                      ),
                      _buildLegendItem(
                        'Interest',
                        '${(_totalInterest / _totalAmount * 100).toStringAsFixed(1)}%',
                        const Color(0xFFEF4444),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Reset Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _loanAmount = 100000;
                    _interestRate = 10;
                    _loanTenure = 12;
                    _calculateEMI();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF8B5CF6),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                      color: Color(0xFF8B5CF6),
                      width: 2,
                    ),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Reset Calculator',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSliderSection({
    required String title,
    required double value,
    required String displayValue,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  displayValue,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF8B5CF6),
              inactiveTrackColor: const Color(0xFFE5E7EB),
              thumbColor: const Color(0xFF8B5CF6),
              overlayColor: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 12,
              ),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: isBold ? 16 : 15,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
