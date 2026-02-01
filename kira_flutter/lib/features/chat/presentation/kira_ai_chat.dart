/// Kira AI Chat - Bottom Sheet
/// 
/// Chat interface matching React KiraAI.jsx.
/// Prepared for Genkit backend integration.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/constants/typography.dart';

/// Initial welcome message from Kira
const _initialMessage = ChatMessage(
  role: ChatRole.assistant,
  content: '''Hi! I'm Kira, your carbon advisor.

I can help you:
• Reduce your carbon footprint
• Find GITA tax savings
• Understand your emissions

What would you like to know?''',
);

/// Chat message role
enum ChatRole { user, assistant }

/// Chat message model
class ChatMessage {
  final ChatRole role;
  final String content;
  
  const ChatMessage({
    required this.role,
    required this.content,
  });
}

/// AI Chat bottom sheet widget
class KiraAIChat extends StatefulWidget {
  /// Callback to close the sheet
  final VoidCallback onClose;
  
  /// Optional: Custom send message handler for backend integration
  /// Returns the AI response as a Future<String>
  final Future<String> Function(String message)? onSendMessage;

  const KiraAIChat({
    super.key,
    required this.onClose,
    this.onSendMessage,
  });

  @override
  State<KiraAIChat> createState() => _KiraAIChatState();
}

class _KiraAIChatState extends State<KiraAIChat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [_initialMessage];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    setState(() {
      _messages.add(ChatMessage(role: ChatRole.user, content: text));
      _controller.clear();
      _isLoading = true;
    });
    
    _scrollToBottom();
    
    String response;
    if (widget.onSendMessage != null) {
      // Use provided handler (for backend integration)
      try {
        response = await widget.onSendMessage!(text);
      } catch (e) {
        response = 'Sorry, I encountered an error. Please try again.';
      }
    } else {
      // Mock response for demo
      await Future.delayed(const Duration(milliseconds: 800));
      response = _getMockResponse();
    }
    
    setState(() {
      _messages.add(ChatMessage(role: ChatRole.assistant, content: response));
      _isLoading = false;
    });
    
    _scrollToBottom();
  }
  
  String _getMockResponse() {
    return '''Based on your data, I recommend focusing on your Scope 2 emissions (electricity) - they make up 55% of your footprint.

**Quick wins:**
1. Switch to TNB Green plan (-80 tonnes/year)
2. LED retrofit for remaining lights (-3 tonnes)

This could reduce your carbon tax by RM 2,800. Want details on any of these?''';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () {}, // Prevent close on sheet tap
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.4,
            maxChildSize: 0.92,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                  child: Container(
                    decoration: BoxDecoration(
                      color: KiraColors.bgCardSolid,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      border: Border.all(color: KiraColors.glassBorder),
                    ),
                    child: Column(
                      children: [
                        // Handle
                        _buildHandle(),
                        
                        // Header
                        _buildHeader(),
                        
                        // Messages
                        Expanded(child: _buildMessages()),
                        
                        // Input
                        _buildInput(),
                        
                        // Safe area padding
                        SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.smart_toy_outlined, size: 20, color: KiraColors.success),
              const SizedBox(width: 8),
              Text('Kira AI', style: KiraTypography.h3),
            ],
          ),
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isLoading) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }
  
  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.role == ChatRole.user;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: KiraColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.smart_toy_outlined, size: 14, color: KiraColors.success),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser 
                    ? KiraColors.primary600 
                    : Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.content,
                style: KiraTypography.bodySmall.copyWith(
                  color: KiraColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.person_outline, size: 14, color: KiraColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: KiraColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.smart_toy_outlined, size: 14, color: KiraColors.success),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _TypingDot(delay: i * 150),
              )),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: KiraColors.glassBorder),
              ),
              child: TextField(
                controller: _controller,
                style: KiraTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'Ask Kira anything...',
                  hintStyle: KiraTypography.bodySmall.copyWith(
                    color: KiraColors.textTertiary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [KiraColors.primary500, KiraColors.primary600],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.send, size: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated typing dot
class _TypingDot extends StatefulWidget {
  final int delay;
  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
    
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Opacity(
        opacity: _animation.value,
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: KiraColors.textSecondary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

/// Helper function to show AI chat
void showKiraAIChat(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (context) => KiraAIChat(
      onClose: () => Navigator.of(context).pop(),
    ),
  );
}
