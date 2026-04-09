import 'package:flutter/material.dart';

class TotalLoansScreen extends StatefulWidget {
  const TotalLoansScreen({Key? key}) : super(key: key);

  @override
  State<TotalLoansScreen> createState() => _TotalLoansScreenState();
}

class _TotalLoansScreenState extends State<TotalLoansScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Personal',
    'Business',
    'Home',
    'Vehicle',
  ];

  // ✅ Aryan's data only
  static const _purpleColor = Color(0xFF8B5CF6);
  static const _blueColor = Color(0xFF3B82F6);

  late final List<Map<String, dynamic>> _loans = [
    {
      'id': 'LN-ARY-001',
      'borrower': 'Aryan Pawar', // ✅ Aryan's loan (Money Lent)
      'loanTo': 'Rohan Mehta',
      'type': 'Personal',
      'category': 'Lent',
      'amount': 25000,
      'date': '10 Feb 2024',
      'status': 'Active',
      'avatar': 'A',
      'avatarColor': _purpleColor,
      'emi': 2200,
      'tenure': '12 months',
      'paid': 2,
      'total': 12,
      'note': 'Lent to Rohan for medical expenses',
    },
    {
      'id': 'LN-ARY-002',
      'borrower': 'Aryan Pawar', // ✅ Aryan's loan (Money Borrowed)
      'loanTo': 'HDFC Bank',
      'type': 'Home',
      'category': 'Borrowed',
      'amount': 1500000,
      'date': '15 Jan 2024',
      'status': 'Active',
      'avatar': 'A',
      'avatarColor': _blueColor,
      'emi': 14500,
      'tenure': '120 months',
      'paid': 3,
      'total': 120,
      'note': 'Home loan from HDFC Bank',
    },
    {
      'id': 'LN-ARY-003',
      'borrower': 'Aryan Pawar', // ✅ Aryan's loan (Money Lent)
      'loanTo': 'Sneha Kulkarni',
      'type': 'Personal',
      'category': 'Lent',
      'amount': 10000,
      'date': '05 Dec 2023',
      'status': 'Closed',
      'avatar': 'A',
      'avatarColor': _purpleColor,
      'emi': 5000,
      'tenure': '2 months',
      'paid': 2,
      'total': 2,
      'note': 'Lent to Sneha - fully recovered',
    },
    {
      'id': 'LN-ARY-004',
      'borrower': 'Aryan Pawar', // ✅ Aryan's loan (Money Borrowed)
      'loanTo': 'Vijay Finance',
      'type': 'Vehicle',
      'category': 'Borrowed',
      'amount': 120000,
      'date': '20 Mar 2024',
      'status': 'Overdue',
      'avatar': 'A',
      'avatarColor': _purpleColor,
      'emi': 6500,
      'tenure': '24 months',
      'paid': 0,
      'total': 24,
      'note': 'Bike loan - EMI overdue',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredLoans {
    if (_selectedFilter == 'All') return _loans;
    return _loans.where((l) => l['type'] == _selectedFilter).toList();
  }

  List<Map<String, dynamic>> get _lentLoans =>
      _filteredLoans.where((l) => l['category'] == 'Lent').toList();

  List<Map<String, dynamic>> get _borrowedLoans =>
      _filteredLoans.where((l) => l['category'] == 'Borrowed').toList();

  @override
  Widget build(BuildContext context) {
    final activeCount = _loans.where((l) => l['status'] == 'Active').length;
    final closedCount = _loans.where((l) => l['status'] == 'Closed').length;
    final overdueCount = _loans.where((l) => l['status'] == 'Overdue').length;

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
          'My Total Loans',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: Color(0xFF6B7280)),
            onPressed: () {},
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF8B5CF6),
          unselectedLabelColor: const Color(0xFF6B7280),
          indicatorColor: const Color(0xFF8B5CF6),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Money Lent'),
            Tab(text: 'Borrowed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ✅ Aryan's Profile Header
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
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
                      radius: 24,
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B5CF6),
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'My Loan Portfolio',
                            style: TextStyle(
                              fontSize: 13,
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
                // Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildSummaryItem(
                      'Total',
                      '${_loans.length}',
                      Icons.receipt_long_rounded,
                    ),
                    _buildDivider(),
                    _buildSummaryItem(
                      'Active',
                      '$activeCount',
                      Icons.trending_up_rounded,
                    ),
                    _buildDivider(),
                    _buildSummaryItem(
                      'Closed',
                      '$closedCount',
                      Icons.check_circle_outline,
                    ),
                    _buildDivider(),
                    _buildSummaryItem(
                      'Overdue',
                      '$overdueCount',
                      Icons.warning_amber_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFF8B5CF6) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color:
                            isSelected ? Colors.white : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Tabs Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoanList(_filteredLoans),
                _buildLoanList(_lentLoans),
                _buildLoanList(_borrowedLoans),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanList(List<Map<String, dynamic>> loans) {
    if (loans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 60,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            const Text(
              'No loans found',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: loans.length,
      itemBuilder: (context, index) => _buildLoanCard(loans[index]),
    );
  }

  Widget _buildLoanCard(Map<String, dynamic> loan) {
    Color statusColor;
    IconData statusIcon;
    final isLent = loan['category'] == 'Lent';

    switch (loan['status']) {
      case 'Active':
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.trending_up_rounded;
        break;
      case 'Closed':
        statusColor = const Color(0xFF6B7280);
        statusIcon = Icons.check_circle_outline;
        break;
      case 'Overdue':
        statusColor = const Color(0xFFEF4444);
        statusIcon = Icons.warning_amber_rounded;
        break;
      default:
        statusColor = const Color(0xFF8B5CF6);
        statusIcon = Icons.info_outline;
    }

    final progress = (loan['paid'] as int) / (loan['total'] as int);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Badge
          Row(
            children: [
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
              const Spacer(),
              Text(
                loan['id'] as String,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main Info Row
          Row(
            children: [
              CircleAvatar(
                backgroundColor: loan['avatarColor'] as Color,
                radius: 20,
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
                          ? 'Lent to ${loan['loanTo']}'
                          : 'Borrowed from ${loan['loanTo']}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      '${loan['type']} • ${loan['date']}',
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
                    '₹${_formatAmount(loan['amount'] as int)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 10, color: statusColor),
                        const SizedBox(width: 3),
                        Text(
                          loan['status'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Note
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.notes_rounded,
                  size: 14,
                  color: Color(0xFF9CA3AF),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    loan['note'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${loan['paid']}/${loan['total']} EMIs paid',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  Text(
                    'EMI: ₹${loan['emi']}',
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
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  minHeight: 6,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'View Details →',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
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

  Widget _buildDivider() {
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
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.toString();
  }
}
