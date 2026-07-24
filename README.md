# 🛒 السوق التجاري - Marketplace Mobile App

تطبيق سوق تجاري متكامل لربط البائعين والمشترين، مبني باستخدام Flutter و Firebase.

## 📱 المميزات

- 🔐 مصادقة متعددة (بريد إلكتروني، Google، Apple، Facebook)
- 🏪 إدارة المتاجر والمنتجات
- 🔍 بحث متقدم وتصفية
- 🛒 سلة تسوق وإدارة الطلبات
- 💳 دفع إلكتروني آمن (Stripe)
- 📍 تحديد الموقع الجغرافي
- 🔔 إشعارات فورية
- 📊 لوحة تحكم للبائعين
- 🌙 وضع داكن

## 🏗 البنية التقنية

### الواجهة الأمامية (Frontend)
- **Flutter** - إطار العمل
- **BLoC Pattern** - إدارة الحالة
- **Go Router** - التنقل
- **Firebase SDK** - الخدمات السحابية

### الواجهة الخلفية (Backend)
- **Firebase Authentication** - المصادقة
- **Cloud Firestore** - قاعدة البيانات
- **Cloud Functions** - الدوال السحابية
- **Firebase Storage** - تخزين الملفات
- **Firebase Messaging** - الإشعارات

## 🚀 التشغيل

### المتطلبات
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Firebase CLI
- Node.js >= 18

### خطوات التشغيل

1. **استنساخ المشروع**
   ```bash
   git clone <repository-url>
   cd marketplace_app
   ```

2. **تثبيت الحزم**
   ```bash
   flutter pub get
   ```

3. **إعداد Firebase**
   - أنشئ مشروع Firebase جديد
   - فعّل Authentication, Firestore, Storage, Functions
   - حمّل ملف `google-services.json` (Android) و `GoogleService-Info.plist` (iOS)

4. **تشغيل التطبيق**
   ```bash
   flutter run
   ```

### تشغيل الواجهة الخلفية

```bash
cd backend/functions
npm install
npm run build
firebase emulators:start --only functions
```

## 📁 هيكل المشروع

```
marketplace_app/
├── lib/
│   ├── core/           # الثوابت والتصميم والأدوات
│   ├── data/           # النماذج والمستودعات ومصادر البيانات
│   ├── domain/         # الكيانات وحالات الاستخدام
│   ├── presentation/   # الشاشات والويدجت وBLoCs
│   └── services/       # الخدمات الخارجية
├── assets/             # الصور والأيقونات والخطوط
├── test/               # الاختبارات
└── backend/
    ├── functions/        # دوال Firebase
    ├── config/          # إعدادات البيئة
    └── scripts/         # سكربتات المساعدة
```

## 🔒 الأمان

- تشفير البيانات أثناء النقل (TLS 1.3)
- قواعد Firestore للتحكم في الوصول
- مصادقة JWT مع TTL قصير
- عدم تخزين بيانات البطاقات (Tokenization)

## 📄 الترخيص

هذا المشروع مرخص بموجب MIT License.

## 👥 المساهمة

نرحب بمساهماتكم! يرجى فتح Issue أو Pull Request.

---

**تم التطوير بواسطة فريق السوق التجاري** 🚀
