import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/loan_application.dart';
import '../../services/api_service.dart';
import '../../utils/constants.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final ApiService _apiService = ApiService();
  List<LoanApplication> _applications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    final applications = await _apiService.getAllApplications();

    // ✅ Fix 1: Check mounted after async gap
    if (!mounted) return;

    setState(() {
      _applications = applications;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final approvedCount =
        _applications.where((app) => app.isApproved == true).length;
    final pendingCount =
        _applications.where((app) => app.isApproved == false).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: _loadApplications,
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Clear All Data'),
                onTap: () async {
                  await Future.delayed(Duration.zero);
                  // ✅ Fix 2: Check mounted before using context
                  if (!mounted) return;
                  _showClearDataDialog();
                },
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadApplications,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Total Leads',
                              _applications.length.toString(),
                              Icons.people,
                              AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Approved',
                              approvedCount.toString(),
                              Icons.check_circle,
                              AppColors.success,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              'Under Review',
                              pendingCount.toString(),
                              Icons.hourglass_empty,
                              AppColors.warning,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              'Today',
                              _getTodayCount().toString(),
                              Icons.today,
                              AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'All Applications',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${_applications.length} total',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_applications.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 80,
                                  color: Colors.grey.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No applications yet',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _applications.length,
                          itemBuilder: (context, index) {
                            return _buildApplicationCard(
                              _applications[index],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicationCard(LoanApplication app) {
    final isApproved = app.isApproved ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isApproved
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isApproved ? AppColors.success : AppColors.warning)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            AppConstants.loanIcons[app.loanType],
            color: isApproved ? AppColors.success : AppColors.warning,
          ),
        ),
        title: Text(
          app.name ?? 'N/A',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          app.loanType ?? 'N/A',
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: (isApproved ? AppColors.success : AppColors.warning)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isApproved ? 'Approved' : 'Review',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isApproved ? AppColors.success : AppColors.warning,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildDetailRow(
                  Icons.phone,
                  'Phone',
                  app.phoneNumber ?? 'N/A',
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  Icons.location_city,
                  'City',
                  app.city ?? 'N/A',
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  Icons.currency_rupee,
                  'Monthly Income',
                  '₹${app.monthlyIncome ?? 'N/A'}',
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  Icons.work,
                  'Employment',
                  app.employmentType ?? 'N/A',
                ),
                const SizedBox(height: 12),
                _buildDetailRow(
                  Icons.calendar_today,
                  'Applied On',
                  app.createdAt != null
                      ? DateFormat('MMM dd, yyyy • hh:mm a')
                          .format(app.createdAt!)
                      : 'N/A',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int _getTodayCount() {
    final today = DateTime.now();
    return _applications.where((app) {
      if (app.createdAt == null) return false;
      return app.createdAt!.year == today.year &&
          app.createdAt!.month == today.month &&
          app.createdAt!.day == today.day;
    }).length;
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Data?'),
        content: const Text(
          'This will permanently delete all loan applications.',
        ),
        actions: [
          TextButton(
            // ✅ Fix 3: Use dialogContext instead of outer context
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _apiService.clearAllApplications();

              // ✅ Fix 4: Check mounted before using context after await
              if (!mounted) return;

              // ✅ Fix 5: Use dialogContext to pop dialog safely
              Navigator.pop(dialogContext);

              // ✅ Fix 6: Reload after dialog closes
              _loadApplications();
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
