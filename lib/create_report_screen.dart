import 'package:flutter/material.dart';

class CreateReportScreen extends StatefulWidget {
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;
  final bool isArabic;

  const CreateReportScreen({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    this.isArabic = true,
  });

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationDetailsController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedBuilding;
  String _severity = 'medium';
  bool _hasAttachment = false;
  bool _isSubmitting = false;

  String t(String ar, String en) => widget.isArabic ? ar : en;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationDetailsController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitReport() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() => _isSubmitting = false);

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => Directionality(
            textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle_rounded, color: Color(0xFF15803D), size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    t('تم إرسال البلاغ بنجاح!', 'Report Submitted Successfully!'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t(
                      'شكراً لمساهمتك في الحفاظ على سلامة الحرم الجامعي. سيتم مراجعة بلاغك من قبل فريق الصيانة.',
                      'Thank you for keeping the campus safe. Our maintenance team will review your report shortly.',
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF6B7C72)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A5D3A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(t('العودة للرئيسية', 'Back to Home'), style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> buildings = widget.isArabic
        ? ['كلية تكنولوجيا المعلومات', 'كلية الهندسة', 'كلية العلوم', 'المكتبة الرئيسية', 'عمادة شؤون الطلبة', 'الساحات الخارجية']
        : ['IT Faculty', 'Engineering Faculty', 'Science Faculty', 'Main Library', 'Student Affairs', 'Outdoor Areas'];

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
            t('إنشاء بلاغ جديد', 'Create New Report'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5ECE8)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.categoryColor.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(widget.categoryIcon, color: widget.categoryColor, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t('نوع الخطر المختار', 'Selected Hazard Category'),
                              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C72)),
                            ),
                            Text(
                              widget.categoryName,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(t('عنوان البلاغ', 'Report Title'), style: _labelStyle()),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titleController,
                    decoration: _inputDecoration(t('مثال: سلك كهرباء مكشوف في الممر', 'e.g., Exposed wire in hallway')),
                    validator: (val) => (val == null || val.trim().isEmpty) ? t('يرجى إدخال عنوان البلاغ', 'Please enter a title') : null,
                  ),
                  const SizedBox(height: 16),
                  Text(t('المبنى / الكلية', 'Building / Faculty'), style: _labelStyle()),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBuilding,
                    decoration: _inputDecoration(t('اختر المبنى', 'Select building')),
                    items: buildings.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                    onChanged: (val) => setState(() => _selectedBuilding = val),
                    validator: (val) => val == null ? t('يرجى اختيار المبنى', 'Please select a building') : null,
                  ),
                  const SizedBox(height: 16),
                  Text(t('تفاصيل الموقع (الطابق / رقم القاعة)', 'Location Details (Floor / Room)'), style: _labelStyle()),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _locationDetailsController,
                    decoration: _inputDecoration(t('مثال: الطابق الثاني - بجانب مختبر 4', 'e.g., 2nd Floor - near Lab 4')),
                    validator: (val) => (val == null || val.trim().isEmpty) ? t('يرجى تحديد الموقع بدقة', 'Please specify location') : null,
                  ),
                  const SizedBox(height: 16),
                  Text(t('درجة الخطورة', 'Severity Level'), style: _labelStyle()),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSeverityChip('low', t('منخفضة', 'Low'), const Color(0xFF15803D)),
                      const SizedBox(width: 8),
                      _buildSeverityChip('medium', t('متوسطة', 'Medium'), const Color(0xFFD97706)),
                      const SizedBox(width: 8),
                      _buildSeverityChip('high', t('عالية', 'High'), const Color(0xFFDC2626)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(t('وصف المشكلة', 'Description'), style: _labelStyle()),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: _inputDecoration(t('اشرح تفاصيل الخطر بشكل واضح...', 'Describe the hazard clearly...')),
                    validator: (val) => (val == null || val.trim().isEmpty) ? t('يرجى كتابة وصف مختصر', 'Please add a description') : null,
                  ),
                  const SizedBox(height: 16),
                  Text(t('رقم الهاتف للتواصل (اختياري)', 'Contact Phone (Optional)'), style: _labelStyle()),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration(t('مثال: 079XXXXXXX', 'e.g., 079XXXXXXX')),
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => setState(() => _hasAttachment = !_hasAttachment),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                      decoration: BoxDecoration(
                        color: _hasAttachment ? const Color(0xFFE3ECE6) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _hasAttachment ? const Color(0xFF1A5D3A) : const Color(0xFFCBD5CE),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _hasAttachment ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
                            color: const Color(0xFF1A5D3A),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _hasAttachment
                                ? t('تم إرفاق صورة للخطر (اضغط للإلغاء)', 'Photo Attached (Tap to remove)')
                                : t('إرفاق صورة للخطر (اختياري)', 'Attach a Photo (Optional)'),
                            style: const TextStyle(color: Color(0xFF1A5D3A), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A5D3A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                          : Text(
                        t('إرسال البلاغ', 'Submit Report'),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _labelStyle() => const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22));

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5ECE8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5ECE8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1A5D3A), width: 1.5),
      ),
    );
  }

  Widget _buildSeverityChip(String value, String label, Color color) {
    final bool isSelected = _severity == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _severity = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.15) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? color : const Color(0xFFE5ECE8), width: isSelected ? 1.8 : 1),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isSelected ? color : const Color(0xFF6B7C72),
            ),
          ),
        ),
      ),
    );
  }
}