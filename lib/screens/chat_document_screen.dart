import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChatDocumentScreen extends StatefulWidget {
  const ChatDocumentScreen({Key? key}) : super(key: key);

  @override
  State<ChatDocumentScreen> createState() => _ChatDocumentScreenState();
}

class _ChatDocumentScreenState extends State<ChatDocumentScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showDocument = false;
  late AnimationController _docAnimController;
  late Animation<double> _docScaleAnim;
  late Animation<double> _docFadeAnim;

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! I need help with my loan application. 🙏',
      'isMe': true,
      'time': '10:00 AM',
      'isRead': true,
    },
    {
      'text':
          'Namaste Aryan! I am here to help you. What do you need assistance with?',
      'isMe': false,
      'time': '10:01 AM',
      'isRead': true,
    },
    {
      'text': 'मुझे अपने लोन की EMI के बारे में जानकारी चाहिए।',
      'isMe': true,
      'time': '10:02 AM',
      'isRead': true,
    },
    {
      'text':
          'Sure! Your current EMI for Home Loan (LN-ARY-002) is ₹14,500/month. Next due date is 15 Apr 2024.',
      'isMe': false,
      'time': '10:03 AM',
      'isRead': true,
    },
    {
      'text': 'Can you share my loan agreement document?',
      'isMe': true,
      'time': '10:04 AM',
      'isRead': true,
    },
    {
      'text':
          'Sure! I have attached your Loan Agreement document below. Please review and verify. 📄',
      'isMe': false,
      'time': '10:05 AM',
      'isRead': true,
      'hasDoc': true,
    },
    {
      'text': 'क्या मेरा व्हीकल लोन overdue है? 😟',
      'isMe': true,
      'time': '10:06 AM',
      'isRead': true,
    },
    {
      'text':
          'Yes, Loan LN-ARY-004 (Vehicle Loan - ₹1,20,000) is overdue by 15 days. Please pay ₹6,500 immediately to avoid penalty.',
      'isMe': false,
      'time': '10:07 AM',
      'isRead': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _docAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _docScaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _docAnimController, curve: Curves.easeOutBack),
    );
    _docFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _docAnimController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _docAnimController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': _messageController.text.trim(),
        'isMe': true,
        'time':
            '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')} ${TimeOfDay.now().period == DayPeriod.am ? 'AM' : 'PM'}',
        'isRead': false,
      });
      _messageController.clear();
    });

    // Auto-reply
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'text':
              'Thank you for your message! Our team will assist you shortly. 😊',
          'isMe': false,
          'time':
              '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')} ${TimeOfDay.now().period == DayPeriod.am ? 'AM' : 'PM'}',
          'isRead': true,
        });
      });
      _scrollToBottom();
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleDocument() {
    setState(() => _showDocument = !_showDocument);
    if (_showDocument) {
      _docAnimController.forward();
    } else {
      _docAnimController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // ✅ Chat Area
          Column(
            children: [
              // Date Chip
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: const Text(
                  'Today, April 10, 2024',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Messages List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return _buildMessageBubble(msg);
                  },
                ),
              ),

              // ✅ Input Field
              _buildInputField(),
            ],
          ),

          // ✅ Floating Document Preview
          if (_showDocument)
            GestureDetector(
              onTap: _toggleDocument,
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),

          if (_showDocument)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: FadeTransition(
                opacity: _docFadeAnim,
                child: ScaleTransition(
                  scale: _docScaleAnim,
                  child: _buildDocumentPreview(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Color(0xFF1F2937),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFF8B5CF6),
                radius: 18,
                child: Icon(
                  Icons.support_agent_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Madad Support',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              Text(
                'Online • Typically replies instantly',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.video_call_outlined,
            color: Color(0xFF6B7280),
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Color(0xFF6B7280),
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> msg) {
    final isMe = msg['isMe'] as bool;
    final hasDoc = msg['hasDoc'] == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Agent Avatar
          if (!isMe) ...[
            const CircleAvatar(
              backgroundColor: Color(0xFF8B5CF6),
              radius: 14,
              child: Icon(
                Icons.support_agent_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
          ],

          // Message Content
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.68,
                  ),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF8B5CF6) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msg['text'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: isMe ? Colors.white : const Color(0xFF1F2937),
                          height: 1.4,
                        ),
                      ),
                      // Document attachment chip
                      if (hasDoc) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _toggleDocument,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F3FF),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFF8B5CF6)
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.picture_as_pdf_rounded,
                                  size: 16,
                                  color: Color(0xFFEF4444),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Loan_Agreement.pdf',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8B5CF6),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.open_in_new_rounded,
                                  size: 12,
                                  color: Color(0xFF8B5CF6),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg['time'] as String,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 4),
                      Icon(
                        msg['isRead'] == true
                            ? Icons.done_all_rounded
                            : Icons.done_rounded,
                        size: 14,
                        color: msg['isRead'] == true
                            ? const Color(0xFF8B5CF6)
                            : const Color(0xFF9CA3AF),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // My Avatar
          if (isMe) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: Color(0xFF8B5CF6),
              radius: 14,
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Emoji Button
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.emoji_emotions_outlined,
                  color: Color(0xFF6B7280),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Attachment Button
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.attach_file_rounded,
                  color: Color(0xFF6B7280),
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Text Input
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: _messageController,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 3,
                  minLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Send Button
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Document Preview Overlay
  Widget _buildDocumentPreview() {
    return Transform.rotate(
      angle: -0.02 * math.pi,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFFDE68A),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Document Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF1F2937),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Color(0xFFEF4444),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Loan_Agreement.pdf',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '2 pages • 1.2 MB',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleDocument,
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white60,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // Document Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Center(
                    child: Text(
                      'LOAN AGREEMENT',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Madad Financial Services Pvt. Ltd.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDocLine('Agreement No:', 'LN-ARY-002'),
                  _buildDocLine('Borrower Name:', 'Aryan Pawar'),
                  _buildDocLine('Loan Type:', 'Home Loan'),
                  _buildDocLine('Principal Amount:', '₹15,00,000'),
                  _buildDocLine('Interest Rate:', '8.5% p.a.'),
                  _buildDocLine('Tenure:', '120 Months (10 Years)'),
                  _buildDocLine('EMI Amount:', '₹14,500/month'),
                  _buildDocLine('Start Date:', '15 January 2024'),
                  const SizedBox(height: 12),
                  const Divider(color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 12),

                  // Agreement text
                  const Text(
                    'The borrower agrees to repay the loan amount along with applicable interest in equal monthly installments (EMI) as per the schedule mentioned above. Any default in payment will attract a penalty of 2% per month on the overdue amount.',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Signature Section
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color(0xFF1F2937)
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Aryan',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'serif',
                                    color: Color(0xFF1F2937),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Borrower Signature',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 100,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color(0xFF1F2937)
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Madad',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'serif',
                                    color: Color(0xFF8B5CF6),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Lender Signature',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.download_rounded,
                            size: 16,
                          ),
                          label: const Text('Download'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF8B5CF6),
                            side: const BorderSide(
                              color: Color(0xFF8B5CF6),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Share',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
      ),
    );
  }

  Widget _buildDocLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
