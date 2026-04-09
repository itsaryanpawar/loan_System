// lib/screens/dashboard/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
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

    if (!mounted) return; // ✅ Fix: use_build_context_synchronously

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
                // ✅ Fix: use_build_context_synchronously (line 309)
                // Use onTap with mounted check correctly —
                // PopupMenuItem.onTap runs after the menu closes,
                // so we schedule via addPostFrameCallback to be safe
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return; // ✅ correct mounted guard
                    _showClearDataDialog();
                  });
                },
                child: const Text('Clear All Data'),
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
                            padding: const EdgeInsets.all(40),
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
        ),
      ),
      child: ExpansionTile(
        title: Text(app.name ?? 'N/A'),
        subtitle: Text(app.loanType ?? 'N/A'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow(
                  Icons.phone,
                  'Phone',
                  app.phoneNumber ?? 'N/A',
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
        Icon(icon, size: 18),
        const SizedBox(width: 12),
        Text('$label: $value'),
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
        content: const Text('This will delete all applications'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _apiService.clearAllApplications();

              // ✅ Fix: use dialogContext (not context) after await
              // dialogContext does not need mounted check —
              // it belongs to the dialog's own BuildContext
              if (!mounted) return;

              // ✅ Use dialogContext to pop the dialog safely
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }

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
