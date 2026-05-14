import 'package:flutter/material.dart';
import '../models/school.dart';
import '../services/school_service.dart';
import '../widgets/school_card.dart';
import '../widgets/filter_bar.dart';
import '../utils/app_theme.dart';
import 'school_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SchoolService _schoolService = SchoolService();
  final TextEditingController _searchController = TextEditingController();

  List<School> _allSchools = [];
  List<School> _filteredSchools = [];

  String? _selectedLocation;
  String? _selectedBoard;
  double _minFees = 0;
  double _maxFees = 200000;
  double _currentMinFees = 0;
  double _currentMaxFees = 200000;

  List<String> _availableLocations = [];

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSchools();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchSchools() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final schools = await _schoolService.getAllSchools();
      final fees = schools.map((s) => s.fees.toDouble()).toList();
      final min = fees.reduce((a, b) => a < b ? a : b);
      final max = fees.reduce((a, b) => a > b ? a : b);

      final locations = schools.map((s) => s.location).toSet().toList()..sort();

      setState(() {
        _allSchools = schools;
        _filteredSchools = schools;
        _minFees = min;
        _maxFees = max;
        _currentMinFees = min;
        _currentMaxFees = max;
        _availableLocations = locations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSchools = _allSchools.where((school) {
        final matchesSearch = school.name.toLowerCase().contains(query) ||
            school.location.toLowerCase().contains(query);
        final matchesLocation =
            _selectedLocation == null || school.location == _selectedLocation;
        final matchesBoard =
            _selectedBoard == null || school.board == _selectedBoard;
        final matchesFees = school.fees >= _currentMinFees &&
            school.fees <= _currentMaxFees;
        return matchesSearch && matchesLocation && matchesBoard && matchesFees;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedLocation = null;
      _selectedBoard = null;
      _currentMinFees = _minFees;
      _currentMaxFees = _maxFees;
      _filteredSchools = _allSchools;
    });
  }

  void _navigateToDetail(School school) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SchoolDetailScreen(school: school),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primaryLight],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      top: -40,
                      right: -40,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -20,
                      left: 80,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    // Content
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.school_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'SchoolFinder',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Find the Perfect School\nfor Your Child',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Browse top schools across India',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Body content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _isLoading
                  ? _buildLoadingState()
                  : _error != null
                      ? _buildErrorState()
                      : _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        const SizedBox(height: 40),
        const CircularProgressIndicator(color: AppColors.primary),
        const SizedBox(height: 20),
        Text(
          'Loading schools...',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade100),
      ),
      child: Column(
        children: [
          Icon(Icons.wifi_off_rounded, size: 48, color: Colors.red.shade300),
          const SizedBox(height: 16),
          const Text(
            'Could not connect to server',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: 8),
          Text(
            _error!,
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _fetchSchools,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter bar
        FilterBar(
          searchController: _searchController,
          selectedLocation: _selectedLocation,
          selectedBoard: _selectedBoard,
          minFees: _minFees,
          maxFees: _maxFees,
          currentMinFees: _currentMinFees,
          currentMaxFees: _currentMaxFees,
          locations: _availableLocations,
          onSearchChanged: (_) => _applyFilters(),
          onLocationChanged: (val) {
            setState(() => _selectedLocation = val);
            _applyFilters();
          },
          onBoardChanged: (val) {
            setState(() => _selectedBoard = val);
            _applyFilters();
          },
          onFeesRangeChanged: (range) {
            setState(() {
              _currentMinFees = range.start;
              _currentMaxFees = range.end;
            });
            _applyFilters();
          },
          onClearFilters: _clearFilters,
        ),
        const SizedBox(height: 24),

        // Results count
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                style: AppTextStyles.body,
                children: [
                  TextSpan(
                    text: '${_filteredSchools.length} ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: _filteredSchools.length == 1 ? 'school found' : 'schools found',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Total: ${_allSchools.length}',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // School grid
        if (_filteredSchools.isEmpty)
          _buildEmptyState()
        else
          _buildSchoolGrid(),

        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSchoolGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1100) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 650) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.72,
          ),
          itemCount: _filteredSchools.length,
          itemBuilder: (context, index) {
            return SchoolCard(
              school: _filteredSchools[index],
              onViewDetails: () => _navigateToDetail(_filteredSchools[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 56,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          const Text('No schools found', style: AppTextStyles.heading3),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search or filters',
            style: AppTextStyles.body,
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: _clearFilters,
            child: const Text(
              'Clear all filters',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
