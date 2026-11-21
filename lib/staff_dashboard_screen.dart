import 'package:flutter/material.dart';
import 'main.dart';

class StaffReport {
  final String id;
  final String titleAr;
  final String titleEn;
  final String locationAr;
  final String locationEn;
  final String reporterName;
  final String severity; // 'low', 'medium', 'high'
  String status; // 'pending', 'in_progress', 'resolved'
  String? maintenanceNote;

  StaffReport({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.locationAr,
    required this.locationEn,
    required this.reporterName,
    required this.severity,
    required this.status,
    this.maintenanceNote,
  });
}

class StaffDashboardScreen extends StatefulWidget {
  final String userName;
  final String userRole; // 'worker' or 'supervisor'
  final bool isArabic;

  const StaffDashboardScreen({
    super.key,
    required this.userName,
    required this.userRole,
    this.isArabic = true,
  });

  @override
  State<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends State<StaffDashboardScreen> {
  late bool _isAr;
  String _filterStatus = 'all';

  @override
  void initState() {
    super.initState();
    _isAr = widget.isArabic;
  }

  String t(String ar, String en) => _isAr ? ar : en;

  final List<StaffReport> _reports = [
    StaffReport(
      id: '#SC-1042',
      titleAr: 'سلك كهرباء مكشوف في الممر',
      titleEn: 'Exposed electrical wire in hallway',
      locationAr: 'كلية تكنولوجيا المعلومات - الطابق 2',
      locationEn: 'IT Faculty - 2nd Floor',
      reporterName: 'براءة التعمري',
      severity: 'high',
      status: 'pending',
    ),
    StaffReport(
      id: '#SC-1041',
      titleAr: 'تسرب مياه عند مدخل المكتبة',
      titleEn: 'Water leak at Library entrance',
      locationAr: 'المكتبة الرئيسية - الطابق الأرضي',
      locationEn: 'Main Library - Ground Floor',
      reporterName: 'أحمد خالد',
      severity: 'medium',
      status: 'in_progress',
      maintenanceNote: 'تم إغلاق المحبس الرئيسي وجاري التجفيف',
    ),
    StaffReport(
      id: '#SC-1035',
      titleAr: 'تلف في قفل باب مخرج الطوارئ',
      titleEn: 'Damaged emergency exit door lock',
      locationAr: 'كلية الهندسة - الجناح الغربي',
      locationEn: 'Engineering Faculty - West Wing',
      reporterName: 'سارة محمود',
      severity: 'high',
      status: 'pending',
    ),
    StaffReport(
      id: '#SC-1028',
      titleAr: 'مصباح معطل في القاعة 104',
      titleEn: 'Broken light in Hall 104',
      locationAr: 'كلية العلوم - الطابق الأول',
      locationEn: 'Science Faculty - 1st Floor',
      reporterName: 'عمر حسن',
      severity: 'low',
      status: 'resolved',
      maintenanceNote: 'تم استبدال وحدة الإنارة بالكامل',
    ),
  ];

  List<StaffReport> get _filteredList {
    if (_filterStatus == 'all') return _reports;
    return _reports.where((r) => r.status == _filterStatus).toList();
  }

  void _openUpdateStatusSheet(StaffReport report) {
    String tempStatus = report.status;
    final noteController = TextEditingController(text: report.maintenanceNote ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Directionality(
          textDirection: _isAr ? TextDirection.rtl : TextDirection.ltr,
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${t('تحديث حالة البلاغ', 'Update Report Status')} (${report.id})',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                ),
                const SizedBox(height: 6),
                Text(
                  _isAr ? report.titleAr : report.titleEn,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF6B7C72)),
                ),
                const SizedBox(height: 18),
                Text(t('اختر الحالة الجديدة:', 'Select New Status:'), style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _statusOptionChip(setModalState, 'pending', t('قيد المراجعة', 'Pending'), const Color(0xFFD97706), tempStatus, (v) => tempStatus = v),
                    const SizedBox(width: 8),
                    _statusOptionChip(setModalState, 'in_progress', t('جاري العمل', 'In Progress'), const Color(0xFF2563EB), tempStatus, (v) => tempStatus = v),
                    const SizedBox(width: 8),
                    _statusOptionChip(setModalState, 'resolved', t('تم الإصلاح', 'Resolved'), const Color(0xFF15803D), tempStatus, (v) => tempStatus = v),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: t('ملاحظات فريق الصيانة (اختياري)', 'Maintenance Note (Optional)'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        report.status = tempStatus;
                        report.maintenanceNote = noteController.text.trim().isEmpty ? null : noteController.text.trim();
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(t('تم تحديث حالة البلاغ بنجاح', 'Report status updated successfully')),
                          backgroundColor: const Color(0xFF1A5D3A),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A5D3A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(t('حفظ التحديث', 'Save Update'), style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((_) => noteController.dispose());
  }

  Widget _statusOptionChip(
      StateSetter setModalState,
      String value,
      String label,
      Color color,
      String current,
      Function(String) onSelect,
      ) {
    final selected = current == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setModalState(() => onSelect(value)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? color.withOpacity(0.15) : const Color(0xFFF4F7F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: selected ? color : Colors.transparent, width: 1.5),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: selected ? color : const Color(0xFF6B7C72)),
          ),
        ),
      ),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => EnhancedLoginScreen(isArabic: _isAr, onToggleLanguage: () {}),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _reports.where((r) => r.status == 'pending').length;
    final progressCount = _reports.where((r) => r.status == 'in_progress').length;
    final resolvedCount = _reports.where((r) => r.status == 'resolved').length;

    final roleTitle = widget.userRole == 'supervisor'
        ? t('لوحة مشرف السلامة', 'Safety Supervisor Panel')
        : t('لوحة فريق الصيانة', 'Maintenance Team Panel');

    return Directionality(
      textDirection: _isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A2E22),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: () => setState(() => _isAr = !_isAr),
          ),
          title: Text(roleTitle, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              onPressed: _logout,
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // شريط الإحصائيات العلوي
              Container(
                color: const Color(0xFF1A2E22),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Row(
                  children: [
                    _statBox(t('جديدة', 'New'), pendingCount.toString(), const Color(0xFFFBBF24)),
                    const SizedBox(width: 10),
                    _statBox(t('قيد العمل', 'Active'), progressCount.toString(), const Color(0xFF60A5FA)),
                    const SizedBox(width: 10),
                    _statBox(t('منجزة', 'Done'), resolvedCount.toString(), const Color(0xFF4ADE80)),
                  ],
                ),
              ),

              // أزرار الفلترة
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterBtn('all', t('الكل', 'All')),
                      const SizedBox(width: 8),
                      _filterBtn('pending', t('قيد المراجعة', 'Pending')),
                      const SizedBox(width: 8),
                      _filterBtn('in_progress', t('جاري العمل', 'In Progress')),
                      const SizedBox(width: 8),
                      _filterBtn('resolved', t('تم الإصلاح', 'Resolved')),
                    ],
                  ),
                ),
              ),

              // قائمة البلاغات الواردة
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredList.length,
                  itemBuilder: (context, index) {
                    final item = _filteredList[index];
                    final isHigh = item.severity == 'high';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isHigh && item.status != 'resolved' ? const Color(0xFFFCA5A5) : const Color(0xFFE5ECE8),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.id, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6B7C72))),
                              _buildSeverityBadge(item.severity),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isAr ? item.titleAr : item.titleEn,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_isAr ? item.locationAr : item.locationEn} • ${t('المُبلّغ:', 'By:')} ${item.reporterName}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C72)),
                          ),
                          if (item.maintenanceNote != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.build_circle_outlined, size: 16, color: Color(0xFF1A5D3A)),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      item.maintenanceNote!,
                                      style: const TextStyle(fontSize: 12, color: Color(0xFF1A2E22)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: OutlinedButton.icon(
                              onPressed: () => _openUpdateStatusSheet(item),
                              icon: const Icon(Icons.edit_note_rounded, size: 18),
                              label: Text(t('تحديث الحالة وإضافة ملاحظة', 'Update Status & Note')),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF1A5D3A),
                                side: const BorderSide(color: Color(0xFF1A5D3A)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
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

  Widget _statBox(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _filterBtn(String value, String label) {
    final active = _filterStatus == value;
    return GestureDetector(
      onTap: () => setState(() => _filterStatus = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1A5D3A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? const Color(0xFF1A5D3A) : const Color(0xFFE5ECE8)),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: active ? Colors.white : const Color(0xFF4A5D52)),
        ),
      ),
    );
  }

  Widget _buildSeverityBadge(String severity) {
    if (severity == 'high') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(6)),
        child: Text(t('خطورة عالية', 'High Risk'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
      );
    } else if (severity == 'medium') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
        child: Text(t('متوسطة', 'Medium'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(6)),
      child: Text(t('منخفضة', 'Low'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
    );
  }
}