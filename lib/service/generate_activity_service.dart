import 'package:play_monti/models/activity_model.dart';

List<Activity> generateActivitiesDatabase() {
  final List<String> categories = [
    'Practical Life',
    'Sensorial',
    'Mathematics',
    'Language',
    'Cultural Studies',
    'Specialized'
  ];
  final List<String> difficulties = ['Beginner', 'Intermediate', 'Advanced'];
  final List<String> durations = [
    '5-10 min',
    '10-15 min',
    '15-30 min',
    '30+ min'
  ];
  final List<String> emojis = [
    '💧',
    '🍎',
    '🧹',
    '✋',
    '🔊',
    '🌈',
    '🟡',
    '📏',
    '🟪',
    '🔵',
    '✍️',
    '📚',
    '🧠',
    '🛋️'
  ];
  final List<String> names = [
    'Pouring Water',
    'Apple Slicing',
    'Sweeping',
    'Tactile Tablets',
    'Sound Cylinders',
    'Color Tablets',
    'Golden Beads',
    'Number Rods',
    'Sandpaper Letters',
    'Moveable Alphabet',
    'Book Making',
    'Creative Writing',
    'Sensory Integration',
    'Calming Corner'
  ];

  List<Activity> activities = [];
  int id = 1;
  for (int i = 0; i < 100; i++) {
    activities.add(
      Activity(
        id: id,
        name: names[i % names.length],
        category: categories[i % categories.length],
        ageRange: ['2-3 years', '3-4 years', '4-5 years', '5-6 years'][i % 4],
        difficulty: difficulties[i % 3],
        variation: 'Original',
        description:
            'A Montessori activity for ${categories[i % categories.length].toLowerCase()} development.',
        materials: 'Standard Montessori materials',
        setupTime: '${5 + (i % 10)} min',
        duration: durations[i % durations.length],
        groupSize: 'Individual',
        learningStyle: 'Mixed',
        motorSkills: 'Fine motor, Hand-eye coordination',
        cognitiveSkills: 'Concentration, Problem-solving',
        socialSkills: 'Independence, Patience',
        outcomes: '${categories[i % categories.length]} skills improvement',
        prerequisites: 'None',
        extensions: 'Can be modified for age',
        followUp: 'Practice and repetition',
        safetyNotes: 'Adult supervision recommended',
        culturalNotes: 'Universally applicable',
        adaptations: 'Adaptable for needs',
        assessment: 'Observe engagement',
        preparation: 'Set up materials neatly',
        presentation: 'Demonstrate and let child try',
        environment: 'Prepared environment',
        season: 'Any',
        cost: 'Low',
        diyLevel: 'Easy',
        specialNeeds: 'Adaptable',
        languageSupport: 'Vocabulary building',
        parentInvolvement: 'Encouraged',
        digitalComponent: 'None',
        outdoorSuitable: i % 2 == 0 ? 'Yes' : 'No',
        messLevel: 'Low',
        noiseLevel: 'Low',
        storageNeeds: 'Standard',
        reusability: 'High',
        educationalStandards: 'Montessori aligned',
        emoji: emojis[i % emojis.length],
        tags: [
          categories[i % categories.length].toLowerCase(),
          'montessori',
          difficulties[i % 3].toLowerCase()
        ],
      ),
    );
    id++;
  }
  return activities;
}
