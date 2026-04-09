import 'package:flutter/material.dart';

class DisbursedAmountScreen extends StatefulWidget {
  const DisbursedAmountScreen({Key? key}) : super(key: key);

  @override
  State<DisbursedAmountScreen> createState() => _DisbursedAmountScreenState();
}

class _DisbursedAmountScreenState extends State<DisbursedAmountScreen> {
  String _selectedPeriod = 'This Month';
  String _selectedCategory = 'All';

  final List<String> _periods = [
    'This Week',
    'This Month',
    'Last 3 Months',
    'This Year',
    'All Time',
  ];

  final List<String> _categories = ['All', 'Money Lent', 'Money Borrowed'];

  static const _purpleColor = Color(0xFF8B5CF6);
  static const _blueColor = Color(0xFF3B82F6);

  // ✅ Aryan's disbursements only
  late final List<Map<String, dynamic>> _disbursements = [
    {
      'id': 'LN-ARY-001',
      'party': 'Rohan Mehta', // ✅ Aryan lent to Rohan
      'category': 'Lent',
      'type': 'Personal',
      'amount': 25000,
      'date': '10 Feb 2024',
      'method': 'UPI Transfer',
      'account': 'GPay → Rohan',
      'avatar': 'A',
      'avatarColor': _purpleColor,
      'recovered': 4400,
      'status': 'Partial',
      'note': 'Medical emergency',
    },
    {
      'id': 'LN-ARY-002',
      'party': 'HDFC Bank', // ✅ HDFC disbursed to Aryan
      'category': 'Borrowed',
      'type': 'Home',
      'amount': 1500000,
      'date': '15 Jan 2024',
      'method': 'Bank Transfer',
      'account': 'HDFC ****4521 → Aryan',
      'avatar': 'A',
      'avatarColor': _blueColor,
      'recovered': 43500,
      'status': 'Partial',
      'note': 'Home loan disbursement',
    },
    {
      'id': 'LN-ARY-003',
      'party': 'Sneha Kulkarni', // ✅ Aryan lent to Sneha - recovered
      'category': 'Lent',
      'type': 'Personal',
      'amount': 10000,
      'date': '05 Dec 2023',
      'method': 'Cash',
      'account': 'Cash to Sneha',
      'avatar': 'A',
      'avatarColor': _purpleColor,
      'recovered': 10000,
      'status': 'Recovered',
      'note': 'Fully recovered',
    },
    {
      'id': 'LN-ARY-004',
      'party': 'Vijay Finance', // ✅ Vijay Finance gave to Aryan
      'category': 'Borrowed',
      'type': 'Vehicle',
      'amount': 120000,
      'date': '20 Mar 2024',
      'method': 'Bank Transfer',
      'account': 'Vijay Finance → Aryan SBI',
      'avatar': 'A',
      'avatarColor': _purpleColor,
      'recovered': 0,
      'status': 'Pending',
      'note': 'Bike loan - no EMI paid yet',
    },
  ];

  final List<Map<String, dynamic>> _monthlyData = [
    {'month': 'Dec', 'lent': 10000, 'borrowed': 0},
    {'month': 'Jan', 'lent': 0, 'borrowed': 1500000},
    {'month': 'Feb', 'lent': 25000, 'borrowed': 0},
    {'month': 'Mar', 'lent': 0, 'borrowed': 120000},
  ];

  List<Map<String, dynamic>> get _filteredDisbursements {
    if (_selectedCategory == 'All') return _disbursements;
    if (_selectedCategory == 'Money Lent') {
      return _disbursements.where((d) => d['category'] == 'Lent').toList();
    }
    return _disbursements.where((d) => d['category'] == 'Borrowed').toList();
  }

  int get _totalLent => _disbursements
      .where((d) => d['category'] == 'Lent')
      .fold(0, (sum, d) => sum + (d['amount'] as int));

  int get _totalBorrowed => _disbursements
      .where((d) => d['category'] == 'Borrowed')
      .fold(0, (sum, d) => sum + (d['amount'] as int));

  int get _totalRecovered =>
      _disbursements.fold(0, (sum, d) => sum + (d['recovered'] as int));

  int get _totalDisbursed => _totalLent + _totalBorrowed;

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
          'My Disbursed Amount',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.download_outlined,
              color: Color(0xFF6B7280),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ✅ Aryan's Profile + Stats Banner
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  // Profile Row
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 22,
                        child: Text(
                          'A',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aryan Pawar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Disbursement Overview',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),

                  // Lent vs Borrowed
                  Row(
                    children: [
                      Expanded(
                        child: _buildBannerMiniStat(
                          'Money Lent',
                          '₹${_formatAmount(_totalLent)}',
                          Icons.arrow_upward_rounded,
                          Colors.greenAccent,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      Expanded(
                        child: _buildBannerMiniStat(
                          'Borrowed',
                          '₹${_formatAmount(_totalBorrowed)}',
                          Icons.arrow_downward_rounded,
                          Colors.orangeAccent,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      Expanded(
                        child: _buildBannerMiniStat(
                          'Recovered',
                          '₹${_formatAmount(_totalRecovered)}',
                          Icons.check_circle_outline,
                          Colors.lightBlueAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Period + Category Selectors
            SizedBox(
              height: 44,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _periods.length,
                itemBuilder: (context, index) {
                  final period = _periods[index];
                  final isSelected = _selectedPeriod == period;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPeriod = period),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFF3B82F6) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF3B82F6)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Text(
                        period,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),

            // Category Filter
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  Color catColor;
                  switch (cat) {
                    case 'Money Lent':
                      catColor = const Color(0xFF10B981);
                      break;
                    case 'Money Borrowed':
                      catColor = const Color(0xFF3B82F6);
                      break;
                    default:
                      catColor = const Color(0xFF8B5CF6);
                  }
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? catColor : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color:
                              isSelected ? catColor : const Color(0xFFE5E7EB),
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Monthly Bar Chart
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Aryan's Monthly Activity",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Lent',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Borrowed',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _monthlyData.map((data) {
                      final lent = data['lent'] as int;
                      final borrowed = data['borrowed'] as int;
                      final maxVal = 1500000;
                      final lentH = lent > 0 ? (lent / maxVal) * 80.0 : 4.0;
                      final borH =
                          borrowed > 0 ? (borrowed / maxVal) * 80.0 : 4.0;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  if (lent > 0)
                                    Text(
                                      '₹${_formatAmount(lent)}',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Color(0xFF10B981),
                                      ),
                                    ),
                                  const SizedBox(height: 2),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 600),
                                    width: 16,
                                    height: lentH,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 2),
                              Column(
                                children: [
                                  if (borrowed > 0)
                                    Text(
                                      '₹${_formatAmount(borrowed)}',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Color(0xFF3B82F6),
                                      ),
                                    ),
                                  const SizedBox(height: 2),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 600),
                                    width: 16,
                                    height: borH,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF3B82F6),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            data['month'] as String,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Transaction History',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_filteredDisbursements.length} records',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Disbursement Cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredDisbursements.length,
              itemBuilder: (context, index) {
                return _buildDisbursementCard(
                  _filteredDisbursements[index],
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDisbursementCard(Map<String, dynamic> data) {
    Color statusColor;
    switch (data['status']) {
      case 'Recovered':
        statusColor = const Color(0xFF10B981);
        break;
      case 'Partial':
        statusColor = const Color(0xFFF59E0B);
        break;
      default:
        statusColor = const Color(0xFFEF4444);
    }

    final amount = data['amount'] as int;
    final recovered = data['recovered'] as int;
    final recoveryPct = amount > 0 ? ((recovered / amount) * 100).toInt() : 0;
    final isLent = data['category'] == 'Lent';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isLent
                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                  : const Color(0xFF3B82F6).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLent
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 12,
                  color: isLent
                      ? const Color(0xFF10B981)
                      : const Color(0xFF3B82F6),
                ),
                const SizedBox(width: 4),
                Text(
                  isLent
                      ? 'Aryan → ${data['party']}'
                      : '${data['party']} → Aryan',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isLent
                        ? const Color(0xFF10B981)
                        : const Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              CircleAvatar(
                backgroundColor: data['avatarColor'] as Color,
                radius: 20,
                child: Text(
                  data['avatar'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['party'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      '${data['type']} • ${data['date']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${_formatAmount(amount)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      data['status'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Note
          Text(
            data['note'] as String,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 10),

          // Recovery Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isLent
                    ? 'Recovered: ₹${_formatAmount(recovered)}'
                    : 'Repaid: ₹${_formatAmount(recovered)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7280),
                ),
              ),
              Text(
                '$recoveryPct%',
                style: TextStyle(
                  fontSize: 11,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: recoveryPct / 100,
              backgroundColor: const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
              minHeight: 5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.account_balance_outlined,
                size: 12,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                '${data['method']} • ${data['account']}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerMiniStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toString();
  }
}
