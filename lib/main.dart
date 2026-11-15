import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'staff_dashboard_screen.dart';
import 'supervisor_dashboard_screen.dart';

void main() {
  runApp(const SafeCampusPrototypeApp());
}

class SafeCampusPrototypeApp extends StatefulWidget {
  const SafeCampusPrototypeApp({super.key});

  @override
  State<SafeCampusPrototypeApp> createState() => _SafeCampusPrototypeAppState();
}

class _SafeCampusPrototypeAppState extends State<SafeCampusPrototypeApp> {
  bool _isArabic = true;

  void _toggleLanguage() {
    setState(() {
      _isArabic = !_isArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Campus - BAU',
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: _isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      theme: ThemeData(
        primaryColor: const Color(0xFF135233),
        scaffoldBackgroundColor: const Color(0xFFF4F7F5),
        fontFamily: 'Arial',
      ),
      home: EnhancedLoginScreen(
        isArabic: _isArabic,
        onToggleLanguage: _toggleLanguage,
      ),
    );
  }
}

class EnhancedLoginScreen extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onToggleLanguage;

  const EnhancedLoginScreen({
    super.key,
    required this.isArabic,
    required this.onToggleLanguage,
  });

  @override
  State<EnhancedLoginScreen> createState() => _EnhancedLoginScreenState();
}

class _EnhancedLoginScreenState extends State<EnhancedLoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late bool _isAr;
  int _selectedRole = 0; // 0: طالب, 1: صيانة, 2: مشرف

  @override
  void initState() {
    super.initState();
    _isAr = widget.isArabic;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _switchLang() {
    setState(() {
      _isAr = !_isAr;
    });
    widget.onToggleLanguage();
  }

  String t(String ar, String en) => _isAr ? ar : en;

  void _handleLogin() {
    String enteredName = _nameController.text.trim();
    String enteredId = _idController.text.trim();

    if (enteredName.isEmpty || enteredId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t('الرجاء إدخال الاسم والرقم الجامعي / الوظيفي', 'Please enter your Name and ID')),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // التوجيه الذكي حسب البوابة المختارة
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (_selectedRole == 0) {
            // بوابـة الطـالب
            return StudentHomeScreen(
              userName: enteredName,
              userRole: 'student',
              isArabic: _isAr,
            );
          } else if (_selectedRole == 1) {
            // بوابـة فريـق الصيـانة
            return StaffDashboardScreen(
              userName: enteredName,
              userRole: 'worker',
              isArabic: _isAr,
            );
          } else {
            // بوابـة مشـرف السـلامة
            return SupervisorDashboardScreen(
              userName: enteredName,
              isArabic: _isAr,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String idLabel = _selectedRole == 0
        ? t('الرقم الجامعي', 'Student ID')
        : t('الرقم الوظيفي / اسم المستخدم', 'Employee ID / Username');

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xFF0E4228), Color(0xFF1A5D3A), Color(0xFF287D50)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_user, color: Color(0xFFD4AF37), size: 16),
                            const SizedBox(width: 6),
                            Text(t('البوابة الموحدة', 'Unified Portal'), style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: _switchLang,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.language, color: Color(0xFF1A5D3A), size: 18),
                              const SizedBox(width: 6),
                              Text(
                                _isAr ? 'English' : 'عربي',
                                style: const TextStyle(color: Color(0xFF1A5D3A), fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFD4AF37), width: 2.5),
                    ),
                    child: const Icon(Icons.account_balance, size: 38, color: Color(0xFF1A5D3A)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t('جامعة البلقاء التطبيقية', 'Al-Balqa Applied University'),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    t('نظام السلامة وإدارة المخاطر (Safe Campus)', 'University Safety & Hazard System'),
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A5D3A).withOpacity(0.08),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F4F2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              _buildRoleTab(0, t('طالب', 'Student'), Icons.school_outlined),
                              _buildRoleTab(1, t('صيانة', 'Worker'), Icons.engineering_outlined),
                              _buildRoleTab(2, t('مشرف', 'Supervisor'), Icons.admin_panel_settings_outlined),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          t('الاسم الكامل', 'Full Name'),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: t('أدخل اسمك (مثال: براءة)', 'Enter your name (e.g. Bara\'a)'),
                            hintStyle: const TextStyle(color: Color(0xFFA3B0A8), fontSize: 13),
                            prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF1A5D3A)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAF9),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFDDE5E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF1A5D3A), width: 1.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          idLabel,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _idController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: _selectedRole == 0 ? '3230100000' : '10452',
                            hintStyle: const TextStyle(color: Color(0xFFA3B0A8), fontSize: 13),
                            prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF1A5D3A)),
                            filled: true,
                            fillColor: const Color(0xFFF8FAF9),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFDDE5E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF1A5D3A), width: 1.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        Text(
                          t('كلمة المرور', 'Password'),
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1A2E22)),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            hintStyle: const TextStyle(color: Color(0xFFA3B0A8)),
                            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1A5D3A)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: const Color(0xFF6B7C72),
                                size: 20,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF8FAF9),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFDDE5E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFF1A5D3A), width: 1.5),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _handleLogin,
                            icon: const Icon(Icons.login_rounded),
                            label: Text(
                              t('تسجيل الدخول', 'Login'),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A5D3A),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
        ],
      ),
    );
  }

  Widget _buildRoleTab(int index, String label, IconData icon) {
    bool isSelected = _selectedRole == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1A5D3A) : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : const Color(0xFF5C6E63)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF5C6E63),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}