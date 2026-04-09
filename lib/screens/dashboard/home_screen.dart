import 'package:flutter/material.dart';
import '../eligibility/emi_calculator_screen.dart';
import '../loan/loan_type_screen.dart';
import '../loan/total_loans_screen.dart';
import '../loan/active_loans_screen.dart';
import '../loan/disbursed_amount_screen.dart';
import '../loan/outstanding_balance_screen.dart';
import '../user/profile_settings_screen.dart';
import '../communication/chat_document_screen.dart';
import '../communication/notification_screen.dart';
import '../../models/loan_application.dart';
import '../contacts/contacts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  int _currentIndex = 0;

  // ✅ Notification unread count (can be updated dynamically)
  int _unreadNotifications = 3;

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.dashboard_rounded, 'label': 'Dashboard'},
    {'icon': Icons.move_to_inbox, 'label': 'Incoming'},
    {'icon': Icons.add, 'label': 'Add'},
    {'icon': Icons.people_alt, 'label': 'Contacts'},
    {'icon': Icons.money, 'label': 'Loans'},
  ];

  // ✅ Navigate to Loan Type
  void _navigateToLoanType() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoanTypeScreen(
          application: LoanApplication(),
        ),
      ),
    );
  }

  // ✅ Open Profile Bottom Sheet
  void _openProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.95,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: const ProfileSettingsScreen(),
        ),
      ),
    );
  }

  // ✅ Open Notification Bottom Sheet
  void _openNotificationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => const NotificationScreen(),
    ).then((_) {
      // ✅ Reset badge count after viewing
      setState(() => _unreadNotifications = 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // ✅ Greeting Section
            _buildGreetingSection(),
            const SizedBox(height: 24),

            // ✅ EMI Calculator Card
            _buildEmiCalculatorCard(),
            const SizedBox(height: 24),

            // ✅ Toggle: Money Lent / Money Borrowed
            _buildToggleSection(),
            const SizedBox(height: 24),

            // ✅ Stats Cards
            _buildStatsSection(),
            const SizedBox(height: 24),

            // ✅ Quick Actions
            _buildQuickActionsSection(),
            const SizedBox(height: 24),

            // ✅ Recent Activity
            _buildRecentActivitySection(),
            const SizedBox(height: 24),

            // ✅ Empty / No Loans State
            _buildEmptyStateSection(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ✅ APP BAR
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Center(
          child: Text(
            'Madad - मदद',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
        ),
      ),
      leadingWidth: 180,
      actions: [
        // ✅ Notification Bell with Red Badge
        GestureDetector(
          onTap: _openNotificationSheet,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFF6B7280),
                  size: 22,
                ),
              ),
              // Red badge
              if (_unreadNotifications > 0)
                Positioned(
                  top: 6,
                  right: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _unreadNotifications > 9
                            ? '9+'
                            : '$_unreadNotifications',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 4),

        // ✅ Profile Avatar
        GestureDetector(
          onTap: _openProfileSheet,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: const CircleAvatar(
              backgroundColor: Color(0xFF8B5CF6),
              radius: 18,
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // ✅ Menu / Admin
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Admin login coming soon'),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 8,
            ),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.menu_rounded,
              color: Color(0xFF6B7280),
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ✅ GREETING SECTION
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _buildGreetingSection() {
    final hour = DateTime.now().hour;
    String greeting;
    String emoji;

    if (hour < 12) {
      greeting = 'Good Morning';
      emoji = '☀️';
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      emoji = '🌤️';
    } else {
      greeting = 'Good Evening';
      emoji = '🌙';
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, Aryan $emoji',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Overview of your loan portfolio',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        // ✅ Date Chip
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Text(
                '${DateTime.now().day}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B5CF6),
                ),
              ),
              Text(
                _getMonthName(DateTime.now().month),
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ✅ EMI CALCULATOR CARD
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _buildEmiCalculatorCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EMICalculatorScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.calculate_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EMI Calculator',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Plan your loan repayments easily',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ✅ TOGGLE SECTION
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _buildToggleSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildToggleButton('💸 Money Lent', 0)),
          Expanded(child: _buildToggleButton('💰 Money Borrowed', 1)),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String title, int index) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8B5CF6) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ✅ STATS SECTION
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _buildStatsSection() {
    return Column(
      children: [
        // ✅ Top two cards in a row
        Row(
          children: [
            Expanded(
              child: _buildStatCardSmall(
                title: 'Total Loans',
                value: '4',
                icon: Icons.receipt_long_rounded,
                color: const Color(0xFF8B5CF6),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TotalLoansScreen(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCardSmall(
                title: 'Active Loans',
                value: '3',
                icon: Icons.trending_up_rounded,
                color: const Color(0xFF10B981),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActiveLoansScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ✅ Full width stat cards
        _buildStatCardFull(
          title: 'Disbursed Amount',
          value: '₹17.55L',
          subtitle: '4 transactions',
          icon: Icons.account_balance_wallet_rounded,
          color: const Color(0xFF3B82F6),
          accentColor: const Color(0xFF3B82F6).withValues(alpha: 0.1),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DisbursedAmountScreen(),
            ),
          ),
        ),
        const SizedBox(height: 12),

        _buildStatCardFull(
          title: 'Outstanding Balance',
          value: '₹15.77L',
          subtitle: '1 overdue payment ⚠️',
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFEF4444),
          accentColor: const Color(0xFFEF4444).withValues(alpha: 0.1),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const OutstandingBalanceScreen(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardSmall({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color,
                  size: 14,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCardFull({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: color,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ✅ QUICK ACTIONS SECTION
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _buildQuickActionsSection() {
    final List<Map<String, dynamic>> actions = [
      {
        'icon': Icons.add_circle_rounded,
        'label': 'New Loan',
        'color': const Color(0xFF8B5CF6),
        'bgColor': const Color(0xFF8B5CF6).withValues(alpha: 0.1),
        'onTap': _navigateToLoanType,
      },
      {
        'icon': Icons.calculate_outlined,
        'label': 'EMI Calc',
        'color': const Color(0xFF3B82F6),
        'bgColor': const Color(0xFF3B82F6).withValues(alpha: 0.1),
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EMICalculatorScreen(),
              ),
            ),
      },
      {
        'icon': Icons.chat_bubble_outline_rounded,
        'label': 'Support',
        'color': const Color(0xFF10B981),
        'bgColor': const Color(0xFF10B981).withValues(alpha: 0.1),
        'onTap': () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatDocumentScreen(),
              ),
            ),
      },
      {
        'icon': Icons.notifications_outlined,
        'label': 'Alerts',
        'color': const Color(0xFFF59E0B),
        'bgColor': const Color(0xFFF59E0B).withValues(alpha: 0.1),
        'onTap': _openNotificationSheet,
      },
      {
        'icon': Icons.person_outline_rounded,
        'label': 'Profile',
        'color': const Color(0xFF6366F1),
        'bgColor': const Color(0xFF6366F1).withValues(alpha: 0.1),
        'onTap': _openProfileSheet,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '5 actions',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((action) {
            final color = action['color'] as Color;
            final bgColor = action['bgColor'] as Color;
            return GestureDetector(
              onTap: action['onTap'] as VoidCallback,
              child: Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: color.withValues(alpha: 0.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      color: color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    action['label'] as String,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ✅ RECENT ACTIVITY SECTION
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _buildRecentActivitySection() {
    final activities = [
      {
        'title': 'Home Loan EMI Due',
        'subtitle': 'LN-ARY-002 • ₹14,500 due on 15 Apr',
        'icon': Icons.home_rounded,
        'color': const Color(0xFF3B82F6),
        'time': '2 min ago',
        'type': 'Due',
      },
      {
        'title': 'Vehicle Loan Overdue',
        'subtitle': 'LN-ARY-004 • ₹6,500 overdue by 15 days',
        'icon': Icons.two_wheeler_rounded,
        'color': const Color(0xFFEF4444),
        'time': '1 hr ago',
        'type': 'Overdue',
      },
      {
        'title': 'Rohan Mehta EMI',
        'subtitle': 'LN-ARY-001 • ₹2,200 due on 10 Apr',
        'icon': Icons.person_rounded,
        'color': const Color(0xFF8B5CF6),
        'time': '3 hrs ago',
        'type': 'Collect',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: _openNotificationSheet,
              child: const Text(
                'See All →',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
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
            children: List.generate(activities.length, (index) {
              final activity = activities[index];
              final color = activity['color'] as Color;
              final isLast = index == activities.length - 1;

              String typeLabel = activity['type'] as String;
              Color typeColor;
              switch (typeLabel) {
                case 'Overdue':
                  typeColor = const Color(0xFFEF4444);
                  break;
                case 'Due':
                  typeColor = const Color(0xFFF59E0B);
                  break;
                default:
                  typeColor = const Color(0xFF8B5CF6);
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            activity['icon'] as IconData,
                            color: color,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Title + Subtitle
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity['title'] as String,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                activity['subtitle'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Side
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: typeColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                typeLabel,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: typeColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activity['time'] as String,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      indent: 68,
                      color: Color(0xFFF3F4F6),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // ✅ EMPTY STATE SECTION
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _buildEmptyStateSection() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                  const Color(0xFF6366F1).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add_card_rounded,
              size: 40,
              color: Color(0xFF8B5CF6),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Create Your First Loan',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Track money you lend or borrow.\nStay on top of every repayment.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Loan Type Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLoanTypeChip('Personal', Icons.person_rounded),
              const SizedBox(width: 8),
              _buildLoanTypeChip('Home', Icons.home_rounded),
              const SizedBox(width: 8),
              _buildLoanTypeChip('Vehicle', Icons.two_wheeler_rounded),
            ],
          ),
          const SizedBox(height: 20),

          // CTA Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _navigateToLoanType,
              icon: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 20,
              ),
              label: const Text(
                'Create Loan',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoanTypeChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF8B5CF6)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF8B5CF6),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ✅ BOTTOM NAVIGATION BAR
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          final isCenter = index == 2;
          final isActive = _currentIndex == index;

          // ✅ Center FAB Button → New Loan
          if (isCenter) {
            return GestureDetector(
              onTap: () {
                setState(() => _currentIndex = index);
                _navigateToLoanType();
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            );
          }

          // ✅ Regular Nav Items with proper navigation
          return GestureDetector(
            onTap: () {
              setState(() => _currentIndex = index);

              switch (index) {
                // Dashboard (index 0) → Stay on HomeScreen
                case 0:
                  break;

                // Incoming (index 1) → Coming Soon
                case 1:
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(
                            Icons.move_to_inbox,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Incoming screen coming soon!',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      backgroundColor: const Color(0xFF6B7280),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.all(16),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  break;

                // Contacts (index 3) → ContactsScreen
                case 3:
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const ContactsScreen(),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        final tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: Curves.easeInOut));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  ).then((_) {
                    // ✅ Reset to Dashboard when returning from Contacts
                    setState(() => _currentIndex = 0);
                  });
                  break;

                // Loans (index 4) → LoanTypeScreen
                case 4:
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          LoanTypeScreen(
                        application: LoanApplication(),
                      ),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        final tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: Curves.easeInOut));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300),
                    ),
                  ).then((_) {
                    // ✅ Reset to Dashboard when returning
                    setState(() => _currentIndex = 0);
                  });
                  break;
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF8B5CF6).withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ✅ Icon with active indicator dot
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        item['icon'] as IconData,
                        color: isActive
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFF9CA3AF),
                        size: 24,
                      ),
                      // ✅ Active dot indicator
                      if (isActive)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B5CF6),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive
                          ? const Color(0xFF8B5CF6)
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
