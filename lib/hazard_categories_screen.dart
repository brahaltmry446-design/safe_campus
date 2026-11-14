import 'package:flutter/material.dart';

// كلاس بسيط لتمثيل بيانات كل فئة خطر بوضوح دون تعقيد
class HazardCategory {
  final String titleAr;
  final String titleEn;
  final IconData icon;
  final Color color;

  const HazardCategory({
    required this.titleAr,
    required this.titleEn,
    required this.icon,
    required this.color,
  });
}

class HazardCategoriesScreen extends StatefulWidget {
  final bool isArabic;

  const HazardCategoriesScreen({super.key, this.isArabic = true});

  @override
  State<HazardCategoriesScreen> createState() => _HazardCategoriesScreenState();
}

class _HazardCategoriesScreenState extends State<HazardCategoriesScreen> {
  int? _selectedIndex;

  final List<HazardCategory> _categories = const [
    HazardCategory(
      titleAr: 'كهرباء',
      titleEn: 'Electrical',
      icon: Icons.bolt_rounded,
      color: Color(0xFFEAB308),
    ),
    HazardCategory(
      titleAr: 'حريق',
      titleEn: 'Fire Hazard',
      icon: Icons.local_fire_department_rounded,
      color: Color(0xFFDC2626),
    ),
    HazardCategory(
      titleAr: 'أرضية زلقة',
      titleEn: 'Slippery Floor',
      icon: Icons.warning_amber_rounded,
      color: Color(0xFFD97706),
    ),
    HazardCategory(
      titleAr: 'مختبرات',
      titleEn: 'Laboratories',
      icon: Icons.science_rounded,
      color: Color(0xFF2563EB),
    ),
    HazardCategory(
      titleAr: 'أعطال مبانٍ',
      titleEn: 'Building Faults',
      icon: Icons.domain_disabled_rounded,
      color: Color(0xFF4B5563),
    ),
    HazardCategory(
      titleAr: 'مخاطر صحية',
      titleEn: 'Health Hazards',
      icon: Icons.health_and_safety_rounded,
      color: Color(0xFF059669),
    ),
    HazardCategory(
      titleAr: 'مخارج طوارئ',
      titleEn: 'Emergency Exits',
      icon: Icons.exit_to_app_rounded,
      color: Color(0xFF991B1B),
    ),
    HazardCategory(
      titleAr: 'أخرى',
      titleEn: 'Other',
      icon: Icons.more_horiz_rounded,
      color: Color(0xFF1A5D3A),
    ),
  ];

  String t(String ar, String en) => widget.isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
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
            t('فئات المخاطر', 'Hazard Categories'),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  t('اختر نوع الخطر الذي تريد الإبلاغ عنه', 'Select the type of hazard you want to report'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A5D52),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: _categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.15,
                    ),
                    itemBuilder: (context, index) {
                      final item = _categories[index];
                      final bool isSelected = _selectedIndex == index;
                      final String title = widget.isArabic ? item.titleAr : item.titleEn;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFE3ECE6) : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF1A5D3A) : const Color(0xFFE5ECE8),
                              width: isSelected ? 2.2 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: item.color.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(item.icon, color: item.color, size: 30),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: const Color(0xFF1A2E22),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _selectedIndex == null
                        ? null
                        : () {
                      final selectedItem = _categories[_selectedIndex!];
                      final selectedTitle = widget.isArabic ? selectedItem.titleAr : selectedItem.titleEn;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(t('تم اختيار: $selectedTitle', 'Selected: $selectedTitle')),
                          backgroundColor: const Color(0xFF1A5D3A),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A5D3A),
                      disabledBackgroundColor: const Color(0xFFCBD5CE),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      t('متابعة', 'Continue'),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}