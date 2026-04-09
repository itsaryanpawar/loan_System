// lib/screens/loan/active_loans_screen.dart
import 'package:flutter/material.dart';

class ActiveLoansScreen extends StatefulWidget {
  // ✅ Accept userName from HomeScreen
  final String userName;

  const ActiveLoansScreen({
    Key? key,
    this.userName = '',
  }) : super(key: key);

  @override
  State<ActiveLoansScreen> createState() => _ActiveLoansScreenState();
}

class _ActiveLoansScreenState extends State<ActiveLoansScreen> {
  String _sortBy = 'Due Date';
  final List<String> _sortOptions = ['Due Date', 'Amount', 'Type'];

  static const _purpleColor = Color(0xFF8B5CF6);
  static const _blueColor = Color(0xFF3B82F6);

  // ✅ Resolve display name from userName (handles email or full name)
  String get _displayName {
    final input = widget.userName.trim();
    if (input.isEmpty) return 'User';

    // If it's an email, extract and format local part
    if (input.contains('@')) {
      final localPart = input.split('@').first;
      return localPart
          .split(RegExp(r'[._]'))
          .map((w) => w.isNotEmpty
              ? w[0].toUpperCase() + w.substring(1).toLowerCase()
              : '')
          .join(' ');
    }

    // Otherwise return first word capitalized
    final firstWord = input.split(' ').first;
    return firstWord[0].toUpperCase() + firstWord.substring(1);
  }

  // ✅ Resolve avatar letter
  String get _avatarLetter {
    final input = widget.userName.trim();
    if (input.isEmpty) return 'U';
    if (input.contains('@')) {
      return input.split('@').first[0].toUpperCase();
    }
    return input[0].toUpperCase();
  }

  late final List<Map<String, dynamic>> _activeLoans = [
    {
      'id': 'LN-ARY-001',
      'loanTo': 'Rohan Mehta',
      'category': 'Lent',
      'type': 'Personal',
      'principal': 25000,
      'outstanding': 20600,
      'nextEmiDate': '10 Apr 2024',
      'nextEmiAmount': 2200,
      'daysLeft': 5,
      'avatar': 'R',
      'avatarColor': _purpleColor,
      'interest': 0.0,
      'paid': 2,
      'total': 12,
      'isOverdue': false,
      'note': 'Lent to Rohan for medical expenses',
    },
    {
      'id': 'LN-ARY-002',
      'loanTo': 'HDFC Bank',
      'category': 'Borrowed',
      'type': 'Home',
      'principal': 1500000,
      'outstanding': 1456500,
      'nextEmiDate': '15 Apr 2024',
      'nextEmiAmount': 14500,
      'daysLeft': 10,
      'avatar': 'H',
      'avatarColor': _blueColor,
      'interest': 8.5,
      'paid': 3,
      'total': 120,
      'isOverdue': false,
      'note': 'Home loan - 10 year tenure',
    },
    {
      'id': 'LN-ARY-004',
      'loanTo': 'Vijay Finance',
      'category': 'Borrowed',
      'type': 'Vehicle',
      'principal': 120000,
      'outstanding': 120000,
      'nextEmiDate': '20 Mar 2024',
      'nextEmiAmount': 6500,
      'daysLeft': -15,
      'avatar': 'V',
      'avatarColor': _purpleColor,
      'interest': 12.0,
      'paid': 0,
      'total': 24,
      'isOverdue': true,
      'note': 'Bike loan - first EMI missed',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final overdueLoans =
        _activeLoans.where((l) => l['isOverdue'] as bool).length;
    final totalOutstanding = _activeLoans.fold<int>(
      0,
      (sum, l) => sum + (l['outstanding'] as int),
    );
    final upcomingEmi = _activeLoans
        .where((l) => !(l['isOverdue'] as bool))
        .fold<int>(0, (sum, l) => sum + (l['nextEmiAmount'] as int));

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
          'My Active Loans',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Color(0xFF6B7280)),
            onSelected: (value) => setState(() => _sortBy = value),
            itemBuilder: (context) => _sortOptions
                .map(
                  (opt) => PopupMenuItem(
                    value: opt,
                    child: Text(opt),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Dynamic User Profile + Stats Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                // ✅ Dynamic Profile Row
                Row(
                  children: [
                    // ✅ Dynamic Avatar Letter
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: Text(
                        _avatarLetter,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ✅ Dynamic Display Name
                          Text(
                            _displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Active Loan Summary',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Total Outstanding',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          '₹${_formatAmount(totalOutstanding)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBannerStat(
                      'Active',
                      '${_activeLoans.length}',
                      Icons.trending_up_rounded,
                    ),
                    _buildVerticalDivider(),
                    _buildBannerStat(
                      'Overdue',
                      '$overdueLoans',
                      Icons.warning_amber_rounded,
                    ),
                    _buildVerticalDivider(),
                    _buildBannerStat(
                      'Due This Month',
                      '₹${_formatAmount(upcomingEmi)}',
                      Icons.calendar_month_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Sort indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_activeLoans.length} Active Loans',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const Spacer(),
                Text(
                  'Sort: $_sortBy',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8B5CF6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Loan Cards
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _activeLoans.length,
              itemBuilder: (context, index) {
                return _buildActiveLoanCard(_activeLoans[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveLoanCard(Map<String, dynamic> loan) {
    final isOverdue = loan['isOverdue'] as bool;
    final daysLeft = loan['daysLeft'] as int;
    final progress = (loan['paid'] as int) / (loan['total'] as int);
    final isLent = loan['category'] == 'Lent';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isOverdue
            ? Border.all(
                color: const Color(0xFFEF4444).withValues(alpha: 0.5),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Overdue Banner
          if (isOverdue)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 16,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Overdue by ${daysLeft.abs()} days',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(16),
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
                        isLent ? 'Money Lent' : 'Money Borrowed',
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
                    // ✅ Avatar with first letter of loanTo name
                    CircleAvatar(
                      backgroundColor: loan['avatarColor'] as Color,
                      radius: 22,
                      child: Text(
                        loan['avatar'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLent
                                ? 'To: ${loan['loanTo']}'
                                : 'From: ${loan['loanTo']}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            '${loan['type']} • ${loan['interest']}% p.a.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${_formatAmount(loan['outstanding'] as int)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        const Text(
                          'Outstanding',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Note
                Text(
                  loan['note'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 12),

                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${loan['paid']}/${loan['total']} EMIs',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}% complete',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: const Color(0xFFE5E7EB),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isOverdue
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF10B981),
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Next EMI Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isOverdue
                        ? const Color(0xFFEF4444).withValues(alpha: 0.05)
                        : const Color(0xFF10B981).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: isOverdue
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF10B981),
                          ),
                          const SizedBox(width: 6),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isOverdue
                                    ? 'Due Date (Missed)'
                                    : 'Next EMI Date',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isOverdue
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                              Text(
                                loan['nextEmiDate'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'EMI Amount',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          Text(
                            '₹${_formatAmount(loan['nextEmiAmount'] as int)}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isOverdue
                                  ? const Color(0xFFEF4444)
                                  : const Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFFE5E7EB),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isOverdue
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          isOverdue
                              ? isLent
                                  ? 'Collect Now'
                                  : 'Pay Now'
                              : isLent
                                  ? 'Record EMI'
                                  : 'Pay EMI',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toString();
  }
}
