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

  @override
  Map<String, Map<String, String>> get keys => {
        'tr': {
          "day": "gün",
          "get_started_button": "Başla",
          "continue_or_start": "Devam Et",
          "child_age_help_tr":
              "Bu, yaşa uygun aktiviteler göstermemize yardımcı olur",

          "child_age_group_tr": "Çocuğun Yaş Grubu",
          "select_language_tr": "Tercih ettiğiniz dili seçin",
          "choose_language_tr": "Dil Seçin",
          "enter_name_hint_tr": "Adınızı giriniz",
          "what_call_you_tr": "Size nasıl hitap edelim?",
          "daily_montessori_tr":
              "Çocuğunuz için günlük Montessori aktiviteleri",
          "back": "Geri",
          "next": "İleri",
          "get_started_anytime_tr":
              "Her zaman.\nHer yerde.\nİnternet gerekmez.",
          "get_started_subtitle_tr": "Gerçek Montessori aktiviteleri.",
          "get_started_title_tr": "Hadi Başlayalım",
          "safer_approach_montessori_tr":
              "Sadece Montessori temelli, ekrana az maruz bırakan öğrenme.",
          "safer_approach_no_distractions_tr": "✅ Dikkat dağıtıcı unsurlar yok",
          "safer_approach_no_tracking_tr": "✅ Takip yok",
          "safer_approach_no_ads_tr": "✅ Reklamsız",
          "safer_approach_subtitle_tr":
              "İşte bu yüzden bu uygulama tamamen çevrimdışı çalışır.",

          "safer_approach_title_tr": "Daha Güvenli Yaklaşımımız",
          "builds_brain_grow_tr": "Sadece izlemeyelim, birlikte büyüyelim.",
          "builds_brain_exploration_tr":
              "Aktif keşif, pasif ekran izlemeye göre beyni daha hızlı bağlantılarla güçlendirir.",

          "builds_brain_play_tr":
              "Gerçek oyun gerçek beyinleri geliştirir. 🖐️👀👂",
          "builds_brain_title_tr": "Beyni Ne Geliştirir?",
          "early_screens_risks_tr":
              "Araştırmalar şu risklerin arttığını göstermektedir:\n• Konuşma gecikmesi\n• Dikkat dağınıklığı\n• Daha az duygusal kontrol",
          "early_screens_subtitle_tr":
              "0-4 yaş arası ekran kullanımı beyin gelişimini geciktirebilir.",

          "early_screens_title_tr": "Erken Ekranların Riskleri",
          "why_offline_description_tr":
              "Çoğu erken çocukluk uygulaması internete ihtiyaç duyar. Ancak küçük çocuklara ekran vermek riskli olabilir.",
          "why_offline_tr": "Neden Çevrimdışı?",
          "alreadyHaveAccount": "Zaten hesabın var mı? Giriş Yap",
          "register": "Kayıt Ol",
          "donthaveAccount": "Hesabın yok mu? Kayıt Ol",
          "loginApple": "Apple ile Giriş",
          "loginGoogle": "Google ile Giriş",
          "or": "veya",
          "login": "Giriş Yap",
          'password': "Şifre",
          'email': "E Posta",
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
          'chooseLanguage': 'Dil Seçin',
          'selectLanguage': 'Tercih ettiğiniz dili seçin',
          'childAgeGroup': 'Çocuğun Yaş Grubu',
          'ageGroupDescription':
              'Bu yaşa uygun aktiviteler göstermemize yardımcı olur',
          'getStarted': 'Başlayın',
          'continue': 'Devam Et',
          // Home Screen
          'goodMorning': 'Günaydın',
          'todaysActivities': 'Bugünün Aktiviteleri',
          'monthlyProgress': 'Aylık İlerleme',
          'newSetUnlocks': 'Her gün yeni bir Montessori seti açılır',
          'startActivity': 'Aktiviteyi Başlat',
          'montessoriTip': 'Montessori İpucu',
          // Activity Detail
          'materialsNeeded': 'Gerekli Malzemeler',
          'stepByStep': 'Adım Adım Talimatlar',
          'duration': 'Süre',
          'markAsDone': 'Tamamlandı Olarak İşaretle',
          'addToFavorites': 'Favorilere Ekle',
          'downloadPDF': 'PDF İndir',
          'completed': 'Tamamlandı!',
          // Calendar
          'activityCalendar': 'Aktivite Takvimi',
          'viewPastActivities':
              'Geçmiş aktiviteleri görüntüle ve ilerlemenizi takip edin',
          'today': 'Bugün',
          'past': 'Geçmiş',
          'locked': 'Kilitli',
          // Badges
          'achievementBadges': 'Başarı Rozetleri',
          'celebrateMilestones':
              'Montessori yolculuğunuzun kilometre taşlarını kutlayın',
          'activitiesCompleted': 'Aktivite Tamamlandı',
          'keepGrowing': 'Büyümeye Devam Edin!',
          'everyActivityCounts':
              'Tamamlanan her aktivite çocuğunuzun gelişim yolculuğunda bir adımdır.',
          // Favorites
          'favoriteActivities': 'Favori Aktiviteler',
          'savedActivities': 'kaydedilmiş aktivite',
          'searchFavorites': 'Favorilerde ara...',
          'noFavoritesYet': 'Henüz favori yok',
          'tapHeartToAdd':
              'Herhangi bir aktivitedeki kalp simgesine dokunarak favori koleksiyonunuza ekleyin.',
          // Guide
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
          'cancel': 'İptal',
          // Common
          'all': 'Tümü',
          'search': 'Ara',
          'filter': 'Filtrele',
          'category': 'Kategori',
          'difficulty': 'Zorluk',
          'beginner': 'Başlangıç',
          'intermediate': 'Orta',
          'advanced': 'İleri',
          'loading': 'Yükleniyor ...',
          'error': 'Hata',
          'retry': 'Tekrar Dene',
          'save': 'Kaydet',
          'delete': 'Sil',
          'edit': 'Düzenle',
          'close': 'Kapat',
          'previous': 'Önceki',
          'done': 'Tamam',
          'skip': 'Geç',
          "no_activity_found": "Aktivite Bulunamadı.",
          "todays_montissoris_ready": "Bugünün Montessori etkinlikleri hazır",
          "daily_montessori": "Çocuğunuz için günlük Montessori etkinlikleri",
          "what_call_you": "Size nasıl hitap edelim?",
          "enter_name_hint": "Adınız",
          "choose_language": "Dil Seç",
          "select_language": "Tercih ettiğiniz dili seçin",
          "child_age_group": "Çocuğun Yaş Grubu",
          "child_age_help":
              "Bu, yaşa uygun etkinlikleri göstermemize yardımcı olur.",
          "skills": "Beceriler",
          "materials_needed": "Gerekli Malzemeler",
          "step_by_step": "Adım Adım Talimatlar",
          "activity_duration": "Süre: 15-20 Dakika",
          "rate_activity": "Aktiviteyi Oyla",
        },
        'en': {
          "rate_activity": "Rate this Activity",
          "activity_duration": "Duration: 15-20 Minutes",
          "step_by_step": "Step by Step Instructions",
          "materials_needed": "Materials Needed",
          "skills": "Skills",
          "todays_montissoris_ready": "Today's Montessori activities are ready",
          "no_activity_found": "Activity not Found",
          "day": "day",
          "get_started_button": "Get Started",
          "continue_or_start": "Continue",
          "child_age_help": "This helps us show age-appropriate activities",
          "child_age_group": "Child's Age Group",
          "select_language": "Select your preferred language",
          "choose_language": "Choose Language",
          "enter_name_hint": "Enter your name",
          "what_call_you": "What should we call you?",
          "daily_montessori": "Daily Montessori activities for your child",
          "back": "Back",
          "next": "Next",
          "get_started_anytime": "Anytime.\nAnywhere.\nNo internet needed.",
          "get_started_subtitle": "Real Montessori activities.",
          "get_started_title": "Let's Get Started",
          "safer_approach_montessori":
              "Only Montessori-based, screen-light learning.",
          "safer_approach_no_distractions": "✅ No distractions",
          "safer_approach_no_tracking": "✅ No tracking",
          "safer_approach_no_ads": "✅ No ads",
          "safer_approach_subtitle":
              "That's why this app works completely offline.",
          "safer_approach_title": "Our Safer Approach",
          "builds_brain_grow": "Let's grow, not just watch.",
          "builds_brain_exploration":
              "Active exploration wires the brain faster than passive screen viewing.",
          "builds_brain_play": "Real play builds real brains. 🖐️👀👂",
          "builds_brain_title": "What Builds a Brain?",
          "early_screens_risks":
              "Studies show increased risks of:\n• Speech delay\n• Poor attention\n• Less emotional regulation",
          "early_screens_subtitle":
              "Screens at age 0-4 may delay brain development.",
          "early_screens_title": "The Risks of Early Screens",
          "why_offline_description":
              "Most early childhood apps need the internet. But giving screens to toddlers can be risky.",
          "why_offline": "Why Offline?",
          "alreadyHaveAccount": "Already have account? Sign In",
          "register": "Register",
          "donthaveAccount": "Don't have account? Register",
          "loginApple": "Sign in with Apple",
          "loginGoogle": "Sign in with Google",
          "or": "or",
          "login": "Login",
          'password': "Password",
          'email': "E Mail",
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
          'chooseLanguage': 'Choose Language',
          'selectLanguage': 'Select your preferred language',
          'childAgeGroup': 'Child\'s Age Group',
          'ageGroupDescription':
              'This helps us show age-appropriate activities',
          'getStarted': 'Get Started',
          'continue': 'Continue',
          // Home Screen
          'goodMorning': 'Good morning',
          'todaysActivities': 'Today\'s Activities',
          'monthlyProgress': 'Monthly Progress',
          'newSetUnlocks': 'A new Montessori set unlocks each day',
          'startActivity': 'Start Activity',
          'montessoriTip': 'Montessori Tip',
          // Activity Detail
          'materialsNeeded': 'Materials Needed',
          'stepByStep': 'Step-by-Step Instructions',
          'duration': 'Duration',
          'markAsDone': 'Mark as Done',
          'addToFavorites': 'Add to Favorites',
          'downloadPDF': 'Download PDF',
          'completed': 'Completed!',
          // Calendar
          'activityCalendar': 'Activity Calendar',
          'viewPastActivities': 'View past activities and track your progress',
          'today': 'Today',
          'past': 'Past',
          'locked': 'Locked',
          // Badges
          'achievementBadges': 'Achievement Badges',
          'celebrateMilestones': 'Celebrate your Montessori journey milestones',
          'activitiesCompleted': 'Activities Completed',
          'keepGrowing': 'Keep Growing!',
          'everyActivityCounts':
              'Every activity completed is a step forward in your child\'s development journey.',
          // Favorites
          'favoriteActivities': 'Favorite Activities',
          'savedActivities': 'saved activities',
          'searchFavorites': 'Search favorites...',
          'noFavoritesYet': 'No favorites yet',
          'tapHeartToAdd':
              'Tap the heart icon on any activity to add it to your favorites collection.',
          // Guide
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
          'cancel': 'Cancel',
          // Common
          'all': 'All',
          'search': 'Search',
          'filter': 'Filter',
          'category': 'Category',
          'difficulty': 'Difficulty',
          'beginner': 'Beginner',
          'intermediate': 'Intermediate',
          'advanced': 'Advanced',
          'loading': 'Loading ...',
          'error': 'Error',
          'retry': 'Retry',
          'save': 'Save',
          'delete': 'Delete',
          'edit': 'Edit',
          'close': 'Close',
          'previous': 'Previous',
          'done': 'Done',
          'skip': 'Skip',
        },
      };
}
