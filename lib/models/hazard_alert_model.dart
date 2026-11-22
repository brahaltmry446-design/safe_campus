import 'package:flutter/material.dart';

enum HazardType {
  fire,
  electrical,
  medical,
  security,
  facility,
  other;

  static HazardType fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'fire':
      case 'حريق':
        return HazardType.fire;
      case 'electrical':
      case 'electric':
      case 'كهرباء':
      case 'خطر كهربائي':
        return HazardType.electrical;
      case 'medical':
      case 'health':
      case 'طبي':
      case 'صحي':
        return HazardType.medical;
      case 'security':
      case 'أمني':
        return HazardType.security;
      case 'facility':
      case 'مرفق':
        return HazardType.facility;
      default:
        return HazardType.other;
    }
  }

  String get arabicLabel {
    switch (this) {
      case HazardType.fire:
        return 'تنبيه حريق';
      case HazardType.electrical:
        return 'خطر كهربائي';
      case HazardType.medical:
        return 'حالة طبية طارئة';
      case HazardType.security:
        return 'تنبيه أمني';
      case HazardType.facility:
        return 'خطر في المرفق';
      case HazardType.other:
        return 'تنبيه خطر';
    }
  }

  IconData get icon {
    switch (this) {
      case HazardType.fire:
        return Icons.local_fire_department_rounded;
      case HazardType.electrical:
        return Icons.bolt_rounded;
      case HazardType.medical:
        return Icons.medical_services_rounded;
      case HazardType.security:
        return Icons.shield_rounded;
      case HazardType.facility:
        return Icons.warning_amber_rounded;
      case HazardType.other:
        return Icons.notification_important_rounded;
    }
  }

  String get defaultInstruction {
    switch (this) {
      case HazardType.fire:
        return 'حافظ على هدوئك، لا تستخدم المصاعد، وتوجه فوراً نحو أقرب مخرج طوارئ.';
      case HazardType.electrical:
        return 'ابتعد عن مصدر الكهرباء أو الأسلاك المكشوفة ولا تلمس أي معدات أو مياه قريبة.';
      case HazardType.medical:
        return 'أفسح المجال لفرق الاستجابة ولا تحرك المصاب إلا عند الضرورة القصوى.';
      case HazardType.security:
        return 'التزم بتعليمات السلامة وابتعد عن منطقة الخطر حتى تأكيد الأمان.';
      case HazardType.facility:
        return 'تجنب المنطقة المحددة وبلّغ المشرف أو الجهة المختصة بأي مستجدات.';
      case HazardType.other:
        return 'انتبه للتعليمات المعلنة وتجنب الاقتراب من موقع الخطر.';
    }
  }
}

enum AlertSeverity {
  critical,
  high,
  medium,
  low;

  static AlertSeverity fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'critical':
      case 'urgent':
      case 'عاجل':
      case 'حرج':
        return AlertSeverity.critical;
      case 'high':
      case 'مرتفع':
        return AlertSeverity.high;
      case 'medium':
      case 'متوسط':
        return AlertSeverity.medium;
      case 'low':
      case 'منخفض':
        return AlertSeverity.low;
      default:
        return AlertSeverity.high;
    }
  }

  String get arabicLabel {
    switch (this) {
      case AlertSeverity.critical:
        return 'عاجل جداً';
      case AlertSeverity.high:
        return 'مرتفع';
      case AlertSeverity.medium:
        return 'متوسط';
      case AlertSeverity.low:
        return 'منخفض';
    }
  }

  Color get color {
    switch (this) {
      case AlertSeverity.critical:
        return const Color(0xFFD32F2F);
      case AlertSeverity.high:
        return const Color(0xFFE65100);
      case AlertSeverity.medium:
        return const Color(0xFFF9A825);
      case AlertSeverity.low:
        return const Color(0xFF1976D2);
    }
  }

  bool get isUrgent => this == AlertSeverity.critical || this == AlertSeverity.high;
}

class HazardAlertModel {
  final String id;
  final String title;
  final String description;
  final HazardType hazardType;
  final AlertSeverity severity;
  final String building;
  final String? locationDetails;
  final String instructions;
  final DateTime createdAt;
  final bool isAcknowledged;

  HazardAlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.hazardType,
    required this.severity,
    required this.building,
    this.locationDetails,
    String? instructions,
    required this.createdAt,
    this.isAcknowledged = false,
  }) : instructions = (instructions != null && instructions.trim().isNotEmpty)
      ? instructions.trim()
      : hazardType.defaultInstruction;

  factory HazardAlertModel.fromJson(Map<String, dynamic> json) {
    final parsedType = HazardType.fromString(
      json['hazardType']?.toString() ?? json['hazard_type']?.toString() ?? json['type']?.toString(),
    );

    final parsedDate = DateTime.tryParse(
      json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
    ) ??
        DateTime.now();

    return HazardAlertModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      title: (json['title']?.toString().trim().isNotEmpty == true)
          ? json['title'].toString().trim()
          : parsedType.arabicLabel,
      description: json['description']?.toString() ?? json['message']?.toString() ?? '',
      hazardType: parsedType,
      severity: AlertSeverity.fromString(json['severity']?.toString()),
      building: json['building']?.toString() ?? 'غير محدد',
      locationDetails: json['locationDetails']?.toString() ?? json['location_details']?.toString(),
      instructions: json['instructions']?.toString(),
      createdAt: parsedDate,
      isAcknowledged: json['isAcknowledged'] == true || json['is_acknowledged'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'hazardType': hazardType.name,
      'severity': severity.name,
      'building': building,
      'locationDetails': locationDetails,
      'instructions': instructions,
      'createdAt': createdAt.toIso8601String(),
      'isAcknowledged': isAcknowledged,
    };
  }

  HazardAlertModel copyWith({
    String? id,
    String? title,
    String? description,
    HazardType? hazardType,
    AlertSeverity? severity,
    String? building,
    String? locationDetails,
    String? instructions,
    DateTime? createdAt,
    bool? isAcknowledged,
  }) {
    return HazardAlertModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      hazardType: hazardType ?? this.hazardType,
      severity: severity ?? this.severity,
      building: building ?? this.building,
      locationDetails: locationDetails ?? this.locationDetails,
      instructions: instructions ?? this.instructions,
      createdAt: createdAt ?? this.createdAt,
      isAcknowledged: isAcknowledged ?? this.isAcknowledged,
    );
  }
}