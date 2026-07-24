import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      _nameController.text = state.user.displayName;
      _phoneController.text = state.user.phone;
      _emailController.text = state.user.email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: Text(AppStrings.editProfile),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return _buildForm(state.user);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildForm(UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  backgroundImage: user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
                  child: user.avatarUrl == null
                      ? const Icon(Icons.person, size: 60, color: AppTheme.primaryColor)
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _nameController,
              label: AppStrings.name,
              prefixIcon: Icons.person_outline,
              validator: (value) => value?.isEmpty ?? true ? AppStrings.requiredField : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _phoneController,
              label: AppStrings.phone,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) => value?.isEmpty ?? true ? AppStrings.requiredField : null,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _emailController,
              label: AppStrings.email,
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              enabled: false,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: AppStrings.save,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final updatedUser = user.copyWith(
                    displayName: _nameController.text,
                    phone: _phoneController.text,
                  );
                  context.read<AuthBloc>().add(UpdateProfile(updatedUser));
                  context.pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
