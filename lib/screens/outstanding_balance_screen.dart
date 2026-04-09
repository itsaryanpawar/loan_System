import 'package:flutter/material.dart';

class OutstandingBalanceScreen extends StatefulWidget {
  const OutstandingBalanceScreen({Key? key}) : super(key: key);

  @override
  State<OutstandingBalanceScreen> createState() =>
      _OutstandingBalanceScreenState();
}

class _OutstandingBalanceScreenState extends State<OutstandingBalanceScreen> {
  String _selectedView = 'All';
  final List<String> _views = ['All', 'To Collect', 'To Pay'];

  static const _purpleColor = Color(0xFF8B5CF6);
  static const _blueColor = Color(0xFF3B82F6);

  // ✅ Aryan's outstanding balances only
  late final List<Map<String, dynamic>> _outstandingList = [
    {
      'id': 'LN-ARY-001',
      'party': 'Rohan Mehta', // ✅ Rohan owes Aryan
      'category': 'ToCollect',
      'type': 'Personal',
      'principal': 25000,
      'outstanding': 20600,
      'interest': 0.0,
      'overdueDays': 0,
      'nextDue': '10 Apr 2024',
      'risk': 'Low Risk',
      'riskColor': const Color(0xFF10B981),
      'avatar': 'A',
      'avatarColor': _purpleColor,
      'phone': '+91 98765 11111',
      'lastPayment': '10 Mar 2024',
      'note': 'Rohan needs to pay Aryan',
    },
    {
      'id': 'LN-ARY-002',
      'party': 'HDFC Bank', // ✅ Aryan owes HDFC
      'category': 'ToPay',
      'type': 'Home Loan',
      'principal': 1500000,
      'outstanding': 1456500,
      'interest': 8.5,
      'overdueDays': 0,
      'nextDue': '15 Apr 2024',
      'risk': 'Low Risk',
      'riskColor': const Color(0xFF10B981),
      'avatar': 'A',
      'avatarColor': _blueColor,
      'phone': '1800-XXX-XXXX',
      'lastPayment': '15 Mar 2024',
      'note': 'Aryan needs to pay HDFC',
    },
    {
      'id': 'LN-ARY-004',
      'party': 'Vijay Finance', // ✅ Aryan owes Vijay Finance - overdue
      'category': 'ToPay',
      'type': 'Vehicle Loan',
      'principal': 120000,
      'outstanding': 120000,
      'interest': 12.0,
      'overdueDays': 15,
      'nextDue': '20 Mar 2024',
      'risk': 'High Risk',
      'riskColor': const Color(0xFFEF4444),
      'avatar': 'A',
      'avatarColor': _purpleColor,
      'phone': '+91 77777 22222',
      'lastPayment': 'Never',
      'note': 'OVERDUE - Aryan must pay immediately',
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedView == 'All') return _outstandingList;
    if (_selectedView == 'To Collect') {
      return _outstandingList
          .where((l) => l['category'] == 'ToCollect')
          .toList();
    }
    return _outstandingList.where((l) => l['category'] == 'ToPay').toList();
  }

  int get _totalToCollect => _outstandingList
      .where((l) => l['category'] == 'ToCollect')
      .fold(0, (s, l) => s + (l['outstanding'] as int));

  int get _totalToPay => _outstandingList
      .where((l) => l['category'] == 'ToPay')
      .fold(0, (s, l) => s + (l['outstanding'] as int));

  int get _overdueCount =>
      _outstandingList.where((l) => (l['overdueDays'] as int) > 0).length;

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
          'My Outstanding Balance',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF6B7280),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Overdue Alert for Aryan
          if (_overdueCount > 0)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFFEF4444),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'You have overdue payment(s)! Pay immediately to avoid penalties.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                    child: const Text(
                      'Pay Now',
                      style: TextStyle(
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ✅ Aryan's Balance Summary Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
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
                          color: Color(0xFFEF4444),
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
                            'Outstanding Balance Overview',
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

                // To Collect vs To Pay
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.arrow_downward_rounded,
                            color: Colors.greenAccent,
                            size: 18,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${_formatAmount(_totalToCollect)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'To Collect',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.orangeAccent,
                            size: 18,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${_formatAmount(_totalToPay)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'To Pay',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.yellowAccent,
                            size: 18,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_overdueCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Overdue',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // View Filter Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: _views.map((view) {
                final isSelected = _selectedView == view;
                Color viewColor;
                switch (view) {
                  case 'To Collect':
                    viewColor = const Color(0xFF10B981);
                    break;
                  case 'To Pay':
                    viewColor = const Color(0xFFEF4444);
                    break;
                  default:
                    viewColor = const Color(0xFF8B5CF6);
                }
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedView = view),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? viewColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          view,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF6B7280),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // Outstanding Cards
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 60,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No outstanding balance here',
                          style: TextStyle(color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filtered.length,
                    itemBuilder: (context, index) {
                      return _buildOutstandingCard(_filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutstandingCard(Map<String, dynamic> loan) {
    final isOverdue = (loan['overdueDays'] as int) > 0;
    final riskColor = loan['riskColor'] as Color;
    final isToCollect = loan['category'] == 'ToCollect';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isOverdue
            ? Border.all(
                color: const Color(0xFFEF4444).withValues(alpha: 0.4),
              )
            : null,
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
          // Direction Badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: isToCollect
                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                  : const Color(0xFFEF4444).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isToCollect
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  size: 13,
                  color: isToCollect
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
                const SizedBox(width: 6),
                Text(
                  isToCollect
                      ? '${loan['party']} owes Aryan'
                      : 'Aryan owes ${loan['party']}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isToCollect
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              CircleAvatar(
                backgroundColor: loan['avatarColor'] as Color,
                radius: 22,
                child: Text(
                  loan['avatar'] as String,
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
                      loan['party'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          loan['type'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: riskColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            loan['risk'] as String,
                            style: TextStyle(
                              fontSize: 10,
                              color: riskColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${_formatAmount(loan['outstanding'] as int)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isToCollect
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
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

          // Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailItem(
                  'Principal',
                  '₹${_formatAmount(loan['principal'] as int)}',
                ),
                _buildDetailItem(
                  'Rate',
                  '${loan['interest']}% p.a.',
                ),
                _buildDetailItem(
                  isOverdue ? 'Overdue By' : 'Next Due',
                  isOverdue
                      ? '${loan['overdueDays']} days'
                      : loan['nextDue'] as String,
                  valueColor: isOverdue ? const Color(0xFFEF4444) : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Action Row
          Row(
            children: [
              const Icon(
                Icons.history_rounded,
                size: 12,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Text(
                'Last: ${loan['lastPayment']}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const Spacer(),
              // Phone Quick Action
              _buildQuickActionButton(
                Icons.phone_outlined,
                const Color(0xFF10B981),
              ),
              const SizedBox(width: 8),
              // Message Quick Action
              _buildQuickActionButton(
                Icons.message_outlined,
                const Color(0xFF3B82F6),
              ),
              const SizedBox(width: 8),
              // Main Action Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: isToCollect
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isToCollect ? 'Remind' : 'Pay Now',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(IconData icon, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF9CA3AF),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  String _formatAmount(int amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toString();
  }
}
