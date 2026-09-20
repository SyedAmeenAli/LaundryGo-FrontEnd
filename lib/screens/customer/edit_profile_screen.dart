import 'package:flutter/material.dart';

import '../../components/laundrygo_button.dart';
import '../../data/mock_customer_data.dart';
import '../../design_system/colors.dart';
import '../../design_system/spacing.dart';

/// Real editable form, pre-filled with the current profile — Save pops
/// back with a confirmation, it does not just close silently.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final _name = TextEditingController(
    text: MockCustomerData.activeOrder.driverName,
  );
  late final _email = TextEditingController(text: 'ahmed.balushi@gmail.com');
  late final _phone = TextEditingController(text: '+968 9123 4567');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  InputDecoration _decoration(ThemeData theme, String label, IconData icon) =>
      InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          size: 18,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.6),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final green = theme.brightness == Brightness.dark
        ? LGColors.greenDark
        : LGColors.green;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(LGSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: theme.colorScheme.surface,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.arrow_back, size: 18),
                    ),
                  ),
                ),
                const SizedBox(height: LGSpacing.md),
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineLarge,
                    children: [
                      const TextSpan(text: 'Edit '),
                      TextSpan(
                        text: 'Profile',
                        style: TextStyle(color: green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: LGSpacing.lg),
                TextField(
                  controller: _name,
                  style: theme.textTheme.bodyMedium,
                  decoration: _decoration(
                    theme,
                    'Full name',
                    Icons.person_outline,
                  ),
                ),
                const SizedBox(height: LGSpacing.sm),
                TextField(
                  controller: _email,
                  style: theme.textTheme.bodyMedium,
                  decoration: _decoration(theme, 'Email', Icons.email_outlined),
                ),
                const SizedBox(height: LGSpacing.sm),
                TextField(
                  controller: _phone,
                  style: theme.textTheme.bodyMedium,
                  decoration: _decoration(theme, 'Phone', Icons.phone_outlined),
                ),
                const SizedBox(height: LGSpacing.lg),
                LaundryGoButton(
                  label: 'Save Changes',
                  showArrow: true,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated.')),
                    );
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: LGSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
