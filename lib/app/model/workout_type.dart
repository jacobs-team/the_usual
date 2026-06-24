/// The kind of exercise a workout entry records: strength training measured in
/// sets of weight and reps, or cardio measured by elapsed time.
enum WorkoutType {
  strength,
  cardio;

  /// The label shown for this type in the UI.
  String get label => switch (this) {
    WorkoutType.strength => 'Strength',
    WorkoutType.cardio => 'Cardio',
  };

  /// The type new exercises in a group called [groupName] default to: cardio
  /// when the name matches a known cardio activity (see [_cardioGroupNames]),
  /// strength otherwise. Matching is case-insensitive — single-word terms match
  /// a whole word in the name, multi-word terms match anywhere in it.
  static WorkoutType defaultForGroupName(String groupName) {
    final normalized = groupName.toLowerCase();
    final words = normalized
        .split(RegExp('[^a-z0-9]+'))
        .where((word) => word.isNotEmpty)
        .toSet();
    final isCardio = _cardioGroupNames.any(
      (term) => term.contains(' ')
          ? normalized.contains(term)
          : words.contains(term),
    );
    return isCardio ? WorkoutType.cardio : WorkoutType.strength;
  }
}

/// Workout-group names whose exercises default to [WorkoutType.cardio]. All
/// lowercase; matched case-insensitively against the group name.
const _cardioGroupNames = <String>{
  'cardio',
  'conditioning',
  'metcon',
  'hiit',
  'circuit',
  'circuit training',
  'aerobics',
  'step aerobics',
  'water aerobics',
  'endurance',
  // Running and walking.
  'run',
  'runs',
  'running',
  'jog',
  'jogging',
  'sprint',
  'sprints',
  'sprinting',
  'walk',
  'walking',
  'hike',
  'hiking',
  'ruck',
  'rucking',
  'treadmill',
  'marathon',
  'triathlon',
  'couch to 5k',
  // Cycling.
  'cycle',
  'cycling',
  'bike',
  'biking',
  'spin',
  'spinning',
  'spin class',
  'assault bike',
  'air bike',
  'echo bike',
  'peloton',
  // Rowing and machines.
  'row',
  'rowing',
  'erg',
  'elliptical',
  'stairmaster',
  'stairs',
  'stair climber',
  'stairclimber',
  // Swimming and water.
  'swim',
  'swimming',
  'surf',
  'surfing',
  'paddleboarding',
  'kayaking',
  'canoeing',
  // Racquet and ball sports.
  'tennis',
  'badminton',
  'squash',
  'pickleball',
  'racquetball',
  'basketball',
  'soccer',
  'football',
  'rugby',
  'hockey',
  'volleyball',
  'handball',
  'lacrosse',
  'frisbee',
  'ultimate frisbee',
  'sport',
  'sports',
  // Combat.
  'boxing',
  'kickboxing',
  'muay thai',
  'mma',
  'sparring',
  // Dance and class.
  'dance',
  'dancing',
  'zumba',
  // Rope, jumps, and bodyweight cardio.
  'skipping',
  'jump rope',
  'jumprope',
  'jumping rope',
  'jumping jacks',
  'burpees',
  // Snow and skating.
  'skating',
  'rollerblading',
  'ice skating',
  'skiing',
  'snowboarding',
  'cross country',
  // Climbing.
  'climbing',
  'bouldering',
};
