import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  String _language = 'ar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: Text(AppStrings.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('المظهر'),
          _buildSwitchTile(
            icon: Icons.dark_mode,
            title: AppStrings.darkMode,
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          const Divider(),
          _buildSectionTitle('الإشعارات'),
          _buildSwitchTile(
            icon: Icons.notifications,
            title: 'تفعيل الإشعارات',
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
          ),
          _buildSwitchTile(
            icon: Icons.local_offer,
            title: 'عروض وخصومات',
            value: true,
            onChanged: (_) {},
          ),
          _buildSwitchTile(
            icon: Icons.local_shipping,
            title: 'تحديثات الطلبات',
            value: true,
            onChanged: (_) {},
          ),
          const Divider(),
          _buildSectionTitle('اللغة'),
          _buildLanguageSelector(),
          const Divider(),
          _buildSectionTitle('الحساب'),
          _buildListTile(
            icon: Icons.delete_forever,
            title: 'حذف الحساب',
            iconColor: AppTheme.errorColor,
            textColor: AppTheme.errorColor,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('حذف الحساب'),
                  content: const Text('هل أنت متأكد من حذف حسابك؟ لا يمكن التراجع عن هذا الإجراء.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('إلغاء'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Delete account
                      },
                      child: const Text('حذف', style: TextStyle(color: AppTheme.errorColor)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppTheme.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppTheme.primaryColor,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Color? iconColor,
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppTheme.primaryColor),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLanguageSelector() {
    return Column(
      children: [
        RadioListTile(
          title: const Row(
            children: [
              Text('🇸🇦 '),
              Text('العربية'),
            ],
          ),
          value: 'ar',
          groupValue: _language,
          onChanged: (value) => setState(() => _language = value.toString()),
          activeColor: AppTheme.primaryColor,
        ),
        RadioListTile(
          title: const Row(
            children: [
              Text('🇺🇸 '),
              Text('English'),
            ],
          ),
          value: 'en',
          groupValue: _language,
          onChanged: (value) => setState(() => _language = value.toString()),
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }
}
