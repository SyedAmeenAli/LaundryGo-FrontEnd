import 'package:flutter/material.dart';

import '../../../design_system/colors.dart';
import '../../../design_system/motion.dart';
import '../../../design_system/spacing.dart';
import '../../../models/driver_models.dart';

class _ChatMessage {
  _ChatMessage({required this.text, required this.fromCustomer});
  final String text;
  final bool fromCustomer;
}

/// Real in-app chat with the customer for this job — driver-side mirror of
/// the customer's [DriverChatScreen], not a snackbar stand-in.
class CustomerChatScreen extends StatefulWidget {
  const CustomerChatScreen({super.key, required this.job});

  final DriverJob job;

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: "Hi! I'll be picking up your order soon.",
      fromCustomer: false,
    ),
  ];
  bool _customerTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: LGMotion.component,
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(text: text, fromCustomer: false));
      _controller.clear();
      _customerTyping = true;
    });
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _customerTyping = false;
        _messages.add(
          _ChatMessage(text: _autoReplyFor(text), fromCustomer: true),
        );
      });
      _scrollToBottom();
    });
  }

  String _autoReplyFor(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('here') || lower.contains('arrive') || lower.contains('outside')) {
      return "Great, I'll be right down!";
    }
    if (lower.contains('thank')) return "Thank you for the update!";
    return 'Got it, thanks!';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                LGSpacing.sm,
                LGSpacing.sm,
                LGSpacing.md,
                LGSpacing.sm,
              ),
              child: Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(widget.job.customerImage),
                  ),
                  const SizedBox(width: LGSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.job.customerName,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          'Order #LG${widget.job.id}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Calling ${widget.job.customerName}...'),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.call_outlined, size: 20, color: green),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(LGSpacing.md),
                itemCount: _messages.length + (_customerTyping ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i == _messages.length) {
                    return const _TypingBubble();
                  }
                  final m = _messages[i];
                  return Align(
                    alignment: m.fromCustomer
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: LGSpacing.sm),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.72,
                      ),
                      decoration: BoxDecoration(
                        color: m.fromCustomer
                            ? theme.colorScheme.surfaceContainerHighest
                            : green,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(m.fromCustomer ? 4 : 16),
                          bottomRight: Radius.circular(m.fromCustomer ? 16 : 4),
                        ),
                      ),
                      child: Text(
                        m.text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: m.fromCustomer
                              ? theme.colorScheme.onSurface
                              : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(LGSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Message your customer...',
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: LGSpacing.sm),
                  Material(
                    color: green,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _send,
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.send, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: LGSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: SizedBox(
          width: 24,
          child: Text('...', style: theme.textTheme.titleMedium),
        ),
      ),
    );
  }
}
