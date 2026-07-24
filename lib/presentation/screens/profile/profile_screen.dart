import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                    backgroundImage: state.user.avatarUrl != null
                        ? NetworkImage(state.user.avatarUrl!)
                        : null,
                    child: state.user.avatarUrl == null
                        ? const Icon(Icons.person, size: 50, color: AppTheme.primaryColor)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.user.displayName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    state.user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Menu Items
                  _buildMenuItem(
                    context,
                    icon: Icons.edit,
                    title: AppStrings.editProfile,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.location_on_outlined,
                    title: AppStrings.addresses,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.receipt_long_outlined,
                    title: AppStrings.myOrders,
                    onTap: () => context.push(AppRoutes.orders),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.store_outlined,
                    title: AppStrings.openStore,
                    onTap: () => context.push(AppRoutes.sellerDashboard),
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: AppStrings.notifications,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.language,
                    title: AppStrings.language,
                    trailing: const Text('العربية'),
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.dark_mode_outlined,
                    title: AppStrings.darkMode,
                    trailing: Switch(
                      value: false,
                      onChanged: (_) {},
                    ),
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: AppStrings.help,
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                      },
                      icon: const Icon(Icons.logout, color: AppTheme.errorColor),
                      label: const Text(
                        AppStrings.logout,
                        style: TextStyle(color: AppTheme.errorColor),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.errorColor),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 22),
      ),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
