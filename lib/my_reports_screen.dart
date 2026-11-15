import 'package:flutter/material.dart';

class ReportItem {
  final String id;
  final String titleAr;
  final String titleEn;
  final String categoryAr;
  final String categoryEn;
  final String locationAr;
  final String locationEn;
  final String date;
  final String status; // 'pending', 'in_progress', 'resolved'
  final String severity; // 'low', 'medium', 'high'
  final IconData icon;
  final Color categoryColor;

  const ReportItem({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.categoryAr,
    required this.categoryEn,
    required this.locationAr,
    required this.locationEn,
    required this.date,
    required this.status,
    required this.severity,
    required this.icon,
    required this.categoryColor,
  });
}

class MyReportsScreen extends StatefulWidget {
  final bool isArabic;

  const MyReportsScreen({super.key, this.isArabic = true});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  String _selectedFilter = 'all';

  String t(String ar, String en) => widget.isArabic ? ar : en;

  final List<ReportItem> _allReports = const [
    ReportItem(
      id: '#SC-1042',
      titleAr: 'سلك كهرباء مكشوف في الممر',
      titleEn: 'Exposed electrical wire in hallway',
      categoryAr: 'كهرباء',
      categoryEn: 'Electrical',
      locationAr: 'كلية تكنولوجيا المعلومات - الطابق الثاني',
      locationEn: 'IT Faculty - 2nd Floor',
      date: '2026-11-14',
      status: 'in_progress',
      severity: 'high',
      icon: Icons.bolt_rounded,
      categoryColor: Color(0xFFEAB308),
    ),
    ReportItem(
      id: '#SC-1039',
      titleAr: 'تسرب مياه وأرضية زلقة عند المدخل',
      titleEn: 'Water leak and slippery floor at entrance',
      categoryAr: 'أرضية زلقة',
      categoryEn: 'Slippery Floor',
      locationAr: 'المكتبة الرئيسية - الطابق الأرضي',
      locationEn: 'Main Library - Ground Floor',
      date: '2026-11-12',
      status: 'resolved',
      severity: 'medium',
      icon: Icons.warning_amber_rounded,
      categoryColor: Color(0xFFD97706),
    ),
    ReportItem(
      id: '#SC-1035',
      titleAr: 'تلف في قفل باب مخرج الطوارئ',
      titleEn: 'Damaged emergency exit door lock',
      categoryAr: 'مخارج طوارئ',
      categoryEn: 'Emergency Exits',
      locationAr: 'كلية الهندسة - الجناح الغربي',
      locationEn: 'Engineering Faculty - West Wing',
      date: '2026-11-10',
      status: 'pending',
      severity: 'high',
      icon: Icons.exit_to_app_rounded,
      categoryColor: Color(0xFF991B1B),
    ),
    ReportItem(
      id: '#SC-1028',
      titleAr: 'تعطل جهاز التهوية في مختبر الكيمياء',
      titleEn: 'Ventilation unit malfunction in Chemistry Lab',
      categoryAr: 'مختبرات',
      categoryEn: 'Laboratories',
      locationAr: 'كلية العلوم - مختبر 3',
      locationEn: 'Science Faculty - Lab 3',
      date: '2026-11-05',
      status: 'resolved',
      severity: 'low',
      icon: Icons.science_rounded,
      categoryColor: Color(0xFF2563EB),
    ),
  ];

  List<ReportItem> get _filteredReports {
    if (_selectedFilter == 'all') return _allReports;
    return _allReports.where((r) => r.status == _selectedFilter).toList();
  }

  Map<String, dynamic> _getStatusStyle(String status) {
    switch (status) {
      case 'pending':
        return {
          'label': t('قيد المراجعة', 'Pending'),
          'bg': const Color(0xFFFEF3C7),
          'text': const Color(0xFFB45309),
        };
      case 'in_progress':
        return {
          'label': t('جاري المعالجة', 'In Progress'),
          'bg': const Color(0xFFDBEAFE),
          'text': const Color(0xFF1D4ED8),
        };
      case 'resolved':
      default:
        return {
          'label': t('تم الحل', 'Resolved'),
          'bg': const Color(0xFFDCFCE7),
          'text': const Color(0xFF15803D),
        };
    }
  }

  void _showReportDetails(ReportItem report) {
    final statusStyle = _getStatusStyle(report.status);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Directionality(
        textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    report.id,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6B7C72)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusStyle['bg'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusStyle['label'],
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusStyle['text']),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.isArabic ? report.titleAr : report.titleEn,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
              ),
              const SizedBox(height: 16),
              _detailRow(Icons.category_outlined, t('الفئة', 'Category'), widget.isArabic ? report.categoryAr : report.categoryEn),
              const SizedBox(height: 10),
              _detailRow(Icons.location_on_outlined, t('الموقع', 'Location'), widget.isArabic ? report.locationAr : report.locationEn),
              const SizedBox(height: 10),
              _detailRow(Icons.calendar_today_outlined, t('تاريخ الإرسال', 'Submitted Date'), report.date),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A5D3A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(t('إغلاق', 'Close'), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1A5D3A)),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontSize: 13, color: Color(0xFF6B7C72))),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1A2E22)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final reports = _filteredReports;

    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A5D3A),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            t('بلاغاتي', 'My Reports'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // شريط الفلترة العلوي
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', t('الكل', 'All')),
                      const SizedBox(width: 8),
                      _buildFilterChip('pending', t('قيد المراجعة', 'Pending')),
                      const SizedBox(width: 8),
                      _buildFilterChip('in_progress', t('جاري المعالجة', 'In Progress')),
                      const SizedBox(width: 8),
                      _buildFilterChip('resolved', t('تم الحل', 'Resolved')),
                    ],
                  ),
                ),
              ),

              // قائمة البلاغات
              Expanded(
                child: reports.isEmpty
                    ? Center(
                  child: Text(
                    t('لا توجد بلاغات في هذا القسم', 'No reports in this category'),
                    style: const TextStyle(color: Color(0xFF6B7C72), fontSize: 15),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final item = reports[index];
                    final statusStyle = _getStatusStyle(item.status);

                    return GestureDetector(
                      onTap: () => _showReportDetails(item),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE5ECE8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: item.categoryColor.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(item.icon, color: item.categoryColor, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.isArabic ? item.titleAr : item.titleEn,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1A2E22),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${item.id} • ${widget.isArabic ? item.categoryAr : item.categoryEn}',
                                        style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C72)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: statusStyle['bg'],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    statusStyle['label'],
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: statusStyle['text'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20, color: Color(0xFFF0F4F1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_outlined, size: 15, color: Color(0xFF6B7C72)),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          widget.isArabic ? item.locationAr : item.locationEn,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C72)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  item.date,
                                  style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String value, String label) {
    final bool isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A5D3A) : const Color(0xFFF4F7F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF4A5D52),
          ),
        ),
      ),
    );
  }
}