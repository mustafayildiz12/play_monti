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
          'loading': 'Yükleniyor',
          'error': 'Hata',
          'retry': 'Tekrar Dene',
          'save': 'Kaydet',
          'delete': 'Sil',
          'edit': 'Düzenle',
          'close': 'Kapat',
          'back': 'Geri',
          'next': 'İleri',
          'previous': 'Önceki',
          'done': 'Tamam',
          'skip': 'Geç',
        },
        'en': {
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
          'loading': 'Loading',
          'error': 'Error',
          'retry': 'Retry',
          'save': 'Save',
          'delete': 'Delete',
          'edit': 'Edit',
          'close': 'Close',
          'back': 'Back',
          'next': 'Next',
          'previous': 'Previous',
          'done': 'Done',
          'skip': 'Skip',
        },
      };
}
