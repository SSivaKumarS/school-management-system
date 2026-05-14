import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class FilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedLocation;
  final String? selectedBoard;
  final double minFees;
  final double maxFees;
  final double currentMinFees;
  final double currentMaxFees;
  final List<String> locations;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onLocationChanged;
  final ValueChanged<String?> onBoardChanged;
  final ValueChanged<RangeValues> onFeesRangeChanged;
  final VoidCallback onClearFilters;

  const FilterBar({
    super.key,
    required this.searchController,
    required this.selectedLocation,
    required this.selectedBoard,
    required this.minFees,
    required this.maxFees,
    required this.currentMinFees,
    required this.currentMaxFees,
    required this.locations,
    required this.onSearchChanged,
    required this.onLocationChanged,
    required this.onBoardChanged,
    required this.onFeesRangeChanged,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasActiveFilters = selectedLocation != null ||
        selectedBoard != null ||
        currentMinFees > minFees ||
        currentMaxFees < maxFees;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Search & Filter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              if (hasActiveFilters)
                TextButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.clear_all_rounded, size: 18),
                  label: const Text('Clear All'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Responsive layout
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // Wide: all in one row
                return _buildWideLayout();
              } else {
                // Narrow: stacked
                return _buildNarrowLayout();
              }
            },
          ),

          // Fees range
          const SizedBox(height: 12),
          _buildFeesRange(),
        ],
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildSearchField()),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: _buildLocationDropdown()),
        const SizedBox(width: 12),
        Expanded(flex: 2, child: _buildBoardDropdown()),
      ],
    );
  }

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        _buildSearchField(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildLocationDropdown()),
            const SizedBox(width: 12),
            Expanded(child: _buildBoardDropdown()),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search schools...',
        hintStyle: AppTextStyles.body,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textLight,
          size: 20,
        ),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedLocation,
      hint: const Text('All Locations', style: AppTextStyles.body),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All Locations'),
        ),
        ...locations.map((loc) => DropdownMenuItem(value: loc, child: Text(loc))),
      ],
      onChanged: onLocationChanged,
      dropdownColor: AppColors.surface,
    );
  }

  Widget _buildBoardDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedBoard,
      hint: const Text('All Boards', style: AppTextStyles.body),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      items: const [
        DropdownMenuItem<String>(value: null, child: Text('All Boards')),
        DropdownMenuItem<String>(value: 'CBSE', child: Text('CBSE')),
        DropdownMenuItem<String>(value: 'ICSE', child: Text('ICSE')),
        DropdownMenuItem<String>(value: 'State', child: Text('State')),
      ],
      onChanged: onBoardChanged,
      dropdownColor: AppColors.surface,
    );
  }

  Widget _buildFeesRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Fees Range',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '₹${(currentMinFees / 1000).toStringAsFixed(0)}K  –  ₹${(currentMaxFees / 1000).toStringAsFixed(0)}K',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: RangeValues(currentMinFees, currentMaxFees),
          min: minFees,
          max: maxFees,
          divisions: 20,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.border,
          onChanged: onFeesRangeChanged,
        ),
      ],
    );
  }
}
