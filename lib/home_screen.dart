import 'package:flutter/material.dart';
import 'main.dart';
import 'hazard_categories_screen.dart'; // تم استيراد صفحة فئات المخاطر
import 'my_reports_screen.dart'; // تم استيراد صفحة بلاغاتي

class StudentHomeScreen extends StatefulWidget {
  final String userName;
  final String userRole;
  final bool isArabic;

  const StudentHomeScreen({
    super.key,
    required this.userName,
    this.userRole = 'student',
    this.isArabic = true,
  });

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  late bool _isAr;

  @override
  void initState() {
    super.initState();
    _isAr = widget.isArabic;
  }

  String t(String ar, String en) => _isAr ? ar : en;

  void _openMyReports() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyReportsScreen(isArabic: _isAr),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: _isAr ? TextDirection.rtl : TextDirection.ltr,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            t('تسجيل الخروج', 'Logout'),
            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
          ),
          content: Text(
            t('هل أنت متأكد أنك تريد تسجيل الخروج من النظام؟', 'Are you sure you want to log out?'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t('إلغاء', 'Cancel'), style: const TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnhancedLoginScreen(
                      isArabic: _isAr,
                      onToggleLanguage: () {},
                    ),
                  ),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(t('خروج', 'Logout')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String roleBadge = widget.userRole == 'student'
        ? t('بوابة الطالب', 'Student Portal')
        : widget.userRole == 'worker'
        ? t('فريق الصيانة', 'Maintenance Team')
        : t('مشرف السلامة', 'Safety Supervisor');

    return Directionality(
      textDirection: _isAr ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F7F5),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A5D3A),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.language, color: Colors.white),
            onPressed: () => setState(() => _isAr = !_isAr),
          ),
          title: Text(
            t('الرئيسية', 'Home'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.white),
              onPressed: _confirmLogout,
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. بطاقة الترحيب
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A5D3A), Color(0xFF26784D)],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                        child: const Text('👋', style: TextStyle(fontSize: 28)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37).withOpacity(0.25),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                roleBadge,
                                style: const TextStyle(color: Color(0xFFFFE082), fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              t('مرحباً، ${widget.userName}', 'Welcome, ${widget.userName}'),
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              t('كيف نقدر نساعدك اليوم؟', 'How can we help you today?'),
                              style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // 2. زر الإبلاغ عن خطر الرئيسي (مربوط وجاهز)
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HazardCategoriesScreen(isArabic: _isAr),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_circle_outline, size: 22),
                    label: Text(
                      t('الإبلاغ عن خطر جديد', 'Report a New Hazard'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A5D3A),
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // 3. بطاقات الإحصائيات (بطاقة بلاغاتي مربوطة أيضاً)
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _openMyReports,
                        child: _buildStatCard(
                          count: '04',
                          label: t('بلاغاتي', 'My Reports'),
                          numberColor: const Color(0xFF1A5D3A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        count: '02',
                        label: t('قيد المعالجة', 'In Progress'),
                        numberColor: const Color(0xFFD97706),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 4. قسم آخر التحديثات
                Text(
                  t('آخر التحديثات', 'Recent Updates'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                ),

                const SizedBox(height: 12),

                _buildUpdateCard(
                  title: t('تسرب مياه', 'Water Leakage'),
                  location: t('مبنى العلوم • الطابق 2', 'Science Bldg • Floor 2'),
                  status: t('قيد المعالجة', 'In Progress'),
                  statusBgColor: const Color(0xFFFEF3C7),
                  statusTextColor: const Color(0xFFB45309),
                  icon: Icons.water_drop_outlined,
                  iconColor: const Color(0xFF0284C7),
                ),

                const SizedBox(height: 12),

                _buildUpdateCard(
                  title: t('مصباح معطل', 'Broken Light'),
                  location: t('المكتبة الرئيسية', 'Main Library'),
                  status: t('تم الإصلاح', 'Resolved'),
                  statusBgColor: const Color(0xFFDCFCE7),
                  statusTextColor: const Color(0xFF15803D),
                  icon: Icons.lightbulb_outline,
                  iconColor: const Color(0xFFEAB308),
                ),

                const SizedBox(height: 20),

                // 5. زر عرض كل بلاغاتي (تم الربط هنا)
                SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _openMyReports,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF1A5D3A),
                      side: const BorderSide(color: Color(0xFF1A5D3A), width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      t('عرض كل بلاغاتي', 'View All My Reports'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 6. زر تسجيل الخروج السفلي
                TextButton.icon(
                  onPressed: _confirmLogout,
                  icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                  label: Text(
                    t('تسجيل الخروج من الحساب', 'Sign Out'),
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({required String count, required String label, required Color numberColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5ECE8)),
      ),
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: numberColor)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 13, color: Color(0xFF6B7C72), fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildUpdateCard({
    required String title,
    required String location,
    required String status,
    required Color statusBgColor,
    required Color statusTextColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
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
            decoration: BoxDecoration(color: const Color(0xFFF6F8F7), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22))),
                const SizedBox(height: 4),
                Text(location, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7C72))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: statusBgColor, borderRadius: BorderRadius.circular(8)),
            child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: statusTextColor)),
          ),
        ],
      ),
    );
  }
}