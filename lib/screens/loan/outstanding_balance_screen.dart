// lib/screens/loan/outstanding_balance_screen.dart
import 'package:flutter/material.dart';

class OutstandingBalanceScreen extends StatefulWidget {
  // ✅ Accept userName from HomeScreen
  final String userName;

  const OutstandingBalanceScreen({
    Key? key,
    this.userName = '',
  }) : super(key: key);

  @override
  State<OutstandingBalanceScreen> createState() =>
      _OutstandingBalanceScreenState();
}

class _OutstandingBalanceScreenState extends State<OutstandingBalanceScreen> {
  String _selectedView = 'All';
  final List<String> _views = ['All', 'To Collect', 'To Pay'];

  static const _purpleColor = Color(0xFF8B5CF6);
  static const _blueColor = Color(0xFF3B82F6);

  // ✅ Resolve full display name (handles email or full name)
  String get _displayName {
    final input = widget.userName.trim();
    if (input.isEmpty) return 'User';

    if (input.contains('@')) {
      final localPart = input.split('@').first;
      return localPart
          .split(RegExp(r'[._]'))
          .map(
            (w) => w.isNotEmpty
                ? w[0].toUpperCase() + w.substring(1).toLowerCase()
                : '',
          )
          .join(' ');
    }

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

  // ✅ Get first name only for inline badge text
  String get _firstName {
    final input = widget.userName.trim();
    if (input.isEmpty) return 'User';
    if (input.contains('@')) {
      final localPart = input.split('@').first;
      final firstPart = localPart.split(RegExp(r'[._]')).first;
      return firstPart.isNotEmpty
          ? firstPart[0].toUpperCase() + firstPart.substring(1).toLowerCase()
          : 'User';
    }
    final firstWord = input.split(' ').first;
    return firstWord[0].toUpperCase() + firstWord.substring(1);
  }

  late final List<Map<String, dynamic>> _outstandingList = [
    {
      'id': 'LN-ARY-001',
      'party': 'Rohan Mehta',
      'category': 'ToCollect',
      'type': 'Personal',
      'principal': 25000,
      'outstanding': 20600,
      'interest': 0.0,
      'overdueDays': 0,
      'nextDue': '10 Apr 2024',
      'risk': 'Low Risk',
      'riskColor': const Color(0xFF10B981),
      'avatar': 'R',
      'avatarColor': _purpleColor,
      'phone': '+91 98765 11111',
      'lastPayment': '10 Mar 2024',
      'note': 'Rohan needs to pay back the personal loan',
    },
    {
      'id': 'LN-ARY-002',
      'party': 'HDFC Bank',
      'category': 'ToPay',
      'type': 'Home Loan',
      'principal': 1500000,
      'outstanding': 1456500,
      'interest': 8.5,
      'overdueDays': 0,
      'nextDue': '15 Apr 2024',
      'risk': 'Low Risk',
      'riskColor': const Color(0xFF10B981),
      'avatar': 'H',
      'avatarColor': _blueColor,
      'phone': '1800-XXX-XXXX',
      'lastPayment': '15 Mar 2024',
      'note': 'Home loan EMI due this month',
    },
    {
      'id': 'LN-ARY-004',
      'party': 'Vijay Finance',
      'category': 'ToPay',
      'type': 'Vehicle Loan',
      'principal': 120000,
      'outstanding': 120000,
      'interest': 12.0,
      'overdueDays': 15,
      'nextDue': '20 Mar 2024',
      'risk': 'High Risk',
      'riskColor': const Color(0xFFEF4444),
      'avatar': 'V',
      'avatarColor': _purpleColor,
      'phone': '+91 77777 22222',
      'lastPayment': 'Never',
      'note': 'OVERDUE - Must pay immediately to avoid penalties',
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
          // ✅ Overdue Alert — Dynamic name
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
                  // ✅ Dynamic name in alert
                  Expanded(
                    child: Text(
                      '$_firstName, you have overdue payment(s)! Pay immediately to avoid penalties.',
                      style: const TextStyle(
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

          // ✅ Dynamic Balance Summary Banner
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
                // ✅ Dynamic Profile Row
                Row(
                  children: [
                    // ✅ Dynamic Avatar
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: Text(
                        _avatarLetter,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
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

                // ✅ Stats Row
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

          // ✅ View Filter Tabs
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

          // ✅ Outstanding Cards
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
                      return _buildOutstandingCard(
                        _filtered[index],
                      );
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
          // ✅ Direction Badge with dynamic first name
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
                // ✅ Dynamic first name in badge
                Text(
                  isToCollect
                      ? '${loan['party']} owes $_firstName'
                      : '$_firstName owes ${loan['party']}',
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
              // ✅ Avatar with first letter of party name
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

          // ✅ Details Row
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

          // ✅ Action Row
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
              _buildQuickActionButton(
                Icons.phone_outlined,
                const Color(0xFF10B981),
              ),
              const SizedBox(width: 8),
              _buildQuickActionButton(
                Icons.message_outlined,
                const Color(0xFF3B82F6),
              ),
              const SizedBox(width: 8),
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
