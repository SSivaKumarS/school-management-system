import 'package:flutter/material.dart';
import '../models/school.dart';
import '../utils/app_theme.dart';

class SchoolDetailScreen extends StatelessWidget {
  final School school;

  const SchoolDetailScreen({super.key, required this.school});

  Color _getBoardColor(String board) {
    switch (board.toUpperCase()) {
      case 'CBSE':
        return AppColors.cbse;
      case 'ICSE':
        return AppColors.icse;
      case 'STATE':
        return AppColors.state;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero image app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    school.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: AppColors.primary,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.primary,
                        child: const Center(
                          child: Icon(Icons.school_rounded, size: 80, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                  // School name on image
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getBoardColor(school.board),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            school.board,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          school.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            shadows: [
                              Shadow(color: Colors.black26, blurRadius: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return _buildWideLayout(context);
                  }
                  return _buildNarrowLayout(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildOverviewCard(),
              const SizedBox(height: 16),
              _buildDescriptionCard(),
              const SizedBox(height: 16),
              _buildFacilitiesCard(),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              _buildStatsCard(),
              const SizedBox(height: 16),
              _buildContactCard(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      children: [
        _buildOverviewCard(),
        const SizedBox(height: 16),
        _buildStatsCard(),
        const SizedBox(height: 16),
        _buildDescriptionCard(),
        const SizedBox(height: 16),
        _buildFacilitiesCard(),
        const SizedBox(height: 16),
        _buildContactCard(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCard({required String title, required Widget child, IconData? icon}) {
    return Container(
      width: double.infinity,
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
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
              ],
              Text(title, style: AppTextStyles.heading3),
            ],
          ),
          const SizedBox(height: 4),
          const Divider(color: AppColors.border),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return _buildCard(
      title: 'Overview',
      icon: Icons.info_outline_rounded,
      child: Column(
        children: [
          _buildInfoRow(Icons.location_on_rounded, 'Location', school.location),
          _buildInfoRow(Icons.account_balance_rounded, 'Board', school.board),
          _buildInfoRow(
            Icons.currency_rupee_rounded,
            'Annual Fees',
            '₹${school.fees.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
          ),
          _buildInfoRow(Icons.calendar_today_rounded, 'Established', school.established.toString()),
          _buildInfoRow(Icons.star_rounded, 'Rating', '${school.rating} / 5.0'),
          _buildInfoRow(Icons.home_outlined, 'Address', school.address),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.accent),
          const SizedBox(width: 10),
          SizedBox(
            width: 100,
            child: Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyBold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return _buildCard(
      title: 'At a Glance',
      icon: Icons.bar_chart_rounded,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(school.students.toString(), 'Students', Icons.people_rounded),
          _buildStatItem(school.teachers.toString(), 'Teachers', Icons.person_rounded),
          _buildStatItem(school.facilities.length.toString(), 'Facilities', Icons.business_rounded),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return _buildCard(
      title: 'About',
      icon: Icons.description_rounded,
      child: Text(school.description, style: AppTextStyles.body),
    );
  }

  Widget _buildFacilitiesCard() {
    return _buildCard(
      title: 'Facilities',
      icon: Icons.apartment_rounded,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: school.facilities.map((facility) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 5),
                Text(
                  facility,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactCard() {
    return _buildCard(
      title: 'Contact',
      icon: Icons.contact_phone_rounded,
      child: Column(
        children: [
          _buildInfoRow(Icons.phone_rounded, 'Phone', school.contact),
          _buildInfoRow(Icons.language_rounded, 'Website', school.website),
        ],
      ),
    );
  }
}
