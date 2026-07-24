import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/product_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountPriceController = TextEditingController();
  final _inventoryController = TextEditingController();
  final _categoryController = TextEditingController();
  final _tagsController = TextEditingController();

  List<File> _selectedImages = [];
  Map<String, List<String>> _variants = {};

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountPriceController.dispose();
    _inventoryController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        title: const Text('إضافة منتج جديد'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Images
              _buildImagePicker(),
              const SizedBox(height: 24),
              // Basic Info
              CustomTextField(
                controller: _nameController,
                label: 'اسم المنتج',
                prefixIcon: Icons.shopping_bag_outlined,
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: AppStrings.description,
                prefixIcon: Icons.description_outlined,
                maxLines: 4,
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 16),
              // Price
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _priceController,
                      label: 'السعر',
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: Validators.validatePrice,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _discountPriceController,
                      label: 'السعر بعد الخصم (اختياري)',
                      prefixIcon: Icons.local_offer_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Category & Inventory
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _categoryController,
                      label: 'الفئة',
                      prefixIcon: Icons.category_outlined,
                      validator: Validators.validateRequired,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _inventoryController,
                      label: 'الكمية',
                      prefixIcon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                      validator: Validators.validateQuantity,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tags
              CustomTextField(
                controller: _tagsController,
                label: 'الوسوم (مفصولة بفاصلة)',
                prefixIcon: Icons.label_outline,
                hint: 'مثال: إلكترونيات, سماعات, بلوتوث',
              ),
              const SizedBox(height: 16),
              // Variants
              _buildVariantsSection(),
              const SizedBox(height: 32),
              // Submit
              CustomButton(
                text: 'إضافة المنتج',
                icon: Icons.add,
                onPressed: _submit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صور المنتج',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Add button
              GestureDetector(
                onTap: () {
                  // TODO: Pick images
                },
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.dividerColor, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_photo_alternate, color: AppTheme.textLight),
                ),
              ),
              const SizedBox(width: 8),
              // Selected images
              ..._selectedImages.map((image) => Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(image),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVariantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الاختيارات (اختياري)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _buildVariantChip('اللون', ['أسود', 'أبيض', 'أزرق', 'أحمر']),
        const SizedBox(height: 8),
        _buildVariantChip('الحجم', ['S', 'M', 'L', 'XL']),
      ],
    );
  }

  Widget _buildVariantChip(String label, List<String> options) {
    return Wrap(
      spacing: 8,
      children: [
        Chip(
          label: Text(label),
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
        ),
        ...options.map((option) => ChoiceChip(
          label: Text(option),
          selected: false,
          onSelected: (_) {},
        )),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final product = ProductModel(
        productId: '',
        storeId: '', // TODO: Get current store ID
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        discountPrice: _discountPriceController.text.isNotEmpty
            ? double.parse(_discountPriceController.text)
            : null,
        images: [],
        category: _categoryController.text,
        tags: _tagsController.text.split(',').map((t) => t.trim()).toList(),
        inventory: int.parse(_inventoryController.text),
        rating: 0,
        reviewCount: 0,
        isActive: true,
        createdAt: DateTime.now(),
      );
      // TODO: Submit product
      context.pop();
    }
  }
}
