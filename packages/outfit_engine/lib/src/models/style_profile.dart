final class StyleProfile {
  StyleProfile({
    required String id,
    required String name,
    required (int, int) formalityRange,
    required Map<String, double> ruleWeights,
  }) : this._(
         id: id,
         name: name,
         formalityRange: formalityRange,
         ruleWeights: Map.unmodifiable(ruleWeights),
       );

  const StyleProfile._({
    required this.id,
    required this.name,
    required this.formalityRange,
    required this.ruleWeights,
  });

  final String id;
  final String name;
  final (int, int) formalityRange;
  final Map<String, double> ruleWeights;

  StyleProfile copyWith({
    String? id,
    String? name,
    (int, int)? formalityRange,
    Map<String, double>? ruleWeights,
  }) {
    return StyleProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      formalityRange: formalityRange ?? this.formalityRange,
      ruleWeights: ruleWeights ?? this.ruleWeights,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StyleProfile &&
          id == other.id &&
          name == other.name &&
          formalityRange == other.formalityRange &&
          ruleWeights.length == other.ruleWeights.length &&
          ruleWeights.entries.every(
            (entry) => entry.value == other.ruleWeights[entry.key],
          );

  @override
  int get hashCode => Object.hash(
    id,
    name,
    formalityRange,
    Object.hashAllUnordered(
      ruleWeights.entries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
  );
}

const predefinedStyles = [
  StyleProfile._(
    id: 'casual',
    name: 'Casual',
    formalityRange: (1, 2),
    ruleWeights: {
      'formality': 1.0,
      'style': 1.0,
      'color': 1.0,
      'volume': 0.5,
      'rotation': 1.0,
    },
  ),
  StyleProfile._(
    id: 'smart_casual',
    name: 'Casual elegante',
    formalityRange: (2, 4),
    ruleWeights: {
      'formality': 1.5,
      'style': 1.5,
      'color': 1.0,
      'volume': 0.75,
      'rotation': 1.0,
    },
  ),
  StyleProfile._(
    id: 'streetwear',
    name: 'Urbano',
    formalityRange: (1, 3),
    ruleWeights: {
      'formality': 0.75,
      'style': 1.0,
      'color': 1.25,
      'volume': 1.0,
      'rotation': 1.0,
    },
  ),
  StyleProfile._(
    id: 'minimal',
    name: 'Minimalista',
    formalityRange: (2, 4),
    ruleWeights: {
      'formality': 1.0,
      'style': 1.0,
      'color': 1.75,
      'volume': 0.75,
      'rotation': 1.0,
    },
  ),
];
