import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/colors.dart';
import '../design_system/motion.dart';

/// Six tactile OTP boxes — auto-advances focus as each digit is typed,
/// the focused box gets a clear LaundryGo red state (rule: "focused field
/// should have a clear LaundryGo state").
class OtpFieldGroup extends StatefulWidget {
  const OtpFieldGroup({super.key, this.length = 6, this.onCompleted});

  final int length;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpFieldGroup> createState() => _OtpFieldGroupState();
}

class _OtpFieldGroupState extends State<OtpFieldGroup> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    final code = _controllers.map((c) => c.text).join();
    if (code.length == widget.length) widget.onCompleted?.call(code);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final red = theme.brightness == Brightness.dark
        ? LGColors.redDark
        : LGColors.red;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (i) {
        return SizedBox(
          width: 46,
          height: 56,
          child: AnimatedBuilder(
            animation: _nodes[i],
            builder: (context, child) {
              final focused = _nodes[i].hasFocus;
              return AnimatedContainer(
                duration: LGMotion.micro,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: focused ? red : theme.colorScheme.outline,
                    width: focused ? 1.8 : 1.2,
                  ),
                ),
                child: child,
              );
            },
            child: TextField(
              controller: _controllers[i],
              focusNode: _nodes[i],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: theme.textTheme.headlineSmall,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (v) => _onChanged(i, v),
            ),
          ),
        );
      }),
    );
  }
}
