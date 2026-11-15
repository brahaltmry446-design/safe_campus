import 'package:flutter/material.dart';

class SafetyGuideScreen extends StatelessWidget {
  final bool isArabic;

  const SafetyGuideScreen({super.key, this.isArabic = true});

  String t(String ar, String en) => isArabic ? ar : en;

  void _simulateEmergencyCall(BuildContext context, String title, String number) {
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
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_in_talk_rounded, color: Color(0xFFDC2626), size: 42),
              ),
              const SizedBox(height: 16),
              Text(
                t('جاري الاتصال الطارئ...', 'Calling Emergency...'),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
              ),
              const SizedBox(height: 6),
              Text(
                '$title ($number)',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFFDC2626)),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(t('إنهاء المكالمة', 'End Call'), style: const TextStyle(fontWeight: FontWeight.bold)),
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
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
            t('الطوارئ وإرشادات السلامة', 'Emergency & Safety Guide'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. بطاقة الاتصال السريع للطوارئ
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.sos_rounded, color: Colors.white, size: 32),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              t('أرقام الطوارئ السريعة', 'Quick Emergency Contacts'),
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        t(
                          'في الحالات الخطرة والمستعجلة، تواصل فوراً مع الجهات المختصة:',
                          'In critical emergencies, contact the relevant authorities immediately:',
                        ),
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      _buildEmergencyContactTile(
                        context,
                        title: t('الأمن الجامعي (الطوارئ)', 'Campus Security'),
                        number: '06-5355000',
                        icon: Icons.security_rounded,
                      ),
                      const SizedBox(height: 10),
                      _buildEmergencyContactTile(
                        context,
                        title: t('العيادة الطبية الجامعية', 'Campus Medical Clinic'),
                        number: '06-5355111',
                        icon: Icons.local_hospital_rounded,
                      ),
                      const SizedBox(height: 10),
                      _buildEmergencyContactTile(
                        context,
                        title: t('الدفاع المدني الموحد', 'Civil Defense'),
                        number: '911',
                        icon: Icons.fire_truck_rounded,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 2. عنوان الإرشادات الوقائية
                Text(
                  t('إرشادات التصرف في الحالات الطارئة', 'Emergency Response Guidelines'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                ),
                const SizedBox(height: 12),

                _buildGuidelineCard(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: const Color(0xFFDC2626),
                  title: t('عند اندلاع حريق أو شم رائحة دخان', 'In Case of Fire or Smoke'),
                  steps: isArabic
                      ? [
                    'اضغط على أقرب زر إنذار حريق في الممر فوراً.',
                    'لا تستخدم المصاعد نهائياً، واستخدم سلالم الطوارئ.',
                    'توجه بهدوء إلى أقرب نقطة تجمع خارج المبنى.',
                  ]
                      : [
                    'Activate the nearest fire alarm pull station immediately.',
                    'Never use elevators; use emergency stairwells.',
                    'Proceed calmly to the nearest outdoor assembly point.',
                  ],
                ),

                const SizedBox(height: 12),

                _buildGuidelineCard(
                  icon: Icons.bolt_rounded,
                  iconColor: const Color(0xFFEAB308),
                  title: t('المخاطر والالتماسات الكهربائية', 'Electrical Hazards & Short Circuits'),
                  steps: isArabic
                      ? [
                    'ابتعد عن الأسلاك المكشوفة أو الأجهزة التي تصدر شراراً.',
                    'لا تلمس أي معدات كهربائية بأيدٍ مبللة أو قرب تجمعات المياه.',
                    'أبلغ فوراً عبر التطبيق وحدد رقم القاعة أو المختبر بدقة.',
                  ]
                      : [
                    'Stay away from exposed wires or sparking equipment.',
                    'Do not touch electrical devices with wet hands or near water.',
                    'Report immediately via the app with exact room details.',
                  ],
                ),

                const SizedBox(height: 12),

                _buildGuidelineCard(
                  icon: Icons.science_rounded,
                  iconColor: const Color(0xFF2563EB),
                  title: t('السلامة داخل المختبرات العلمية', 'Laboratory Safety'),
                  steps: isArabic
                      ? [
                    'التزم بارتداء المعطف المخبري والنظارات الواقية طوال الوقت.',
                    'تأكد من إغلاق صمامات الغاز والمواد الكيميائية بعد انتهاء التجربة.',
                    'في حال انسكاب مادة كيميائية، أبلغ مشرف المختبر فوراً.',
                  ]
                      : [
                    'Wear lab coats and protective goggles at all times.',
                    'Ensure gas valves and chemicals are sealed after experiments.',
                    'In case of a chemical spill, notify the lab supervisor immediately.',
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContactTile(
      BuildContext context, {
        required String title,
        required String number,
        required IconData icon,
      }) {
    return InkWell(
      onTap: () => _simulateEmergencyCall(context, title, number),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFDC2626), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22))),
                  Text(number, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF6B7C72))),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF15803D),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.call_rounded, color: Colors.white, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<String> steps,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5ECE8)),
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: steps
            .map(
              (step) => Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 18, color: Color(0xFF1A5D3A)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(step, style: const TextStyle(fontSize: 13, color: Color(0xFF4A5D52), height: 1.4)),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}