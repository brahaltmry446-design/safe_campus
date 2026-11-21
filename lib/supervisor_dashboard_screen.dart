import 'package:flutter/material.dart';
import 'main.dart';
import 'supervisor_incident_report_screen.dart';

class SupervisorReport {
  final String id;
  final String titleAr;
  final String titleEn;
  final String locationAr;
  final String locationEn;
  final String reporterName;
  final String severity; // 'low', 'medium', 'high'
  String status; // 'pending', 'in_progress', 'resolved'
  String? assignedWorker; // الفني المسؤول عن البلاغ

  SupervisorReport({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.locationAr,
    required this.locationEn,
    required this.reporterName,
    required this.severity,
    required this.status,
    this.assignedWorker,
  });
}

class SupervisorDashboardScreen extends StatefulWidget {
  final String userName;
  final bool isArabic;

  const SupervisorDashboardScreen({
    super.key,
    required this.userName,
    this.isArabic = true,
  });

  @override
  State<SupervisorDashboardScreen> createState() => _SupervisorDashboardScreenState();
}

class _SupervisorDashboardScreenState extends State<SupervisorDashboardScreen> {
  late bool _isAr;
  String _filterStatus = 'all';

  @override
  void initState() {
    super.initState();
    _isAr = widget.isArabic;
  }

  String t(String ar, String en) => _isAr ? ar : en;

  final List<String> _workersList = [
    'أحمد خالد (كهرباء)',
    'محمد عياد (صيانة عامة)',
    'عمر حسن (تكييف وتبريد)',
    'إبراهيم طارق (أمن والسلامة)',
  ];

  final List<SupervisorReport> _reports = [
    SupervisorReport(
      id: '#SC-1042',
      titleAr: 'سلك كهرباء مكشوف في الممر',
      titleEn: 'Exposed electrical wire in hallway',
      locationAr: 'كلية تكنولوجيا المعلومات - الطابق 2',
      locationEn: 'IT Faculty - 2nd Floor',
      reporterName: 'براءة التعمري',
      severity: 'high',
      status: 'pending',
      assignedWorker: null,
    ),
    SupervisorReport(
      id: '#SC-1041',
      titleAr: 'تسرب مياه عند مدخل المكتبة',
      titleEn: 'Water leak at Library entrance',
      locationAr: 'المكتبة الرئيسية - الطابق الأرضي',
      locationEn: 'Main Library - Ground Floor',
      reporterName: 'سارة محمود',
      severity: 'medium',
      status: 'in_progress',
      assignedWorker: 'محمد عياد (صيانة عامة)',
    ),
    SupervisorReport(
      id: '#SC-1035',
      titleAr: 'تلف في قفل باب مخرج الطوارئ',
      titleEn: 'Damaged emergency exit door lock',
      locationAr: 'كلية الهندسة - الجناح الغربي',
      locationEn: 'Engineering Faculty - West Wing',
      reporterName: 'عمر حسن',
      severity: 'high',
      status: 'pending',
      assignedWorker: null,
    ),
  ];

  List<SupervisorReport> get _filteredList {
    if (_filterStatus == 'all') return _reports;
    return _reports.where((r) => r.status == _filterStatus).toList();
  }

  void _assignWorkerDialog(SupervisorReport report) {
    String? selectedWorker = report.assignedWorker;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(t('إسناد البلاغ لفني صيانة', 'Assign Report to Worker'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${t('اختر الفني المسؤول عن إصلاح:', 'Select technician for:')} ${_isAr ? report.titleAr : report.titleEn}',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF6B7C72))),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: selectedWorker,
                hint: Text(t('اختر الفني المناسب', 'Select worker')),
                isExpanded: true,
                items: _workersList.map((worker) {
                  return DropdownMenuItem(value: worker, child: Text(worker, style: const TextStyle(fontSize: 13)));
                }).toList(),
                onChanged: (val) {
                  setDialogState(() => selectedWorker = val);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t('إلغاء', 'Cancel'), style: const TextStyle(color: Color(0xFF6B7C72))),
            ),
            ElevatedButton(
              onPressed: selectedWorker == null
                  ? null
                  : () {
                setState(() {
                  report.assignedWorker = selectedWorker;
                  if (report.status == 'pending') {
                    report.status = 'in_progress'; // تلقائياً يتحول لقيد العمل عند الإسناد
                  }
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(t('تم إسناد البلاغ بنجاح', 'Report assigned successfully')),
                    backgroundColor: const Color(0xFF1A5D3A),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A5D3A), foregroundColor: Colors.white),
              child: Text(t('إسناد وتحديث', 'Assign & Update')),
            ),
          ],
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
    final totalCount = _reports.length;
    final pendingCount = _reports.where((r) => r.status == 'pending').length;
    final progressCount = _reports.where((r) => r.status == 'in_progress').length;

    return Directionality(
      textDirection: _isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0E4228),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: () => setState(() => _isAr = !_isAr),
          ),
          title: Text(t('لوحة إشراف السلامة العامة', 'Safety Supervisor Dashboard'), style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
              // إحصائيات علوية مخصصة للمشرف
              Container(
                color: const Color(0xFF0E4228),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Row(
                  children: [
                    _statBox(t('إجمالي البلاغات', 'Total'), totalCount.toString(), Colors.white),
                    const SizedBox(width: 10),
                    _statBox(t('بانتظار الإسناد', 'Unassigned'), pendingCount.toString(), const Color(0xFFFBBF24)),
                    const SizedBox(width: 10),
                    _statBox(t('قيد المعالجة', 'In Progress'), progressCount.toString(), const Color(0xFF60A5FA)),
                  ],
                ),
              ),

              // زر التقرير وأرشيف التقارير
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupervisorIncidentReportMainScreen(
                                  userName: widget.userName,
                                  isArabic: _isAr,
                                  initialTabIndex: 0,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.note_add_rounded, size: 18),
                          label: Text(
                            t('نموذج تقرير حادث', 'Incident Report'),
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A5D3A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SupervisorIncidentReportMainScreen(
                                  userName: widget.userName,
                                  isArabic: _isAr,
                                  initialTabIndex: 2,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                          label: Text(
                            t('أرشيف التقارير (PDF)', 'Reports Archive'),
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF1A5D3A),
                            side: const BorderSide(color: Color(0xFF1A5D3A), width: 1.2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
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
                      _filterBtn('pending', t('بانتظار الإسناد', 'Pending')),
                      const SizedBox(width: 8),
                      _filterBtn('in_progress', t('قيد العمل', 'In Progress')),
                      const SizedBox(width: 8),
                      _filterBtn('resolved', t('المكتملة', 'Resolved')),
                    ],
                  ),
                ),
              ),

              // قائمة بلاغات الجامعة الإشرافية
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredList.length,
                  itemBuilder: (context, index) {
                    final item = _filteredList[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE5ECE8)),
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
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_isAr ? item.locationAr : item.locationEn} • ${t('المُبلّغ:', 'By:')} ${item.reporterName}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C72)),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: item.assignedWorker != null ? const Color(0xFFE6F4EA) : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item.assignedWorker != null ? Icons.engineering : Icons.warning_amber_rounded,
                                  size: 16,
                                  color: item.assignedWorker != null ? const Color(0xFF135233) : const Color(0xFFD97706),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    item.assignedWorker != null
                                        ? '${t('الفني المسؤول:', 'Assigned to:')} ${item.assignedWorker}'
                                        : t('لم يتم إسناد الفني بعد', 'Not assigned to any technician yet'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: item.assignedWorker != null ? const Color(0xFF135233) : const Color(0xFFD97706),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 38,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _assignWorkerDialog(item),
                                    icon: const Icon(Icons.assignment_ind_rounded, size: 15),
                                    label: Text(t('إسناد الفني', 'Assign Worker'), style: const TextStyle(fontSize: 11.5)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1A5D3A),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 38,
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => SupervisorIncidentReportMainScreen(
                                            userName: widget.userName,
                                            isArabic: _isAr,
                                            initialTabIndex: 0,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.picture_as_pdf_rounded, size: 15),
                                    label: Text(t('تصدير التقرير', 'Export PDF'), style: const TextStyle(fontSize: 11.5)),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF1A5D3A),
                                      side: const BorderSide(color: Color(0xFF1A5D3A)),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
        child: Text(t('خطورة عالية', 'High'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
      child: Text(t('متوسطة', 'Medium'), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
    );
  }
}