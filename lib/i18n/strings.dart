import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/locale_controller.dart';

/// Translates [source] (the English UI copy, used verbatim as the lookup
/// key) to Arabic when the app's [LocaleController] is set to `ar`;
/// returns [source] unchanged otherwise, and unchanged as a safe fallback
/// for any string not yet in [_ar] — so wiring this in never breaks a
/// screen, it just leaves that one string in English until translated.
String tr(BuildContext context, String source) {
  final isArabic = context.watch<LocaleController>().isArabic;
  if (!isArabic) return source;
  return _ar[source] ?? source;
}

const Map<String, String> _ar = {
  // Bottom navigation — customer
  'Home': 'الرئيسية',
  'Orders': 'الطلبات',
  'Cart': 'السلة',
  'Profile': 'الملف الشخصي',

  // Bottom navigation — partner / driver / admin
  'Dashboard': 'لوحة التحكم',
  'Jobs': 'المهام',
  'Earnings': 'الأرباح',
  'History': 'السجل',
  'Capacity': 'الطاقة الاستيعابية',
  'Pricing': 'الأسعار',
  'Customers': 'العملاء',
  'Partners': 'الشركاء',
  'Drivers': 'السائقون',
  'Disputes': 'النزاعات',
  'Overview': 'نظرة عامة',
  'Settings': 'الإعدادات',
  'Notifications': 'الإشعارات',
  'Analytics': 'التحليلات',
  'Business': 'الأعمال',
  'Today': 'اليوم',

  // Common actions
  'Back': 'رجوع',
  'Save': 'حفظ',
  'Cancel': 'إلغاء',
  'Continue': 'متابعة',
  'Apply': 'تطبيق',
  'Reset': 'إعادة تعيين',
  'Call': 'اتصال',
  'Message': 'رسالة',
  'Search': 'بحث',
  'Edit': 'تعديل',
  'Delete': 'حذف',
  'Confirm': 'تأكيد',
  'Done': 'تم',
  'Next': 'التالي',
  'Skip': 'تخطي',
  'Retry': 'إعادة المحاولة',
  'Share': 'مشاركة',
  'Add to Cart': 'أضف إلى السلة',
  'Checkout': 'إتمام الطلب',
  'View All': 'عرض الكل',
  'Filter & Sort': 'تصفية وترتيب',
  'Filter': 'تصفية',
  'Sort': 'ترتيب',

  // Settings screen
  'Language': 'اللغة',
  'English': 'الإنجليزية',
  'Arabic': 'العربية',
  'Appearance': 'المظهر',
  'Dark Mode': 'الوضع الداكن',
  'Light': 'فاتح',
  'Dark': 'داكن',
  'System': 'النظام',
  'Account': 'الحساب',
  'Addresses': 'العناوين',
  'Payment Methods': 'طرق الدفع',
  'Saved Items': 'العناصر المحفوظة',
  'Order History': 'سجل الطلبات',
  'Offers': 'العروض',
  'Help Center': 'مركز المساعدة',
  'Contact Us': 'اتصل بنا',
  'About': 'حول التطبيق',
  'Sign Out': 'تسجيل الخروج',
  'Log Out': 'تسجيل الخروج',
  'Edit Profile': 'تعديل الملف الشخصي',
  'Report an Issue': 'الإبلاغ عن مشكلة',

  // Auth flow
  'Welcome': 'مرحبًا',
  'Welcome Back': 'مرحبًا بعودتك',
  'Get Started': 'ابدأ الآن',
  'Sign In': 'تسجيل الدخول',
  'Sign Up': 'إنشاء حساب',
  'Log In': 'تسجيل الدخول',
  'Create Account': 'إنشاء حساب',
  'Forgot Password?': 'نسيت كلمة المرور؟',
  'Reset Password': 'إعادة تعيين كلمة المرور',
  'Email': 'البريد الإلكتروني',
  'Password': 'كلمة المرور',
  'Phone Number': 'رقم الهاتف',
  'Full Name': 'الاسم الكامل',
  'Verify': 'تحقق',
  'Verification Code': 'رمز التحقق',
  'Continue with Google': 'المتابعة عبر جوجل',
  'Continue with Apple': 'المتابعة عبر آبل',
  'Continue with Phone': 'المتابعة برقم الهاتف',
  'Already have an account?': 'لديك حساب بالفعل؟',
  "Don't have an account?": 'ليس لديك حساب؟',

  // Home / services
  'Our Services': 'خدماتنا',
  'Partners Near You': 'الشركاء بالقرب منك',
  'Wash & Fold': 'غسيل وطي',
  'Dry Cleaning': 'تنظيف جاف',
  'Ironing': 'كي الملابس',
  'Special Care': 'عناية خاصة',
  'Book a Service': 'احجز خدمة',
  'Schedule Pickup': 'جدولة الاستلام',
  'Track Order': 'تتبع الطلب',
  'Open Now': 'مفتوح الآن',
  'Closed': 'مغلق',
  'Reviews': 'التقييمات',
  'Services': 'الخدمات',
  'About Us': 'من نحن',

  // Order / tracking
  'Order Confirmed': 'تم تأكيد الطلب',
  'Picked Up': 'تم الاستلام',
  'In Cleaning': 'قيد التنظيف',
  'Out for Delivery': 'خارج للتوصيل',
  'Delivered': 'تم التوصيل',
  'Your delivery partner': 'شريك التوصيل الخاص بك',
  'Calling...': 'جارٍ الاتصال...',

  // Settings screen (extra)
  'App': 'التطبيق',
  'Light, dark or match system': 'فاتح أو داكن أو حسب النظام',
  'Push Notifications': 'الإشعارات الفورية',
  'Order updates and offers': 'تحديثات الطلبات والعروض',
  'Change Password': 'تغيير كلمة المرور',
  'Update your account password': 'تحديث كلمة مرور حسابك',
  'Sign out of this device': 'تسجيل الخروج من هذا الجهاز',
  'Delete Account': 'حذف الحساب',
  'Permanently delete your account and data': 'حذف حسابك وبياناتك نهائيًا',
  'Troubleshooting': 'استكشاف الأخطاء وإصلاحها',
  'Connection Status': 'حالة الاتصال',
  'Report a Technical Issue': 'الإبلاغ عن مشكلة تقنية',
  'Clear Order History': 'مسح سجل الطلبات',
  'Log out?': 'تسجيل الخروج؟',
  "You'll need to sign back in to book pickups.":
      'ستحتاج لتسجيل الدخول مرة أخرى لحجز عمليات الاستلام.',

  // Roles
  'Customer': 'عميل',
  'Partner': 'شريك',
  'Driver': 'سائق',
  'Admin': 'مسؤول',
};
