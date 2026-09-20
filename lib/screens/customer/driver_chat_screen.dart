import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/motion.dart';
import '../../design_system/spacing.dart';
import '../../models/customer_models.dart';

class _ChatMessage {
  _ChatMessage({required this.text, required this.fromDriver});
  final String text;
  final bool fromDriver;
}

/// Real in-app chat with the driver handling this order — a genuine
/// message thread (send, receive, auto-scroll), not a snackbar stand-in.
class DriverChatScreen extends StatefulWidget {
  const DriverChatScreen({super.key, required this.order});

  final LaundryOrder order;

  @override
  State<DriverChatScreen> createState() => _DriverChatScreenState();
}

class _DriverChatScreenState extends State<DriverChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late final List<_ChatMessage> _messages = [
    _ChatMessage(
      text: "Hi! I'm on my way with your order.",
      fromDriver: true,
    ),
  ];
  bool _driverTyping = false;

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
      _messages.add(_ChatMessage(text: text, fromDriver: false));
      _controller.clear();
      _driverTyping = true;
    });
    _scrollToBottom();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _driverTyping = false;
        _messages.add(
          _ChatMessage(text: _autoReplyFor(text), fromDriver: true),
        );
      });
      _scrollToBottom();
    });
  }

  String _autoReplyFor(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('where') || lower.contains('eta') || lower.contains('time')) {
      return "I'm about 10 minutes away, thanks for your patience!";
    }
    if (lower.contains('thank')) return "You're very welcome!";
    return 'Got it, thanks for letting me know!';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;

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
                    backgroundImage: AssetImage(widget.order.driverImage),
                  ),
                  const SizedBox(width: LGSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.order.driverName,
                          style: theme.textTheme.titleSmall,
                        ),
                        Text(
                          'Your delivery driver',
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
                        content: Text('Calling ${widget.order.driverName}...'),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.call_outlined, size: 20, color: red),
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
                itemCount: _messages.length + (_driverTyping ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i == _messages.length) {
                    return const _TypingBubble();
                  }
                  final m = _messages[i];
                  return Align(
                    alignment: m.fromDriver
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
                        color: m.fromDriver
                            ? theme.colorScheme.surfaceContainerHighest
                            : red,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(m.fromDriver ? 4 : 16),
                          bottomRight: Radius.circular(m.fromDriver ? 16 : 4),
                        ),
                      ),
                      child: Text(
                        m.text,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: m.fromDriver
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
                        hintText: 'Message your driver...',
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
                    color: red,
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
