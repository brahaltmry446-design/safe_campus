import 'package:flutter/material.dart';

// نموذج بيانات تقرير الحادث المكتمل
class IncidentReportData {
  String id;
  String hazardType;
  String location;
  String closingDate;
  String rootCause;
  String summaryActions;
  String impactAssessment;
  String preventiveRecommendations;
  String assignedWorker;
  String approvingSupervisor;
  String reportDate;
  String status; // 'approved' (معتمد) or 'draft' (مسودة)

  IncidentReportData({
    required this.id,
    required this.hazardType,
    required this.location,
    required this.closingDate,
    required this.rootCause,
    required this.summaryActions,
    required this.impactAssessment,
    required this.preventiveRecommendations,
    required this.assignedWorker,
    required this.approvingSupervisor,
    required this.reportDate,
    required this.status,
  });
}

// الشاشة الرئيسية للمشرف مع شريط التنقل السفلي (Bottom Navigation)
class SupervisorIncidentReportMainScreen extends StatefulWidget {
  final String userName;
  final bool isArabic;
  final int initialTabIndex;

  const SupervisorIncidentReportMainScreen({
    super.key,
    required this.userName,
    this.isArabic = true,
    this.initialTabIndex = 0,
  });

  @override
  State<SupervisorIncidentReportMainScreen> createState() => _SupervisorIncidentReportMainScreenState();
}

class _SupervisorIncidentReportMainScreenState extends State<SupervisorIncidentReportMainScreen> {
  late int _currentIndex;
  late bool _isAr;

  // القائمة البرمجية المؤقتة للتقارير لغايات العرض
  final List<IncidentReportData> _reportsArchive = [
    IncidentReportData(
      id: '#1024',
      hazardType: 'تسرب مياه غزير',
      location: 'مبنى A - الغرفة 105',
      closingDate: '2026/11/20',
      rootCause: 'تآكل في الأنابيب الرئيسية خلف الجدار',
      summaryActions: 'إغلاق المحبس الرئيسي، استدعاء فريق الصيانة، استبدال الأنبوب التالف، وتجفيف المكان',
      impactAssessment: 'تلف بسيط في الطلاء السفلي للجدار، لا توجد أضرار بشرية',
      preventiveRecommendations: 'جدولة فحص دوري لأنابيب المياه في المبنى',
      assignedWorker: 'أحمد محمود',
      approvingSupervisor: 'عبد الرحمن أبو زيد',
      reportDate: '2026/11/21',
      status: 'approved',
    ),
    IncidentReportData(
      id: '#1025',
      hazardType: 'انقطاع المفتاح الرئيسي للكهرباء',
      location: 'مبنى B - مختبر الحاسوب 2',
      closingDate: '2026/11/21',
      rootCause: 'حمولة زائدة على القاطع التلقائي',
      summaryActions: 'فصل الأجهزة غير الضرورية واستبدال القاطع الحراري',
      impactAssessment: 'توقف المختبر لمدة نصف ساعة دون أي خسائر في الأجهزة',
      preventiveRecommendations: 'إعادة توزيع الأحمال الكهربائية على اللوحات الفرعية',
      assignedWorker: 'محمد عياد',
      approvingSupervisor: 'عبد الرحمن أبو زيد',
      reportDate: '2026/11/21',
      status: 'draft',
    ),
    IncidentReportData(
      id: '#1026',
      hazardType: 'تلف في قفل مخرج الطوارئ',
      location: 'مبنى C - الجناح الغربي',
      closingDate: '2026/11/21',
      rootCause: 'صدأ وتآكل في المزلاج السفلية',
      summaryActions: 'تشحيم القفل واستبدال المقبض المتآكل بمقبض طوارئ قياسي',
      impactAssessment: 'تأخر بسيط في فتح الباب أثناء الفحص الدوري',
      preventiveRecommendations: 'فحص مخارج الطوارئ شهرياً ودهان المفصلات بالمانع للصدأ',
      assignedWorker: 'إبراهيم طارق',
      approvingSupervisor: 'عبد الرحمن أبو زيد',
      reportDate: '2026/11/21',
      status: 'draft',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTabIndex;
    _isAr = widget.isArabic;
  }

  String t(String ar, String en) => _isAr ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F5),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // الشاشة 1: إنشاء التقرير
            CreateIncidentReportScreen(
              reportData: _reportsArchive.first,
              isArabic: _isAr,
              onReportSaved: (updatedData) {
                setState(() {
                  _reportsArchive[0] = updatedData;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewIncidentReportScreen(
                      reportData: updatedData,
                      isArabic: _isAr,
                      onApproved: () {
                        setState(() {
                          updatedData.status = 'approved';
                          _currentIndex = 2; // الانتقال لأرشيف التقارير بعد الاعتماد
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            // الشاشة 2: معاينة التقرير النشط مباشرة
            PreviewIncidentReportScreen(
              reportData: _reportsArchive.first,
              isArabic: _isAr,
              onApproved: () {
                setState(() {
                  _reportsArchive.first.status = 'approved';
                  _currentIndex = 2;
                });
              },
            ),
            // الشاشة 3: أرشيف التقارير
            ReportsArchiveScreen(
              archive: _reportsArchive,
              isArabic: _isAr,
              onViewReport: (report) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewIncidentReportScreen(
                      reportData: report,
                      isArabic: _isAr,
                      onApproved: () {
                        setState(() {
                          report.status = 'approved';
                        });
                      },
                    ),
                  ),
                );
              },
            ),
            // الشاشة 4: الملف الشخصي للمشرف
            _buildProfileTab(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            selectedItemColor: const Color(0xFF1A5D3A),
            unselectedItemColor: const Color(0xFF8B9B90),
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home_rounded),
                label: t('الرئيسية', 'Home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.assignment_outlined),
                activeIcon: const Icon(Icons.assignment_rounded),
                label: t('البلاغات', 'Reports'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.folder_outlined),
                activeIcon: const Icon(Icons.folder_rounded),
                label: t('الأرشيف', 'Archive'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person_rounded),
                label: t('الملف الشخصي', 'Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5D3A),
        title: Text(t('الملف الشخصي للمشرف', 'Supervisor Profile'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF1A5D3A),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text(widget.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22))),
            const SizedBox(height: 4),
            Text(t('مشرف السلامة العامة - USHRS', 'Safety Supervisor - USHRS'), style: const TextStyle(color: Color(0xFF6B7C72))),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// الشاشة 1: إنشاء تقرير حادث (Create Incident Report Screen)
// --------------------------------------------------------------------------
class CreateIncidentReportScreen extends StatefulWidget {
  final IncidentReportData reportData;
  final bool isArabic;
  final Function(IncidentReportData) onReportSaved;

  const CreateIncidentReportScreen({
    super.key,
    required this.reportData,
    required this.isArabic,
    required this.onReportSaved,
  });

  @override
  State<CreateIncidentReportScreen> createState() => _CreateIncidentReportScreenState();
}

class _CreateIncidentReportScreenState extends State<CreateIncidentReportScreen> {
  late TextEditingController _rootCauseController;
  late TextEditingController _summaryActionsController;
  late TextEditingController _impactController;
  late TextEditingController _recommendationsController;

  @override
  void initState() {
    super.initState();
    _rootCauseController = TextEditingController(text: widget.reportData.rootCause);
    _summaryActionsController = TextEditingController(text: widget.reportData.summaryActions);
    _impactController = TextEditingController(text: widget.reportData.impactAssessment);
    _recommendationsController = TextEditingController(text: widget.reportData.preventiveRecommendations);
  }

  @override
  void dispose() {
    _rootCauseController.dispose();
    _summaryActionsController.dispose();
    _impactController.dispose();
    _recommendationsController.dispose();
    super.dispose();
  }

  String t(String ar, String en) => widget.isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5D3A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.canPop(context) ? Navigator.pop(context) : null,
        ),
        title: Text(
          t('إنشاء تقرير حادث', 'Create Incident Report'),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. قسم بيانات البلاغ (تعبئة تلقائية)
              Text(
                t('بيانات البلاغ (تعبئة تلقائية)', 'Report Data (Auto-filled)'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EFEA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD3E0D7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${t('رقم البلاغ:', 'Report ID:')} ${widget.reportData.id}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                    ),
                    const SizedBox(height: 6),
                    Text('${t('نوع الخطر:', 'Hazard Type:')} ${widget.reportData.hazardType}', style: const TextStyle(fontSize: 13, color: Color(0xFF4A5D52))),
                    const SizedBox(height: 4),
                    Text('${t('الموقع:', 'Location:')} ${widget.reportData.location}', style: const TextStyle(fontSize: 13, color: Color(0xFF4A5D52))),
                    const SizedBox(height: 4),
                    Text('${t('تاريخ الإغلاق:', 'Closing Date:')} ${widget.reportData.closingDate}', style: const TextStyle(fontSize: 13, color: Color(0xFF4A5D52))),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. قسم تفاصيل تقرير الحادث (الحقول التفصيلية)
              Text(
                t('تفاصيل تقرير الحادث', 'Incident Report Details'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
              ),

              const SizedBox(height: 12),

              _buildFieldLabel(t('السبب الجذر للحادث', 'Root Cause of Incident')),
              const SizedBox(height: 6),
              _buildMultilineInput(_rootCauseController, t('أدخل السبب الجذري...', 'Enter root cause...')),

              const SizedBox(height: 14),

              _buildFieldLabel(t('ملخص الإجراءات المتخذة', 'Summary of Actions Taken')),
              const SizedBox(height: 6),
              _buildMultilineInput(_summaryActionsController, t('أدخل الإجراءات المتخذة...', 'Enter actions taken...')),

              const SizedBox(height: 14),

              _buildFieldLabel(t('تقييم الأثر والضرر', 'Impact & Damage Assessment')),
              const SizedBox(height: 6),
              _buildMultilineInput(_impactController, t('أدخل تقييم الضرر والأثر...', 'Enter impact assessment...')),

              const SizedBox(height: 14),

              _buildFieldLabel(t('التوصيات الوقائية', 'Preventive Recommendations')),
              const SizedBox(height: 6),
              _buildMultilineInput(_recommendationsController, t('أدخل التوصيات لتفادي التكرار...', 'Enter recommendations...')),

              const SizedBox(height: 24),

              // زر الحفظ والمعاينة
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final updated = widget.reportData;
                    updated.rootCause = _rootCauseController.text.trim();
                    updated.summaryActions = _summaryActionsController.text.trim();
                    updated.impactAssessment = _impactController.text.trim();
                    updated.preventiveRecommendations = _recommendationsController.text.trim();
                    widget.onReportSaved(updated);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A5D3A),
                    foregroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    t('حفظ ومعاينة التقرير', 'Save & Preview Report'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
    );
  }

  Widget _buildMultilineInput(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      maxLines: 3,
      style: const TextStyle(fontSize: 13.5, color: Color(0xFF1A2E22)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF9CA3AF)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5ECE8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1A5D3A), width: 1.5),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------
// الشاشة 2: معاينة التقرير الرسمي (Preview Incident Report Screen)
// --------------------------------------------------------------------------
class PreviewIncidentReportScreen extends StatelessWidget {
  final IncidentReportData reportData;
  final bool isArabic;
  final VoidCallback onApproved;

  const PreviewIncidentReportScreen({
    super.key,
    required this.reportData,
    required this.isArabic,
    required this.onApproved,
  });

  String t(String ar, String en) => isArabic ? ar : en;

  void _showExportOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                t('تصدير التقرير الرسمي', 'Export Official Report'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
              ),
              const SizedBox(height: 6),
              Text(
                t('اختر الوسيلة المناسبة لإصدار وتصدير التقرير:', 'Select export option:'),
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7C72)),
              ),
              const SizedBox(height: 20),

              // خيار PDF
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFFDC2626)),
                ),
                title: Text(t('تصدير كـ ملف PDF رقمي', 'Export as PDF File'), style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(t('تنزيل التقرير بصيغة PDF معتمدة', 'Download signed PDF document')),
                onTap: () {
                  Navigator.pop(ctx);
                  onApproved();
                  _showSuccessDialog(context, t('تم تصدير ملف PDF بنجاح وحفظه في الجهاز', 'PDF exported and saved successfully'));
                },
              ),

              const Divider(height: 16),

              // خيار طباعة ورقية
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.print_rounded, color: Color(0xFF4338CA)),
                ),
                title: Text(t('طباعة ورقية مباشرة', 'Direct Print'), style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(t('إرسال التقرير لطابعة الجامعة الرسمية', 'Send report to university printer')),
                onTap: () {
                  Navigator.pop(ctx);
                  onApproved();
                  _showSuccessDialog(context, t('جاري إرسال التقرير للطابعة الرسمية...', 'Sending report to official printer...'));
                },
              ),

              const Divider(height: 16),

              // خيار مشاركة البريد
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.share_rounded, color: Color(0xFF15803D)),
                ),
                title: Text(t('مشاركة عبر البريد الإلكتروني', 'Share via Email'), style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(t('إرسال النسخة لإدارة السلامة العليا', 'Send copy to Higher Safety Management')),
                onTap: () {
                  Navigator.pop(ctx);
                  onApproved();
                  _showSuccessDialog(context, t('تم مشاركة التقرير مع إدارة السلامة العامة', 'Report shared with Safety Management'));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(color: Color(0xFFDCFCE7), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: Color(0xFF15803D), size: 46),
              ),
              const SizedBox(height: 16),
              Text(
                t('تمت العملية بنجاح!', 'Operation Successful!'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Color(0xFF6B7C72)),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A5D3A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(t('حسناً', 'OK'), style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5D3A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.canPop(context) ? Navigator.pop(context) : null,
        ),
        title: Text(
          t('معاينة التقرير', 'Preview Report'),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFE5ECE8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ترويسة التقرير الرسمية
                      Center(
                        child: Column(
                          children: [
                            Text(
                              t('تقرير حادث رسمي - نظام USHRS', 'Official Incident Report - USHRS'),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                            ),
                            const SizedBox(height: 8),
                            const Divider(thickness: 1.2, color: Color(0xFFCBD5CE)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // بيانات البلاغ الأساسية
                      _docRow(t('رقم البلاغ:', 'Report ID:'), reportData.id, isBold: true),
                      const SizedBox(height: 6),
                      _docRow(t('نوع الخطر:', 'Hazard Type:'), reportData.hazardType),
                      const SizedBox(height: 6),
                      _docRow(t('الموقع:', 'Location:'), reportData.location),
                      const SizedBox(height: 6),
                      _docRow(t('تاريخ الإغلاق:', 'Closing Date:'), reportData.closingDate),

                      const SizedBox(height: 16),
                      const Divider(height: 1, color: Color(0xFFE5ECE8)),
                      const SizedBox(height: 14),

                      // السبب الجذري
                      Text(t('السبب الجذري', 'Root Cause'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22))),
                      const SizedBox(height: 4),
                      Text(reportData.rootCause, style: const TextStyle(fontSize: 13, color: Color(0xFF4A5D52), height: 1.4)),

                      const SizedBox(height: 16),

                      // قسم الوثائق المرئية (الصور)
                      Text(t('الوثائق المرئية', 'Visual Documentation'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22))),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(t('قبل الإصلاح', 'Before Repair'), style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7C72))),
                                const SizedBox(height: 6),
                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE5ECE8),
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                      image: NetworkImage('https://picsum.photos/300/200?random=10'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              children: [
                                Text(t('بعد الإصلاح', 'After Repair'), style: const TextStyle(fontSize: 11.5, color: Color(0xFF6B7C72))),
                                const SizedBox(height: 6),
                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE5ECE8),
                                    borderRadius: BorderRadius.circular(10),
                                    image: const DecorationImage(
                                      image: NetworkImage('https://picsum.photos/300/200?random=20'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(height: 1, color: Color(0xFFE5ECE8)),
                      const SizedBox(height: 14),

                      // قسم الفني والمشرف والتوقيع
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t('الفني المسؤول:', 'Assigned Tech:'), style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C72))),
                              Text(reportData.assignedWorker, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22))),
                              const SizedBox(height: 10),
                              Text(t('المشرف المعتمد:', 'Approving Supervisor:'), style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C72))),
                              Text(reportData.approvingSupervisor, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22))),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDCFCE7),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded, color: Color(0xFF15803D), size: 24),
                              ),
                              const SizedBox(height: 4),
                              Text(t('توقيع اعتماد', 'Approved Signature'), style: const TextStyle(fontSize: 11, color: Color(0xFF6B7C72))),
                              Text(reportData.approvingSupervisor, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1A5D3A))),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // زر الاعتماد والتصدير
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: 52,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showExportOptionsModal(context),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 22),
                  label: Text(
                    t('اعتماد وتصدير PDF', 'Approve & Export PDF'),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A5D3A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _docRow(String label, String val, {bool isBold = false}) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7C72))),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            val,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: const Color(0xFF1A2E22),
            ),
          ),
        ),
      ],
    );
  }
}

// --------------------------------------------------------------------------
// الشاشة 3: أرشيف التقارير (Reports Archive Screen)
// --------------------------------------------------------------------------
class ReportsArchiveScreen extends StatefulWidget {
  final List<IncidentReportData> archive;
  final bool isArabic;
  final Function(IncidentReportData) onViewReport;

  const ReportsArchiveScreen({
    super.key,
    required this.archive,
    required this.isArabic,
    required this.onViewReport,
  });

  @override
  State<ReportsArchiveScreen> createState() => _ReportsArchiveScreenState();
}

class _ReportsArchiveScreenState extends State<ReportsArchiveScreen> {
  final TextEditingController _searchController = TextEditingController();
  final String _filterStatus = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String t(String ar, String en) => widget.isArabic ? ar : en;

  List<IncidentReportData> get _filteredList {
    List<IncidentReportData> list = widget.archive;
    String q = _searchController.text.trim().toLowerCase();

    if (q.isNotEmpty) {
      list = list.where((r) =>
      r.hazardType.toLowerCase().contains(q) ||
          r.location.toLowerCase().contains(q) ||
          r.id.toLowerCase().contains(q)).toList();
    }

    if (_filterStatus != 'all') {
      list = list.where((r) => r.status == _filterStatus).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredList;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A5D3A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.canPop(context) ? Navigator.pop(context) : null,
        ),
        title: Text(
          t('أرشيف التقارير', 'Reports Archive'),
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // حقل البحث
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  hintText: t('البحث في التقارير...', 'Search reports...'),
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF1A5D3A)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE5ECE8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF1A5D3A), width: 1.5),
                  ),
                ),
              ),
            ),

            // قائمة التقارير بالأرشيف
            Expanded(
              child: list.isEmpty
                  ? Center(
                child: Text(
                  t('لا توجد تقارير في الأرشيف حالياً', 'No reports found in archive'),
                  style: const TextStyle(color: Color(0xFF6B7C72), fontSize: 14),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  final bool isApproved = item.status == 'approved';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.hazardType} - ${item.location.split('-').first.trim()}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: isApproved ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                isApproved ? t('معتمد', 'Approved') : t('مسودة', 'Draft'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isApproved ? const Color(0xFF15803D) : const Color(0xFFB45309),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${t('تاريخ التقرير:', 'Report Date:')} ${item.reportDate}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C72)),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () => widget.onViewReport(item),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE3ECE6),
                                    foregroundColor: const Color(0xFF1A5D3A),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    t('عرض التقرير', 'View Report'),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 40,
                              width: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4F7F5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE5ECE8)),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.send_rounded, size: 18, color: Color(0xFF1A5D3A)),
                                onPressed: () => widget.onViewReport(item),
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
    );
  }
}