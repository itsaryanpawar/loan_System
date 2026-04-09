// lib/screens/user/profile_settings_screen.dart
import 'package:flutter/material.dart';
import '../communication/chat_document_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  // ✅ Accept data passed from Login → HomeScreen → ProfileSettings
  final String userName;
  final String userEmail;

  const ProfileSettingsScreen({
    Key? key,
    this.userName = '',
    this.userEmail = '',
  }) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  String _selectedCurrency = '₹ Indian Rupee';
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = false;

  // ✅ User data — initialized from login in initState
  late String _fullName;
  late String _email;
  late String _avatarLetter;
  String _phone = '';
  String _city = '';

  final List<String> _currencies = [
    '₹ Indian Rupee',
    '\$ US Dollar',
    '€ Euro',
    '£ British Pound',
    '¥ Japanese Yen',
    'AED UAE Dirham',
    'SGD Singapore Dollar',
  ];

  @override
  void initState() {
    super.initState();
    // ✅ Auto-fill from login data
    _email = widget.userEmail.isNotEmpty ? widget.userEmail : '';
    _fullName = _resolveFullName();
    _avatarLetter = _resolveAvatarLetter();
  }

  // ✅ Resolve display name from userName (handles email or full name)
  String _resolveFullName() {
    final input = widget.userName.trim();
    if (input.isEmpty) return '';

    // If it's an email, extract local part before '@'
    if (input.contains('@')) {
      final localPart = input.split('@').first;
      // Capitalize each word split by dot/underscore
      return localPart
          .split(RegExp(r'[._]'))
          .map((w) => w.isNotEmpty
              ? w[0].toUpperCase() + w.substring(1).toLowerCase()
              : '')
          .join(' ');
    }

    // Otherwise return as-is (already a proper name)
    return input;
  }

  // ✅ Resolve avatar letter
  String _resolveAvatarLetter() {
    final input = widget.userName.trim();
    if (input.isEmpty) return 'U';

    if (input.contains('@')) {
      return input.split('@').first[0].toUpperCase();
    }
    return input[0].toUpperCase();
  }

  // ✅ Show Edit Profile Bottom Sheet
  void _showEditProfileSheet() {
    final nameController = TextEditingController(text: _fullName);
    final phoneController = TextEditingController(text: _phone);
    final emailController = TextEditingController(text: _email);
    final cityController = TextEditingController(text: _city);
    final formKey = GlobalKey<FormState>();
    String selectedAvatar = _avatarLetter;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(sheetContext),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE5E7EB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ✅ Scrollable Form Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Avatar Picker
                            Center(
                              child: Column(
                                children: [
                                  Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _showAvatarPicker(
                                            context,
                                            selectedAvatar,
                                            (letter) {
                                              setSheetState(() {
                                                selectedAvatar = letter;
                                              });
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF8B5CF6),
                                                Color(0xFF6366F1),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF8B5CF6)
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              selectedAvatar,
                                              style: const TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Tap to change avatar',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            // ✅ Login Data Pre-fill Notice
                            if (widget.userEmail.isNotEmpty ||
                                widget.userName.isNotEmpty)
                              Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.2),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 18,
                                      color: Color(0xFF10B981),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Fields are pre-filled from your login. You can update them anytime.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF10B981),
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            // ✅ Personal Information Section
                            _buildSheetSectionTitle('Personal Information'),
                            const SizedBox(height: 12),
                            _buildFormCard([
                              // Full Name
                              _buildFormField(
                                controller: nameController,
                                label: 'Full Name',
                                hint: 'Enter your full name',
                                icon: Icons.person_outline_rounded,
                                iconColor: const Color(0xFF8B5CF6),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Name cannot be empty';
                                  }
                                  if (val.trim().length < 2) {
                                    return 'Name too short';
                                  }
                                  return null;
                                },
                              ),
                              _buildFormDivider(),

                              // Phone
                              _buildFormField(
                                controller: phoneController,
                                label: 'Phone Number',
                                hint: '+91 XXXXX XXXXX',
                                icon: Icons.phone_outlined,
                                iconColor: const Color(0xFF10B981),
                                keyboardType: TextInputType.phone,
                                validator: (val) {
                                  if (val != null &&
                                      val.trim().isNotEmpty &&
                                      val.trim().length < 10) {
                                    return 'Enter a valid phone number';
                                  }
                                  return null;
                                },
                              ),
                              _buildFormDivider(),

                              // Email
                              _buildFormField(
                                controller: emailController,
                                label: 'Email Address',
                                hint: 'example@email.com',
                                icon: Icons.email_outlined,
                                iconColor: const Color(0xFF3B82F6),
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Email cannot be empty';
                                  }
                                  if (!val.contains('@') ||
                                      !val.contains('.')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              _buildFormDivider(),

                              // City
                              _buildFormField(
                                controller: cityController,
                                label: 'City',
                                hint: 'e.g. Mumbai, Maharashtra',
                                icon: Icons.location_on_outlined,
                                iconColor: const Color(0xFFEF4444),
                                validator: (val) {
                                  return null; // optional
                                },
                              ),
                            ]),
                            const SizedBox(height: 20),

                            // ✅ Info Note
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6)
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF3B82F6)
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 18,
                                    color: Color(0xFF3B82F6),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Your information is securely stored and will only be used for loan management purposes.',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF3B82F6),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 28),

                            // ✅ Save Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      _fullName = nameController.text.trim();
                                      _phone = phoneController.text.trim();
                                      _email = emailController.text.trim();
                                      _city = cityController.text.trim();
                                      _avatarLetter = selectedAvatar;
                                    });
                                    Navigator.pop(sheetContext);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Profile updated successfully!',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor:
                                            const Color(0xFF10B981),
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        margin: const EdgeInsets.all(16),
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.save_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B5CF6),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // ✅ Cancel Button
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(sheetContext),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ✅ Avatar Letter Picker Dialog
  void _showAvatarPicker(
    BuildContext context,
    String current,
    Function(String) onSelect,
  ) {
    final letters = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
    ];

    final colors = [
      const Color(0xFF8B5CF6),
      const Color(0xFF10B981),
      const Color(0xFF3B82F6),
      const Color(0xFFEF4444),
      const Color(0xFFF59E0B),
      const Color(0xFF6366F1),
    ];

    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Choose Avatar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select a letter for your avatar',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: letters.length,
                itemBuilder: (context, index) {
                  final letter = letters[index];
                  final isSelected = letter == current;
                  final color = colors[index % colors.length];

                  return GestureDetector(
                    onTap: () {
                      onSelect(letter);
                      Navigator.pop(dialogContext);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? color : color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: color, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          letter,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : color,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Form Field Builder
  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 14, color: iconColor),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFD1D5DB),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: iconColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFEF4444)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFEF4444),
                  width: 1.5,
                ),
              ),
              errorStyle: const TextStyle(
                fontSize: 11,
                color: Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Color(0xFF9CA3AF),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildFormCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildFormDivider() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Color(0xFFF3F4F6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          _buildProfileHeader(context),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Account Section
                  _buildSectionTitle('Account'),
                  const SizedBox(height: 8),
                  _buildSettingsCard([
                    _buildProfileInfoTile(
                      icon: Icons.person_outline_rounded,
                      label: 'Full Name',
                      value: _fullName.isNotEmpty ? _fullName : 'Not set',
                      iconColor: const Color(0xFF8B5CF6),
                    ),
                    _buildDivider(),
                    _buildProfileInfoTile(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: _phone.isNotEmpty ? _phone : 'Not set',
                      iconColor: const Color(0xFF10B981),
                    ),
                    _buildDivider(),
                    _buildProfileInfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: _email.isNotEmpty ? _email : 'Not set',
                      iconColor: const Color(0xFF3B82F6),
                    ),
                    _buildDivider(),
                    _buildProfileInfoTile(
                      icon: Icons.location_on_outlined,
                      label: 'City',
                      value: _city.isNotEmpty ? _city : 'Not set',
                      iconColor: const Color(0xFFEF4444),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ✅ Preferences Section
                  _buildSectionTitle('Preferences'),
                  const SizedBox(height: 8),
                  _buildSettingsCard([
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B5CF6)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.currency_exchange_rounded,
                                  size: 18,
                                  color: Color(0xFF8B5CF6),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Preferred Currency',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCurrency,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xFF6B7280),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF1F2937),
                                  fontWeight: FontWeight.w500,
                                ),
                                items: _currencies.map((currency) {
                                  return DropdownMenuItem(
                                    value: currency,
                                    child: Text(currency),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(
                                      () => _selectedCurrency = value,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildDivider(),
                    _buildToggleTile(
                      icon: Icons.notifications_outlined,
                      iconColor: const Color(0xFFF59E0B),
                      label: 'Push Notifications',
                      subtitle: 'EMI reminders & alerts',
                      value: _notificationsEnabled,
                      onChanged: (val) =>
                          setState(() => _notificationsEnabled = val),
                    ),
                    _buildDivider(),
                    _buildToggleTile(
                      icon: Icons.fingerprint_rounded,
                      iconColor: const Color(0xFF10B981),
                      label: 'Biometric Login',
                      subtitle: 'Use fingerprint to login',
                      value: _biometricEnabled,
                      onChanged: (val) =>
                          setState(() => _biometricEnabled = val),
                    ),
                    _buildDivider(),
                    _buildToggleTile(
                      icon: Icons.dark_mode_outlined,
                      iconColor: const Color(0xFF6366F1),
                      label: 'Dark Mode',
                      subtitle: 'Switch app appearance',
                      value: _darkModeEnabled,
                      onChanged: (val) =>
                          setState(() => _darkModeEnabled = val),
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ✅ Support Section
                  _buildSectionTitle('Support'),
                  const SizedBox(height: 8),
                  _buildSettingsCard([
                    _buildArrowTile(
                      icon: Icons.chat_bubble_outline_rounded,
                      iconColor: const Color(0xFF3B82F6),
                      label: 'Chat Support',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatDocumentScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildArrowTile(
                      icon: Icons.help_outline_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      label: 'Help & FAQ',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildArrowTile(
                      icon: Icons.privacy_tip_outlined,
                      iconColor: const Color(0xFF10B981),
                      label: 'Privacy Policy',
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildArrowTile(
                      icon: Icons.description_outlined,
                      iconColor: const Color(0xFFF59E0B),
                      label: 'Terms & Conditions',
                      onTap: () {},
                    ),
                  ]),
                  const SizedBox(height: 20),

                  // ✅ Danger Zone
                  _buildSectionTitle('Danger Zone'),
                  const SizedBox(height: 8),
                  _buildSettingsCard([
                    _buildArrowTile(
                      icon: Icons.delete_outline_rounded,
                      iconColor: const Color(0xFFEF4444),
                      label: 'Delete Account',
                      labelColor: const Color(0xFFEF4444),
                      onTap: () => _showDeleteAccountDialog(),
                    ),
                  ]),
                  const SizedBox(height: 24),

                  // ✅ Sign Out Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showSignOutDialog(context),
                      icon: const Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'QuickLoan v1.0.0 • Made with ❤️ in India',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Profile Header
  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            children: [
              // Top Bar
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Profile & Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _showEditProfileSheet,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ✅ Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  GestureDetector(
                    onTap: _showEditProfileSheet,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.5),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _avatarLetter,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ✅ Dynamic Name & Email from login
              Text(
                _fullName.isNotEmpty ? _fullName : 'Welcome',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _email.isNotEmpty ? _email : 'No email set',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),

              // Stats Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildHeaderStat('4', 'Total Loans'),
                    _buildHeaderStatDivider(),
                    _buildHeaderStat('₹20.6K', 'To Collect'),
                    _buildHeaderStatDivider(),
                    _buildHeaderStat('₹15.76L', 'To Pay'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildHeaderStatDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Color(0xFF9CA3AF),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildProfileInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _showEditProfileSheet,
            child: const Icon(
              Icons.edit_outlined,
              size: 16,
              color: Color(0xFF8B5CF6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowTile({
    required IconData icon,
    required Color iconColor,
    required String label,
    Color? labelColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: labelColor ?? const Color(0xFF1F2937),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFFD1D5DB),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 56,
      color: Color(0xFFF3F4F6),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Sign Out?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to sign out of QuickLoan?',
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
            onPressed: () => Navigator.pop(dialogContext),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          '⚠️ Delete Account?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'This action is permanent and cannot be undone. All your loan data will be deleted.',
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
            onPressed: () => Navigator.pop(dialogContext),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
