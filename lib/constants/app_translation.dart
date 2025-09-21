import 'package:get/get.dart';

class AppTranslations extends Translations {
  static const String trFlag = '🇹🇷';
  static const String enFlag = '🇺🇸';

  // Dil kodlarını ve flag'leri listelemek istersen
  static final supportedLanguages = [
    {'code': 'tr', 'name': 'Turkish', 'nativeName': 'Türkçe', 'flag': trFlag},
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': enFlag},
    // Diğer dillerin kodları, adları, flagleri de aynı şekilde eklenebilir.
  ];

  static Map<String, String> kPaywallI18nEn = {
    // Top bar
    "paywall.retry": "Try Again",
    'paywall.refresh': 'Refresh',

    // Hero
    'paywall.title': 'Unlock Montessori Learning — Safely and Playfully',
    'paywall.subtitle':
        'Support your child’s natural curiosity with ad-free activities crafted for self-paced growth.',

    // Features (carousel)
    'paywall.feature.1':
        'Montessori-inspired activities for math, language, daily life, and sensorial.',
    'paywall.feature.2':
        'Build independent thinking and problem-solving through hands-on play.',
    'paywall.feature.3': 'Safe, ad-free, and kid-friendly interface.',
    'paywall.feature.4':
        'Designed for parents and teachers to support self-paced learning.',

    // Plans (titles + subtitles)
    'paywall.plan.monthly': 'Monthly Plan',
    'paywall.plan.monthly.subtitle':
        'Includes a 7 day free trial. Auto-renews unless canceled.',
    'paywall.plan.yearly': 'Yearly Plan',
    'paywall.plan.yearly.subtitle':
        'Best value • 14 day free trial • Cancel anytime.',

    // Prices (dummy strings in your code)
    'paywall.price.monthly': r'$2.99 / Monthly',
    'paywall.price.yearly': r'$29.99 / Yearly',

    // Free trial pill
    'paywall.trial.pill': '7-Day Free Trial',

    // CTA + restore + info
    'paywall.cta': 'Continue to Premium',
    'paywall.restore': 'Restore Purchases',
    'paywall.about': 'About Subscription',

    // Snackbars (dummy)
    'paywall.snackbar.selected': 'Selected plan: {price} (dummy)',
    'paywall.snackbar.restore': 'Purchases restored successfully',

    // Footer links
    'paywall.terms': 'Terms of Service',
    'paywall.privacy': 'Privacy Policy',

    // Parent Gate dialog
    'paywall.parent_gate.title': 'Parent Check',
    'paywall.parent_gate.prompt': 'Please enter the answer: {a} + {b} = ?',
    'paywall.parent_gate.answer_hint': 'Answer',
    'paywall.parent_gate.note':
        'This step helps ensure an adult is managing purchases.',
    'paywall.parent_gate.cancel': 'Cancel',
    'paywall.parent_gate.continue': 'Continue',

    // Info dialog
    'paywall.info.title': 'About Subscription',
    'paywall.info.body':
        'Subscriptions renew automatically unless canceled at least 24 hours before the end of the current period. '
            'A 7-day free trial is included. After the trial, the plan renews at the price shown (Monthly: 2.99\$, Yearly: 29.99\$). '
            'Manage or cancel your subscription in your account settings.',
    "paywall.snackbar.no_product": "Please select product",
    "paywall.snackbar.purchase_failed": "Purchase failed",
    "paywall.snackbar.purchase_success": "Purchase success",
  };

  static Map<String, String> kPaywallI18nTr = {
    "paywall.snackbar.purchase_success": "Satın alım başarılı",
    "paywall.retry": "Tekrar Dene",
    "paywall.snackbar.purchase_failed": "Satın alım başarısız",
    "paywall.snackbar.no_product": "Lütfen ürün seçin",
    // Top bar
    'paywall.refresh': 'Yenile',

    // Hero
    'paywall.title': 'Montessori Öğrenimini Güvenle ve Eğlenceyle Aç',
    'paywall.subtitle':
        'Çocuğunuzun doğal merakını, kendi hızında gelişim için tasarlanmış reklamsız aktivitelerle destekleyin.',

    // Features (carousel)
    'paywall.feature.1':
        'Matematik, dil, günlük yaşam ve duyu alanlarında Montessori esinli aktiviteler.',
    'paywall.feature.2':
        'Uygulamalı oyunlarla bağımsız düşünme ve problem çözme becerilerini geliştirin.',
    'paywall.feature.3': 'Güvenli, reklamsız ve çocuk dostu arayüz.',
    'paywall.feature.4':
        'Ebeveynler ve öğretmenler için, çocuğun kendi hızında öğrenimini destekleyen tasarım.',

    // Plans (titles + subtitles)
    'paywall.plan.monthly': 'Aylık Plan',
    'paywall.plan.monthly.subtitle':
        '7 günlük ücretsiz deneme içerir. İptal edilmediği sürece otomatik yenilenir.',
    'paywall.plan.yearly': 'Yıllık Plan',
    'paywall.plan.yearly.subtitle':
        'En avantajlı • 14 gün ücretsiz deneme • İstediğiniz zaman iptal edin.',

    // Prices (dummy strings in your code)
    'paywall.price.monthly': r'$2.99 / Aylık',
    'paywall.price.yearly': r'$29.99 / Yıllık',

    // Free trial pill
    'paywall.trial.pill': '7 Gün Ücretsiz Deneme',

    // CTA + restore + info
    'paywall.cta': 'Premium’a Geç',
    'paywall.restore': 'Satın Alımları Geri Yükle',
    'paywall.about': 'Abonelik Hakkında',

    // Snackbars (dummy)
    'paywall.snackbar.selected': 'Seçilen plan: {price} (deneme)',
    'paywall.snackbar.restore': 'Satın alımları geri yükle (deneme)',

    // Footer links
    'paywall.terms': 'Hizmet Şartları',
    'paywall.privacy': 'Gizlilik Politikası',

    // Parent Gate dialog
    'paywall.parent_gate.title': 'Ebeveyn Doğrulaması',
    'paywall.parent_gate.prompt': 'Lütfen yanıtı girin: {a} + {b} = ?',
    'paywall.parent_gate.answer_hint': 'Yanıt',
    'paywall.parent_gate.note':
        'Bu adım satın almaların bir yetişkin tarafından yönetildiğini doğrulamaya yardımcı olur.',
    'paywall.parent_gate.cancel': 'İptal',
    'paywall.parent_gate.continue': 'Devam Et',

    // Info dialog
    'paywall.info.title': 'Abonelik Hakkında',
    'paywall.info.body':
        'Abonelikler, mevcut dönem bitmeden en az 24 saat önce iptal edilmediği sürece otomatik yenilenir. '
            '7 günlük ücretsiz deneme dahildir. Deneme süresinin ardından plan, gösterilen fiyattan yenilenir (Aylık: 144₺, Yıllık: 1479₺). '
            'Aboneliğinizi hesap ayarlarınızdan yönetebilir veya iptal edebilirsiniz.',
  };

// Türkçe Çeviriler (tr.dart dosyanıza ekleyin)
  static Map<String, String> trTranslations = {
    // Trial page translations
    'trial.welcome_title': 'Premium Deneyimine\nHoş Geldiniz',
    'trial.welcome_subtitle':
        'Tüm premium özellikleri keşfedin ve deneyiminizi bir üst seviyeye taşıyın.',

    'trial.card_title': '{days} Gün Ücretsiz Deneme',
    'trial.card_subtitle': 'İstediğiniz zaman iptal edebilirsiniz',

    'trial.start_button': 'Ücretsiz Dene',
    'trial.subscribe_button': 'Planları Görüntüle',

    'trial.footer_info':
        'Ücretsiz deneme süresi sonunda otomatik olarak ücretlendirme başlar. İstediğiniz zaman iptal edebilirsiniz.',
    'trial.restore': 'Satın Alımları Geri Yükle',

    'trial.not_available': 'Ücretsiz deneme şu anda mevcut değil',
    'trial.start_failed': 'Ücretsiz deneme başlatılamadı',

    'error.loading_products': 'Ürünler yüklenemedi',
    'retry': 'Tekrar Dene',
  };

// İngilizce Çeviriler (en.dart dosyanıza ekleyin)
  static Map<String, String> enTranslations = {
    // Trial page translations
    'trial.welcome_title': 'Welcome to\nPremium Experience',
    'trial.welcome_subtitle':
        'Discover all premium features and take your experience to the next level.',

    'trial.card_title': '{days} Days Free Trial',
    'trial.card_subtitle': 'Cancel anytime',

    'trial.start_button': 'Start Free Trial',
    'trial.subscribe_button': 'View Plans',

    'trial.footer_info':
        'Automatic billing starts after free trial period. You can cancel anytime.',
    'trial.restore': 'Restore Purchases',

    'trial.not_available': 'Free trial is not available right now',
    'trial.start_failed': 'Failed to start free trial',

    'error.loading_products': 'Failed to load products',
    'retry': 'Retry',
  };

  static Map<String, String> trTrialTranslations = {
    // Trial plan
    'paywall.plan.trial': 'Ücretsiz Deneme',
    'paywall.plan.trial.subtitle': 'Sonra otomatik olarak aylık plana geçer',
    'paywall.plan.trial.price': 'Ücretsiz',
    'paywall.plan.trial.badge': 'Popüler',

    // CTA button
    'paywall.cta.trial': '{days} Gün Ücretsiz Başlat',

    // Trial pill
    'paywall.trial.pill': '{days} gün ücretsiz',

    // Other needed keys
    'paywall.retry': 'Tekrar Dene',
    'paywall.snackbar.no_product': 'Seçili ürün bulunamadı',
    'paywall.snackbar.restore_failed': 'Geri yükleme başarısız',
  };

  static Map<String, String> enTrialTranslations = {
    // Trial plan
    'paywall.plan.trial': 'Free Trial',
    'paywall.plan.trial.subtitle':
        'Then automatically continues to monthly plan',
    'paywall.plan.trial.price': 'Free',
    'paywall.plan.trial.badge': 'Popular',

    // CTA button
    'paywall.cta.trial': 'Start {days} Days Free',

    // Trial pill
    'paywall.trial.pill': '{days} days free',

    // Other needed keys
    'paywall.retry': 'Retry',
    'paywall.snackbar.no_product': 'Selected product not found',
    'paywall.snackbar.restore_failed': 'Restore failed',
  };

  @override
  Map<String, Map<String, String>> get keys => {
        'tr': {
          "paywall.plan.yearly.badge": "Popüler",
          "rest_pass_send":
              "Şifre sıfırlama isteği mail adresinize gönderildi.",
          "rest_pass_not_send":
              "Şifre sıfırlama isteği gönderilemedi. Lütfen daha sonra tekrar deneyiniz.",
          "wrong_password": "Hatalı kullanıcı adı ya da şifre",
          "user_not_found": "Kullanıcı Bulunamadı",
          "fail_to_login": "Giriş Yapılamadı.",
          "select_rating": "Lütfen beğeni durumunu seçin.",
          "thanks_feedback": "Geri bildiriminiz için teşekkür ederiz.",
          "like": "Beğendim",
          "dislike": "Beğenmedim",
          "feedback": "Geri Bildirim",
          "feedback_desc": "Açıklama (opsiyonel)",
          "give_up": "Vazgeç",
          "send": "Gönder",
          "write_your_thoughts": "Düşüncelerini kısaca yaz...",
          "account_deleted": "Hesabınız Silindi.",
          "delete_account": "Hesabı Sil",
          "activity_updated": "Aktiviteler güncellendi",
          "sn_ok": "TAMAM",
          "sn_success": "BAŞARILI",
          "sn_warn": "UYARI",
          "sn_error": "HATA",
          "fill_required_fields": "Lütfen gerekli alanları doldurunuz",
          "reset_password": "Şifremi Sıfırla",
          "forgot_password": "Şifremi Unuttum",
          // Auth & Common
          "go": "Git",
          "day": "gün",
          "get_started_button": "Başla",
          "continue_or_start": "Devam Et",
          "alreadyHaveAccount": "Zaten hesabın var mı? Giriş Yap",
          "register": "Kayıt Ol",
          "donthaveAccount": "Hesabın yok mu? Kayıt Ol",
          "loginApple": "Apple ile Giriş",
          "loginGoogle": "Google ile Giriş",
          "loginGuest": "Misafir Girişi",
          "or": "veya",
          "login": "Giriş Yap",
          "password": "Şifre",
          "email": "E Posta",
          'back': 'Geri',
          'next': 'İleri',
          'cancel': 'İptal',
          'save': 'Kaydet',
          'delete': 'Sil',
          'edit': 'Düzenle',
          'close': 'Kapat',
          'previous': 'Önceki',
          'done': 'Tamam',
          'skip': 'Geç',
          'loading': 'Yükleniyor ...',
          'error': 'Hata',
          'retry': 'Tekrar Dene',
          "log_out": "Çıkış Yap",
          "made_with": "Gelişen zihinler için 🌱 ile üretilmiştir",

          // Navigation
          'home': 'Ana Sayfa',
          'calendar': 'Takvim',
          'badges': 'Rozetler',
          'favorites': 'Favoriler',
          'guide': 'Rehber',
          'settings': 'Ayarlar',

          // Onboarding
          'welcome': 'Hoş Geldiniz!',
          'enterName': 'Adınızı girin',
          'continueAsGuest': 'Misafir olarak devam et',
          "what_call_you": "Size nasıl hitap edelim?",
          "enter_name_hint": "Adınız",
          "choose_language": "Dil Seç",
          "select_language": "Tercih ettiğiniz dili seçin",
          "child_age_group": "Çocuğun Yaş Grubu",
          "child_age_help":
              "Bu, yaşa uygun etkinlikleri göstermemize yardımcı olur.",
          "daily_montessori": "Çocuğunuz için günlük Montessori etkinlikleri",
          "get_started_anytime": "Her zaman.\nHer yerde.\nİnternet gerekmez.",
          "get_started_subtitle": "Gerçek Montessori etkinlikleri.",
          "get_started_title": "Başlayalım",

          // Home
          'goodMorning': 'Günaydın',
          "todays_montissoris_ready": "Bugünün Montessori etkinlikleri hazır",
          'todaysActivities': 'Bugünün Aktiviteleri',
          'monthlyProgress': 'Aylık İlerleme',
          'newSetUnlocks': 'Her gün yeni bir Montessori seti açılır',
          'startActivity': 'Aktiviteyi Başlat',
          'montessoriTip': 'Montessori İpucu',

          // Activity Detail
          "skills": "Beceriler",
          "materials_needed": "Gerekli Malzemeler",
          "step_by_step": "Adım Adım Talimatlar",
          "activity_duration": "Süre: 15-20 Dakika",
          "rate_activity": "Aktiviteyi Oyla",
          'materialsNeeded': 'Gerekli Malzemeler',
          'stepByStep': 'Adım Adım Talimatlar',
          'duration': 'Süre',
          'markAsDone': 'Tamamlandı Olarak İşaretle',
          'addToFavorites': 'Favorilere Ekle',
          'downloadPDF': 'PDF İndir',
          'completed': 'Tamamlandı!',
          'pending': 'Beklemede',
          "activity": "Aktivite",
          "no_activity_found": "Aktivite Bulunamadı.",

          // Calendar
          "activity_calendar": "Etkinlik Takvimi",
          "view_progress":
              "Geçmiş etkinlikleri görüntüleyin ve ilerlemenizi takip edin.",
          'activityCalendar': 'Aktivite Takvimi',
          'viewPastActivities':
              'Geçmiş aktiviteleri görüntüle ve ilerlemenizi takip edin',
          'today': 'Bugün',
          'past': 'Geçmiş',
          'locked': 'Kilitli',

          // Badges
          "achievement_badges": "Başarı Rozetleri",
          'achievementBadges': 'Başarı Rozetleri',
          'celebrateMilestones':
              'Montessori yolculuğunuzun kilometre taşlarını kutlayın',
          'activitiesCompleted': 'Tamamlanan Aktiviteler',
          "activities": "aktiviteler",
          "keep_growing": "Gelişmeye devam et! 🌱",
          "activity_journey":
              "Tamamlanan her aktivite, çocuğunuzun gelişim yolculuğunda bir adım ileriye gitmektir.",
          "earned": "Kazanıldı! 🎉",

          // Favorites
          "favorite_activities": "Favori Aktiviteler",
          "favoriteActivities": "Favori Aktiviteler",
          "savedActivities": "Kaydedilmiş aktiviteler",
          "searchFavorites": "Favorilerde ara...",
          "noFavoritesYet": "Henüz favori yok",
          "tapHeartToAdd":
              "Herhangi bir aktivitedeki kalp simgesine dokunarak favori koleksiyonunuza ekleyin.",

          // Guide
          "remember": "💡 Unutma",
          "guide_subtitle":
              "Montessori mükemmellikle değil, ilerlemeyle ilgilidir. Bağımsızlığa doğru atılan her küçük adım, kutlanmaya değer bir zaferdir.",
          "discover_guide":
              "Montessori eğitiminin temel ilkelerini ve bu eğitimin bağımsız, kendine güvenen çocukları nasıl yetiştirdiğini keşfedin.",
          "guide_observe":
              "Çocuğunuzun ilgi alanlarını, ihtiyaçlarını ve gelişim aşamasını anlamak için gözlem sanatını öğrenin.",
          "guide_create":
              "Basit ve pratik değişikliklerle bağımsızlığı ve öğrenmeyi teşvik eden bir ortam yaratın.",
          'montessoriGuide': 'Montessori Rehberi',
          'essentialInsights': 'Montessori yolculuğunuz için temel bilgiler',
          'whatIsMontessori': 'Montessori Nedir?',
          'howToObserve': 'Çocuğunuzu Nasıl Gözlemlersiniz',
          'settingUpSpace': 'Evde Montessori Alanı Kurma',

          // Settings
          'customizeExperience': 'MontiTime deneyiminizi özelleştirin',
          'language': 'Dil',
          'ageGroup': 'Yaş Grubu',
          'notifications': 'Bildirimler',
          'dailyReminders': 'Günlük aktivite hatırlatıcıları',
          'sendFeedback': 'Geri Bildirim Gönder',
          'helpImprove': 'MontiTime\'ı geliştirmemize yardımcı olun',

          // Education / Rationale
          "why_offline": "Neden Offline?",
          "why_offline_description":
              "Çoğu erken çocukluk dönemi uygulaması internet bağlantısı gerektirir. Ancak küçük çocuklara ekran vermek riskli olabilir.",
          "early_screens_title": "Erken Ekranların Riskleri",
          "early_screens_subtitle":
              "0-4 yaşlarında ekran kullanımı beyin gelişimini geciktirebilir.",
          "early_screens_risks":
              "Araştırmalar aşağıdaki risklerin arttığını göstermektedir:\n• Konuşma gecikmesi\n• Dikkat eksikliği\n• Duygusal düzenleme yetersizliği",
          "builds_brain_title": "Beyni Ne Geliştirir?",
          "builds_brain_grow":
              "Sadece izlemekle kalmayalım, birlikte büyüyelim.",
          "builds_brain_exploration":
              "Aktif keşif, pasif ekran izlemeye göre beyni daha hızlı geliştirir.",
          "builds_brain_play":
              "Gerçek oyun, gerçek beyinler geliştirir. 🖐️👀👂",
          "celebrate_monti":
              "Montessori yolculuğunuzun kilometre taşlarını kutlayın",
          "safer_approach_title": "Daha Güvenli Yaklaşımımız",
          "safer_approach_montessori":
              "Yalnızca Montessori temelli, ekran ışığı öğrenimi.",
          "safer_approach_no_distractions": "✅ Dikkat dağıtıcı unsur yok",
          "safer_approach_no_tracking": "✅ İzleme yok",
          "safer_approach_no_ads": "✅ Reklam yok",
          "safer_approach_subtitle":
              "Bu nedenle bu uygulama tamamen çevrimdışı çalışır.",
          "quide_subtitle":
              "Montessori mükemmellikle değil, ilerlemeyle ilgilidir. Bağımsızlığa doğru atılan her küçük adım, kutlanmaya değer bir zaferdir.",
          "discover_quide":
              "Montessori eğitiminin temel ilkelerini ve bu eğitimin bağımsız, kendine güvenen çocukları nasıl yetiştirdiğini keşfedin.",
          "quide_observe":
              "Çocuğunuzun ilgi alanlarını, ihtiyaçlarını ve gelişim aşamasını anlamak için gözlem sanatını öğrenin.",
          "quide_create":
              "Basit ve pratik değişikliklerle bağımsızlığı ve öğrenmeyi teşvik eden bir ortam yaratın.",
          ...kPaywallI18nTr,
          ...trTranslations,
          ...trTrialTranslations
        },
        'en': {
          "paywall.plan.yearly.badge": "Popular",
          "rest_pass_send":
              "A password reset request has been sent to your email address.",
          "rest_pass_not_send":
              "The password reset request could not be sent. Please try again later.",
          "wrong_password": "Wrong email or password",
          "user_not_found": "User not found",
          "fail_to_login": "Failed to login",
          "select_rating": "Please select your rating.",
          "thanks_feedback": "Thank you for your feedback.",
          "like": "Like",
          "dislike": "Dislike",
          "feedback": "Feedback",
          "feedback_desc": "Description",
          "give_up": "Back",
          "send": "Send",
          "write_your_thoughts": "Write down your thoughts in brief...",
          "account_deleted": "Hesabınız Silindi.",
          "delete_account": "Delete Account",
          "activity_updated": "Activities updated",
          "sn_ok": "OK",
          "sn_success": "SUCCESS",
          "sn_warn": "WARNİNG",
          "sn_error": "ERROR",
          "fill_required_fields": "Please fill required fields",
          "reset_password": "Reset Password",
          "forgot_password": "Forgot Password",
          "quide_create":
              "Create an environment that promotes independence and learning with simple, practical changes.",
          "quide_observe":
              "Learn the art of observation to understand your child's interests, needs, and developmental stage.",
          "discover_quide":
              "Discover the core principles of Montessori education and how it nurtures independent, confident children.",
          "quide_subtitle":
              "Montessori is not about perfection—it's about progress. Every small step towards independence is a victory worth celebrating.",
          "go": "Go",
          "celebrate_monti": "Celebrate your Montessori journey milestones",

          // Auth & Common
          "day": "day",
          "get_started_button": "Get Started",
          "continue_or_start": "Continue",
          "alreadyHaveAccount": "Already have account? Sign In",
          "register": "Register",
          "donthaveAccount": "Don't have account? Register",
          "loginApple": "Sign in with Apple",
          "loginGoogle": "Sign in with Google",
          "loginGuest": "Continue as Guest",
          "or": "or",
          "login": "Login",
          "password": "Password",
          "email": "E Mail",
          'back': 'Back',
          'next': 'Next',
          'cancel': 'Cancel',
          'save': 'Save',
          'delete': 'Delete',
          'edit': 'Edit',
          'close': 'Close',
          'previous': 'Previous',
          'done': 'Done',
          'skip': 'Skip',
          'loading': 'Loading ...',
          'error': 'Error',
          'retry': 'Retry',
          "log_out": "Log Out",
          "made_with": "Made with 🌱 for growing minds",

          // Navigation
          'home': 'Home',
          'calendar': 'Calendar',
          'badges': 'Badges',
          'favorites': 'Favorites',
          'guide': 'Guide',
          'settings': 'Settings',

          // Onboarding
          'welcome': 'Welcome!',
          'enterName': 'Enter your name',
          'continueAsGuest': 'Continue as Guest',
          "what_call_you": "What should we call you?",
          "enter_name_hint": "Enter your name",
          "choose_language": "Choose Language",
          "select_language": "Select your preferred language",
          "child_age_group": "Child's Age Group",
          "child_age_help": "This helps us show age-appropriate activities",
          "daily_montessori": "Daily Montessori activities for your child",
          "get_started_anytime": "Anytime.\nAnywhere.\nNo internet needed.",
          "get_started_subtitle": "Real Montessori activities.",
          "get_started_title": "Let's Get Started",

          // Home
          'goodMorning': 'Good morning',
          "todays_montissoris_ready": "Today's Montessori activities are ready",
          'todaysActivities': "Today's Activities",
          'monthlyProgress': 'Monthly Progress',
          'newSetUnlocks': 'A new Montessori set unlocks each day',
          'startActivity': 'Start Activity',
          'montessoriTip': 'Montessori Tip',

          // Activity Detail
          "skills": "Skills",
          "materials_needed": "Materials Needed",
          "step_by_step": "Step by Step Instructions",
          "activity_duration": "Duration: 15-20 Minutes",
          "rate_activity": "Rate this Activity",
          'materialsNeeded': 'Materials Needed',
          'stepByStep': 'Step-by-Step Instructions',
          'duration': 'Duration',
          'markAsDone': 'Mark as Done',
          'addToFavorites': 'Add to Favorites',
          'downloadPDF': 'Download PDF',
          'completed': 'Completed!',
          'pending': 'Pending',
          "activity": "Activity",
          "no_activity_found": "Activity not Found",

          // Calendar
          'activityCalendar': 'Activity Calendar',
          'viewPastActivities': 'View past activities and track your progress',
          "activity_calendar": "Activity Calendar",
          "view_progress": "View the past activities and track your progress.",
          'today': 'Today',
          'past': 'Past',
          'locked': 'Locked',

          // Badges
          "achievement_badges": "Achievement Badges",
          'achievementBadges': 'Achievement Badges',
          'celebrateMilestones': 'Celebrate your Montessori journey milestones',
          'activitiesCompleted': 'Activities Completed',
          "activities": "activities",
          "keep_growing": "Keep Growing! 🌱",
          "activity_journey":
              "Every activity completed is a step forward in your child's development journey.",
          "earned": "Earned! 🎉",

          // Favorites
          "favorite_activities": "Favorite Activities",
          "favoriteActivities": "Favorite Activities",
          "savedActivities": "saved activities",
          "searchFavorites": "Search favorites...",
          "noFavoritesYet": "No favorites yet",
          "tapHeartToAdd":
              "Tap the heart icon on any activity to add it to your favorites collection.",

          // Guide
          "remember": "💡 Remember",
          "guide_subtitle":
              "Montessori is not about perfection—it's about progress. Every small step towards independence is a victory worth celebrating.",
          "discover_guide":
              "Discover the core principles of Montessori education and how it nurtures independent, confident children.",
          "guide_observe":
              "Learn the art of observation to understand your child's interests, needs, and developmental stage.",
          "guide_create":
              "Create an environment that promotes independence and learning with simple, practical changes.",
          'montessoriGuide': 'Montessori Guide',
          'essentialInsights': 'Essential insights for your Montessori journey',
          'whatIsMontessori': 'What is Montessori?',
          'howToObserve': 'How to Observe Your Child',
          'settingUpSpace': 'Setting up a Montessori Space at Home',

          // Settings
          'customizeExperience': 'Customize your MontiTime experience',
          'language': 'Language',
          'ageGroup': 'Age Group',
          'notifications': 'Notifications',
          'dailyReminders': 'Daily activity reminders',
          'sendFeedback': 'Send Feedback',
          'helpImprove': 'Help us improve MontiTime',

          // Education / Rationale
          "why_offline": "Why Offline?",
          "why_offline_description":
              "Most early childhood apps need the internet. But giving screens to toddlers can be risky.",
          "early_screens_title": "The Risks of Early Screens",
          "early_screens_subtitle":
              "Screens at age 0-4 may delay brain development.",
          "early_screens_risks":
              "Studies show increased risks of:\n• Speech delay\n• Poor attention\n• Less emotional regulation",
          "builds_brain_title": "What Builds a Brain?",
          "builds_brain_grow": "Let's grow, not just watch.",
          "builds_brain_exploration":
              "Active exploration wires the brain faster than passive screen viewing.",
          "builds_brain_play": "Real play builds real brains. 🖐️👀👂",
          "safer_approach_title": "Our Safer Approach",
          "safer_approach_montessori":
              "Only Montessori-based, screen-light learning.",
          "safer_approach_no_distractions": "✅ No distractions",
          "safer_approach_no_tracking": "✅ No tracking",
          "safer_approach_no_ads": "✅ No ads",
          "safer_approach_subtitle":
              "That's why this app works completely offline.",
          ...kPaywallI18nEn,
          ...enTranslations,
          ...enTrialTranslations
        },
      };
}
