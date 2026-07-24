import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/store_model.dart';

/// Compact horizontal card used in home screen featured stores row.
/// Pass [store] for real data, or use the named params for mock/placeholder.
class StoreCard extends StatelessWidget {
  final StoreModel? store;

  // Fallback individual params (for mock/placeholder usage)
  final String? name;
  final double? rating;
  final int? followers;
  final String? logoUrl;
  final VoidCallback? onTap;

  const StoreCard({
    super.key,
    this.store,
    this.name,
    this.rating,
    this.followers,
    this.logoUrl,
    this.onTap,
  }) : assert(
          store != null || name != null,
          'Provide either a StoreModel or at least a name.',
        );

  String get _name       => store?.name       ?? name!;
  double get _rating     => store?.rating     ?? rating ?? 0.0;
  int    get _followers  => store?.followersCount ?? followers ?? 0;
  String? get _logoUrl   => store?.logoUrl    ?? logoUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / Avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                clipBehavior: Clip.antiAlias,
                child: _logoUrl != null && _logoUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: _logoUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const _StorePlaceholderIcon(),
                        errorWidget: (_, __, ___) => const _StorePlaceholderIcon(),
                      )
                    : const _StorePlaceholderIcon(),
              ),
              const SizedBox(height: 8),

              // Name
              Text(
                _name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 4),

              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star, size: 12, color: AppColors.ratingActive),
                  const SizedBox(width: 2),
                  Text(
                    _rating.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 2),

              // Followers
              Text(
                '${_formatCount(_followers)} متابع',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppTheme.textLight,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}

class _StorePlaceholderIcon extends StatelessWidget {
  const _StorePlaceholderIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(Icons.store, color: AppColors.primary, size: 26);
  }
}
