import 'package:flutter/material.dart';
import '../models/school.dart';
import '../utils/app_theme.dart';

class SchoolCard extends StatefulWidget {
  final School school;
  final VoidCallback onViewDetails;

  const SchoolCard({
    super.key,
    required this.school,
    required this.onViewDetails,
  });

  @override
  State<SchoolCard> createState() => _SchoolCardState();
}

class _SchoolCardState extends State<SchoolCard> {
  bool _isHovered = false;

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
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -6.0 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? AppColors.cardShadow.withOpacity(0.25)
                    : AppColors.cardShadow.withOpacity(0.1),
                blurRadius: _isHovered ? 24 : 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Image.network(
                      widget.school.image,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: AppColors.border,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.border,
                          child: const Center(
                            child: Icon(
                              Icons.school_rounded,
                              size: 48,
                              color: AppColors.textLight,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Board badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getBoardColor(widget.school.board),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.school.board,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // Rating badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.accentLight,
                            size: 14,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            widget.school.rating.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.school.name,
                      style: AppTextStyles.heading3,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Location row
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 14,
                          color: AppColors.accent,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.school.location,
                          style: AppTextStyles.body,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Fees
                    Row(
                      children: [
                        const Icon(
                          Icons.currency_rupee_rounded,
                          size: 14,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${(widget.school.fees / 1000).toStringAsFixed(0)}K / year',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onViewDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'View Details',
                          style: AppTextStyles.buttonText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
