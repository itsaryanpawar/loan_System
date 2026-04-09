import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Unread', 'EMI', 'Alerts', 'System'];

  // ✅ Sample notifications for Aryan
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'EMI',
      'title': 'EMI Due Reminder',
      'message':
          'Your Home Loan EMI of ₹14,500 is due on 15 Apr 2024. Please ensure sufficient balance.',
      'time': '2 min ago',
      'isRead': false,
      'icon': Icons.home_rounded,
      'color': const Color(0xFF3B82F6),
      'loanId': 'LN-ARY-002',
      'actionLabel': 'Pay Now',
    },
    {
      'id': '2',
      'type': 'Alert',
      'title': '⚠️ Overdue Payment Alert',
      'message':
          'Your Vehicle Loan (LN-ARY-004) is overdue by 15 days. Pay ₹6,500 immediately to avoid penalty charges.',
      'time': '1 hour ago',
      'isRead': false,
      'icon': Icons.warning_amber_rounded,
      'color': const Color(0xFFEF4444),
      'loanId': 'LN-ARY-004',
      'actionLabel': 'Pay Now',
    },
    {
      'id': '3',
      'type': 'EMI',
      'title': 'EMI Collection Reminder',
      'message':
          'Rohan Mehta has an EMI of ₹2,200 due on 10 Apr 2024 for Personal Loan (LN-ARY-001).',
      'time': '3 hours ago',
      'isRead': false,
      'icon': Icons.person_rounded,
      'color': const Color(0xFF8B5CF6),
      'loanId': 'LN-ARY-001',
      'actionLabel': 'Send Reminder',
    },
    {
      'id': '4',
      'type': 'System',
      'title': 'Profile Updated',
      'message': 'Your profile information has been successfully updated.',
      'time': 'Yesterday',
      'isRead': true,
      'icon': Icons.check_circle_rounded,
      'color': const Color(0xFF10B981),
      'loanId': null,
      'actionLabel': null,
    },
    {
      'id': '5',
      'type': 'EMI',
      'title': 'EMI Paid Successfully',
      'message':
          'Home Loan EMI of ₹14,500 for March 2024 has been recorded successfully.',
      'time': '2 days ago',
      'isRead': true,
      'icon': Icons.check_circle_outline_rounded,
      'color': const Color(0xFF10B981),
      'loanId': 'LN-ARY-002',
      'actionLabel': 'View Details',
    },
    {
      'id': '6',
      'type': 'Alert',
      'title': 'Loan Portfolio Summary',
      'message':
          'Your monthly portfolio summary: 4 loans active, ₹15.77L outstanding balance, 1 overdue payment.',
      'time': '3 days ago',
      'isRead': true,
      'icon': Icons.bar_chart_rounded,
      'color': const Color(0xFFF59E0B),
      'loanId': null,
      'actionLabel': 'View Portfolio',
    },
    {
      'id': '7',
      'type': 'System',
      'title': 'Welcome to Madad! 🎉',
      'message':
          'Your account has been set up successfully. Start managing your loans with ease.',
      'time': '1 week ago',
      'isRead': true,
      'icon': Icons.celebration_rounded,
      'color': const Color(0xFF8B5CF6),
      'loanId': null,
      'actionLabel': null,
    },
  ];

  List<Map<String, dynamic>> get _filteredNotifications {
    if (_selectedFilter == 'All') return _notifications;
    if (_selectedFilter == 'Unread') {
      return _notifications.where((n) => !(n['isRead'] as bool)).toList();
    }
    return _notifications.where((n) => n['type'] == _selectedFilter).toList();
  }

  int get _unreadCount =>
      _notifications.where((n) => !(n['isRead'] as bool)).length;

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.done_all_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text(
              'All notifications marked as read',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _markAsRead(String id) {
    setState(() {
      final notif = _notifications.firstWhere((n) => n['id'] == id);
      notif['isRead'] = true;
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == id);
    });
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Clear All Notifications?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: const Text(
          'This will permanently delete all notifications.',
          style: TextStyle(color: Color(0xFF6B7280)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() => _notifications.clear());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6FA),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // ✅ Sheet Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFD1D5DB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ✅ Header
          _buildHeader(),

          // ✅ Filter Chips
          _buildFilterChips(),

          const SizedBox(height: 8),

          // ✅ Notification List or Empty State
          Expanded(
            child: _filteredNotifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        children: [
          Row(
            children: [
              // Bell Icon with Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_rounded,
                      color: Color(0xFF8B5CF6),
                      size: 24,
                    ),
                  ),
                  if (_unreadCount > 0)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$_unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      _unreadCount > 0
                          ? '$_unreadCount unread notification${_unreadCount > 1 ? 's' : ''}'
                          : 'All caught up!',
                      style: TextStyle(
                        fontSize: 12,
                        color: _unreadCount > 0
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF10B981),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Action Buttons
              if (_notifications.isNotEmpty) ...[
                if (_unreadCount > 0)
                  GestureDetector(
                    onTap: _markAllAsRead,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Read All',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _clearAll,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFEF4444),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),

          // ✅ Summary Bar (only when notifications exist)
          if (_notifications.isNotEmpty) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    '${_notifications.length}',
                    'Total',
                    Icons.notifications_outlined,
                  ),
                  _buildSummaryDivider(),
                  _buildSummaryItem(
                    '$_unreadCount',
                    'Unread',
                    Icons.mark_email_unread_outlined,
                  ),
                  _buildSummaryDivider(),
                  _buildSummaryItem(
                    '${_notifications.where((n) => n['type'] == 'Alert').length}',
                    'Alerts',
                    Icons.warning_amber_outlined,
                  ),
                  _buildSummaryDivider(),
                  _buildSummaryItem(
                    '${_notifications.where((n) => n['type'] == 'EMI').length}',
                    'EMI',
                    Icons.receipt_long_outlined,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildSummaryDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          // Count badge for each filter
          int count = 0;
          if (filter == 'All') {
            count = _notifications.length;
          } else if (filter == 'Unread') {
            count = _notifications.where((n) => !(n['isRead'] as bool)).length;
          } else {
            count = _notifications.where((n) => n['type'] == filter).length;
          }

          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF8B5CF6) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFFE5E7EB),
                ),
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color:
                          isSelected ? Colors.white : const Color(0xFF6B7280),
                    ),
                  ),
                  if (count > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.3)
                            : const Color(0xFF8B5CF6).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF8B5CF6),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationList() {
    // Group notifications by read status
    final unread =
        _filteredNotifications.where((n) => !(n['isRead'] as bool)).toList();
    final read =
        _filteredNotifications.where((n) => n['isRead'] as bool).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        // Unread Section
        if (unread.isNotEmpty) ...[
          _buildGroupLabel('New', unread.length),
          const SizedBox(height: 8),
          ...unread.map((n) => _buildNotificationCard(n)),
          const SizedBox(height: 16),
        ],

        // Read Section
        if (read.isNotEmpty) ...[
          _buildGroupLabel('Earlier', read.length),
          const SizedBox(height: 8),
          ...read.map((n) => _buildNotificationCard(n)),
        ],
      ],
    );
  }

  Widget _buildGroupLabel(String label, int count) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9CA3AF),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8B5CF6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif) {
    final isRead = notif['isRead'] as bool;
    final color = notif['color'] as Color;
    final hasAction = notif['actionLabel'] != null;

    return Dismissible(
      key: Key(notif['id'] as String),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_rounded, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => _deleteNotification(notif['id'] as String),
      child: GestureDetector(
        onTap: () => _markAsRead(notif['id'] as String),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: isRead
                ? Colors.white
                : const Color(0xFF8B5CF6).withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(16),
            border: isRead
                ? null
                : Border.all(
                    color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Icon
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        notif['icon'] as IconData,
                        color: color,
                        size: 22,
                      ),
                    ),
                    // Unread Dot
                    if (!isRead)
                      Positioned(
                        top: -3,
                        right: -3,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),

                // ✅ Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Time Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notif['title'] as String,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    isRead ? FontWeight.w500 : FontWeight.w700,
                                color: const Color(0xFF1F2937),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            notif['time'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Message
                      Text(
                        notif['message'] as String,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Loan ID Tag + Action Button
                      if (notif['loanId'] != null || hasAction) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // Loan ID Tag
                            if (notif['loanId'] != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  notif['loanId'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  ),
                                ),
                              ),
                            const Spacer(),

                            // Action Button
                            if (hasAction)
                              GestureDetector(
                                onTap: () {
                                  _markAsRead(notif['id'] as String);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    notif['actionLabel'] as String,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Beautiful Empty State
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Bell Icon
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.notifications_off_outlined,
                        size: 36,
                        color: Color(0xFF8B5CF6),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _selectedFilter == 'All'
                  ? "You're all caught up! 🎉\nNo notifications at the moment."
                  : "No $_selectedFilter notifications found.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // Tips Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 16,
                        color: Color(0xFFF59E0B),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'You will be notified about',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTipRow(
                    Icons.receipt_long_rounded,
                    const Color(0xFF3B82F6),
                    'Upcoming EMI due dates',
                  ),
                  _buildTipRow(
                    Icons.warning_amber_rounded,
                    const Color(0xFFEF4444),
                    'Overdue payment alerts',
                  ),
                  _buildTipRow(
                    Icons.people_rounded,
                    const Color(0xFF8B5CF6),
                    'Borrower payment reminders',
                  ),
                  _buildTipRow(
                    Icons.bar_chart_rounded,
                    const Color(0xFF10B981),
                    'Monthly portfolio summaries',
                  ),
                ],
              ),
            ),

            // Show All button (when filter is active)
            if (_selectedFilter != 'All') ...[
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: () => setState(() => _selectedFilter = 'All'),
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: Color(0xFF8B5CF6),
                ),
                label: const Text(
                  'Show All Notifications',
                  style: TextStyle(
                    color: Color(0xFF8B5CF6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTipRow(IconData icon, Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 13, color: color),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
