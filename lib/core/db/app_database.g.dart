// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GarmentsTable extends Garments
    with TableInfo<$GarmentsTable, GarmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GarmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GarmentCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<GarmentCategory>($GarmentsTable.$convertercategory);
  static const VerificationMeta _subtypeMeta = const VerificationMeta(
    'subtype',
  );
  @override
  late final GeneratedColumn<String> subtype = GeneratedColumn<String>(
    'subtype',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formalityMeta = const VerificationMeta(
    'formality',
  );
  @override
  late final GeneratedColumn<int> formality = GeneratedColumn<int>(
    'formality',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (formality BETWEEN 1 AND 5)',
  );
  static const VerificationMeta _primaryColorMeta = const VerificationMeta(
    'primaryColor',
  );
  @override
  late final GeneratedColumn<int> primaryColor = GeneratedColumn<int>(
    'primary_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ColorFamily, String> colorFamily =
      GeneratedColumn<String>(
        'color_family',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ColorFamily>($GarmentsTable.$convertercolorFamily);
  static const VerificationMeta _secondaryColorMeta = const VerificationMeta(
    'secondaryColor',
  );
  @override
  late final GeneratedColumn<int> secondaryColor = GeneratedColumn<int>(
    'secondary_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ColorFamily?, String>
  secondaryColorFamily = GeneratedColumn<String>(
    'secondary_color_family',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<ColorFamily?>($GarmentsTable.$convertersecondaryColorFamilyn);
  @override
  late final GeneratedColumnWithTypeConverter<GarmentPattern, String> pattern =
      GeneratedColumn<String>(
        'pattern',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('solid'),
      ).withConverter<GarmentPattern>($GarmentsTable.$converterpattern);
  @override
  late final GeneratedColumnWithTypeConverter<Fit?, String> fit =
      GeneratedColumn<String>(
        'fit',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Fit?>($GarmentsTable.$converterfitn);
  @override
  late final GeneratedColumnWithTypeConverter<Warmth?, String> warmth =
      GeneratedColumn<String>(
        'warmth',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Warmth?>($GarmentsTable.$converterwarmthn);
  static const VerificationMeta _lastWornAtMeta = const VerificationMeta(
    'lastWornAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastWornAt = GeneratedColumn<DateTime>(
    'last_worn_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timesWornMeta = const VerificationMeta(
    'timesWorn',
  );
  @override
  late final GeneratedColumn<int> timesWorn = GeneratedColumn<int>(
    'times_worn',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isVirtualMeta = const VerificationMeta(
    'isVirtual',
  );
  @override
  late final GeneratedColumn<bool> isVirtual = GeneratedColumn<bool>(
    'is_virtual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_virtual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    subtype,
    formality,
    primaryColor,
    colorFamily,
    secondaryColor,
    secondaryColorFamily,
    pattern,
    fit,
    warmth,
    lastWornAt,
    timesWorn,
    isVirtual,
    photoPath,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'garments';
  @override
  VerificationContext validateIntegrity(
    Insertable<GarmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subtype')) {
      context.handle(
        _subtypeMeta,
        subtype.isAcceptableOrUnknown(data['subtype']!, _subtypeMeta),
      );
    } else if (isInserting) {
      context.missing(_subtypeMeta);
    }
    if (data.containsKey('formality')) {
      context.handle(
        _formalityMeta,
        formality.isAcceptableOrUnknown(data['formality']!, _formalityMeta),
      );
    } else if (isInserting) {
      context.missing(_formalityMeta);
    }
    if (data.containsKey('primary_color')) {
      context.handle(
        _primaryColorMeta,
        primaryColor.isAcceptableOrUnknown(
          data['primary_color']!,
          _primaryColorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_primaryColorMeta);
    }
    if (data.containsKey('secondary_color')) {
      context.handle(
        _secondaryColorMeta,
        secondaryColor.isAcceptableOrUnknown(
          data['secondary_color']!,
          _secondaryColorMeta,
        ),
      );
    }
    if (data.containsKey('last_worn_at')) {
      context.handle(
        _lastWornAtMeta,
        lastWornAt.isAcceptableOrUnknown(
          data['last_worn_at']!,
          _lastWornAtMeta,
        ),
      );
    }
    if (data.containsKey('times_worn')) {
      context.handle(
        _timesWornMeta,
        timesWorn.isAcceptableOrUnknown(data['times_worn']!, _timesWornMeta),
      );
    }
    if (data.containsKey('is_virtual')) {
      context.handle(
        _isVirtualMeta,
        isVirtual.isAcceptableOrUnknown(data['is_virtual']!, _isVirtualMeta),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    } else if (isInserting) {
      context.missing(_photoPathMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GarmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GarmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      category: $GarmentsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      subtype: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtype'],
      )!,
      formality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}formality'],
      )!,
      primaryColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}primary_color'],
      )!,
      colorFamily: $GarmentsTable.$convertercolorFamily.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}color_family'],
        )!,
      ),
      secondaryColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}secondary_color'],
      ),
      secondaryColorFamily: $GarmentsTable.$convertersecondaryColorFamilyn
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.string,
              data['${effectivePrefix}secondary_color_family'],
            ),
          ),
      pattern: $GarmentsTable.$converterpattern.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}pattern'],
        )!,
      ),
      fit: $GarmentsTable.$converterfitn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}fit'],
        ),
      ),
      warmth: $GarmentsTable.$converterwarmthn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}warmth'],
        ),
      ),
      lastWornAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_worn_at'],
      ),
      timesWorn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_worn'],
      )!,
      isVirtual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_virtual'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GarmentsTable createAlias(String alias) {
    return $GarmentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GarmentCategory, String, String>
  $convertercategory = const EnumNameConverter<GarmentCategory>(
    GarmentCategory.values,
  );
  static JsonTypeConverter2<ColorFamily, String, String> $convertercolorFamily =
      const EnumNameConverter<ColorFamily>(ColorFamily.values);
  static JsonTypeConverter2<ColorFamily, String, String>
  $convertersecondaryColorFamily = const EnumNameConverter<ColorFamily>(
    ColorFamily.values,
  );
  static JsonTypeConverter2<ColorFamily?, String?, String?>
  $convertersecondaryColorFamilyn = JsonTypeConverter2.asNullable(
    $convertersecondaryColorFamily,
  );
  static JsonTypeConverter2<GarmentPattern, String, String> $converterpattern =
      const EnumNameConverter<GarmentPattern>(GarmentPattern.values);
  static JsonTypeConverter2<Fit, String, String> $converterfit =
      const EnumNameConverter<Fit>(Fit.values);
  static JsonTypeConverter2<Fit?, String?, String?> $converterfitn =
      JsonTypeConverter2.asNullable($converterfit);
  static JsonTypeConverter2<Warmth, String, String> $converterwarmth =
      const EnumNameConverter<Warmth>(Warmth.values);
  static JsonTypeConverter2<Warmth?, String?, String?> $converterwarmthn =
      JsonTypeConverter2.asNullable($converterwarmth);
}

class GarmentRow extends DataClass implements Insertable<GarmentRow> {
  final String id;
  final GarmentCategory category;
  final String subtype;
  final int formality;
  final int primaryColor;
  final ColorFamily colorFamily;
  final int? secondaryColor;
  final ColorFamily? secondaryColorFamily;
  final GarmentPattern pattern;
  final Fit? fit;
  final Warmth? warmth;
  final DateTime? lastWornAt;
  final int timesWorn;
  final bool isVirtual;
  final String photoPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  const GarmentRow({
    required this.id,
    required this.category,
    required this.subtype,
    required this.formality,
    required this.primaryColor,
    required this.colorFamily,
    this.secondaryColor,
    this.secondaryColorFamily,
    required this.pattern,
    this.fit,
    this.warmth,
    this.lastWornAt,
    required this.timesWorn,
    required this.isVirtual,
    required this.photoPath,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['category'] = Variable<String>(
        $GarmentsTable.$convertercategory.toSql(category),
      );
    }
    map['subtype'] = Variable<String>(subtype);
    map['formality'] = Variable<int>(formality);
    map['primary_color'] = Variable<int>(primaryColor);
    {
      map['color_family'] = Variable<String>(
        $GarmentsTable.$convertercolorFamily.toSql(colorFamily),
      );
    }
    if (!nullToAbsent || secondaryColor != null) {
      map['secondary_color'] = Variable<int>(secondaryColor);
    }
    if (!nullToAbsent || secondaryColorFamily != null) {
      map['secondary_color_family'] = Variable<String>(
        $GarmentsTable.$convertersecondaryColorFamilyn.toSql(
          secondaryColorFamily,
        ),
      );
    }
    {
      map['pattern'] = Variable<String>(
        $GarmentsTable.$converterpattern.toSql(pattern),
      );
    }
    if (!nullToAbsent || fit != null) {
      map['fit'] = Variable<String>($GarmentsTable.$converterfitn.toSql(fit));
    }
    if (!nullToAbsent || warmth != null) {
      map['warmth'] = Variable<String>(
        $GarmentsTable.$converterwarmthn.toSql(warmth),
      );
    }
    if (!nullToAbsent || lastWornAt != null) {
      map['last_worn_at'] = Variable<DateTime>(lastWornAt);
    }
    map['times_worn'] = Variable<int>(timesWorn);
    map['is_virtual'] = Variable<bool>(isVirtual);
    map['photo_path'] = Variable<String>(photoPath);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GarmentsCompanion toCompanion(bool nullToAbsent) {
    return GarmentsCompanion(
      id: Value(id),
      category: Value(category),
      subtype: Value(subtype),
      formality: Value(formality),
      primaryColor: Value(primaryColor),
      colorFamily: Value(colorFamily),
      secondaryColor: secondaryColor == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryColor),
      secondaryColorFamily: secondaryColorFamily == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryColorFamily),
      pattern: Value(pattern),
      fit: fit == null && nullToAbsent ? const Value.absent() : Value(fit),
      warmth: warmth == null && nullToAbsent
          ? const Value.absent()
          : Value(warmth),
      lastWornAt: lastWornAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastWornAt),
      timesWorn: Value(timesWorn),
      isVirtual: Value(isVirtual),
      photoPath: Value(photoPath),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory GarmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GarmentRow(
      id: serializer.fromJson<String>(json['id']),
      category: $GarmentsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      subtype: serializer.fromJson<String>(json['subtype']),
      formality: serializer.fromJson<int>(json['formality']),
      primaryColor: serializer.fromJson<int>(json['primaryColor']),
      colorFamily: $GarmentsTable.$convertercolorFamily.fromJson(
        serializer.fromJson<String>(json['colorFamily']),
      ),
      secondaryColor: serializer.fromJson<int?>(json['secondaryColor']),
      secondaryColorFamily: $GarmentsTable.$convertersecondaryColorFamilyn
          .fromJson(serializer.fromJson<String?>(json['secondaryColorFamily'])),
      pattern: $GarmentsTable.$converterpattern.fromJson(
        serializer.fromJson<String>(json['pattern']),
      ),
      fit: $GarmentsTable.$converterfitn.fromJson(
        serializer.fromJson<String?>(json['fit']),
      ),
      warmth: $GarmentsTable.$converterwarmthn.fromJson(
        serializer.fromJson<String?>(json['warmth']),
      ),
      lastWornAt: serializer.fromJson<DateTime?>(json['lastWornAt']),
      timesWorn: serializer.fromJson<int>(json['timesWorn']),
      isVirtual: serializer.fromJson<bool>(json['isVirtual']),
      photoPath: serializer.fromJson<String>(json['photoPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(
        $GarmentsTable.$convertercategory.toJson(category),
      ),
      'subtype': serializer.toJson<String>(subtype),
      'formality': serializer.toJson<int>(formality),
      'primaryColor': serializer.toJson<int>(primaryColor),
      'colorFamily': serializer.toJson<String>(
        $GarmentsTable.$convertercolorFamily.toJson(colorFamily),
      ),
      'secondaryColor': serializer.toJson<int?>(secondaryColor),
      'secondaryColorFamily': serializer.toJson<String?>(
        $GarmentsTable.$convertersecondaryColorFamilyn.toJson(
          secondaryColorFamily,
        ),
      ),
      'pattern': serializer.toJson<String>(
        $GarmentsTable.$converterpattern.toJson(pattern),
      ),
      'fit': serializer.toJson<String?>(
        $GarmentsTable.$converterfitn.toJson(fit),
      ),
      'warmth': serializer.toJson<String?>(
        $GarmentsTable.$converterwarmthn.toJson(warmth),
      ),
      'lastWornAt': serializer.toJson<DateTime?>(lastWornAt),
      'timesWorn': serializer.toJson<int>(timesWorn),
      'isVirtual': serializer.toJson<bool>(isVirtual),
      'photoPath': serializer.toJson<String>(photoPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GarmentRow copyWith({
    String? id,
    GarmentCategory? category,
    String? subtype,
    int? formality,
    int? primaryColor,
    ColorFamily? colorFamily,
    Value<int?> secondaryColor = const Value.absent(),
    Value<ColorFamily?> secondaryColorFamily = const Value.absent(),
    GarmentPattern? pattern,
    Value<Fit?> fit = const Value.absent(),
    Value<Warmth?> warmth = const Value.absent(),
    Value<DateTime?> lastWornAt = const Value.absent(),
    int? timesWorn,
    bool? isVirtual,
    String? photoPath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => GarmentRow(
    id: id ?? this.id,
    category: category ?? this.category,
    subtype: subtype ?? this.subtype,
    formality: formality ?? this.formality,
    primaryColor: primaryColor ?? this.primaryColor,
    colorFamily: colorFamily ?? this.colorFamily,
    secondaryColor: secondaryColor.present
        ? secondaryColor.value
        : this.secondaryColor,
    secondaryColorFamily: secondaryColorFamily.present
        ? secondaryColorFamily.value
        : this.secondaryColorFamily,
    pattern: pattern ?? this.pattern,
    fit: fit.present ? fit.value : this.fit,
    warmth: warmth.present ? warmth.value : this.warmth,
    lastWornAt: lastWornAt.present ? lastWornAt.value : this.lastWornAt,
    timesWorn: timesWorn ?? this.timesWorn,
    isVirtual: isVirtual ?? this.isVirtual,
    photoPath: photoPath ?? this.photoPath,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GarmentRow copyWithCompanion(GarmentsCompanion data) {
    return GarmentRow(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      subtype: data.subtype.present ? data.subtype.value : this.subtype,
      formality: data.formality.present ? data.formality.value : this.formality,
      primaryColor: data.primaryColor.present
          ? data.primaryColor.value
          : this.primaryColor,
      colorFamily: data.colorFamily.present
          ? data.colorFamily.value
          : this.colorFamily,
      secondaryColor: data.secondaryColor.present
          ? data.secondaryColor.value
          : this.secondaryColor,
      secondaryColorFamily: data.secondaryColorFamily.present
          ? data.secondaryColorFamily.value
          : this.secondaryColorFamily,
      pattern: data.pattern.present ? data.pattern.value : this.pattern,
      fit: data.fit.present ? data.fit.value : this.fit,
      warmth: data.warmth.present ? data.warmth.value : this.warmth,
      lastWornAt: data.lastWornAt.present
          ? data.lastWornAt.value
          : this.lastWornAt,
      timesWorn: data.timesWorn.present ? data.timesWorn.value : this.timesWorn,
      isVirtual: data.isVirtual.present ? data.isVirtual.value : this.isVirtual,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GarmentRow(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('subtype: $subtype, ')
          ..write('formality: $formality, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('colorFamily: $colorFamily, ')
          ..write('secondaryColor: $secondaryColor, ')
          ..write('secondaryColorFamily: $secondaryColorFamily, ')
          ..write('pattern: $pattern, ')
          ..write('fit: $fit, ')
          ..write('warmth: $warmth, ')
          ..write('lastWornAt: $lastWornAt, ')
          ..write('timesWorn: $timesWorn, ')
          ..write('isVirtual: $isVirtual, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    subtype,
    formality,
    primaryColor,
    colorFamily,
    secondaryColor,
    secondaryColorFamily,
    pattern,
    fit,
    warmth,
    lastWornAt,
    timesWorn,
    isVirtual,
    photoPath,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GarmentRow &&
          other.id == this.id &&
          other.category == this.category &&
          other.subtype == this.subtype &&
          other.formality == this.formality &&
          other.primaryColor == this.primaryColor &&
          other.colorFamily == this.colorFamily &&
          other.secondaryColor == this.secondaryColor &&
          other.secondaryColorFamily == this.secondaryColorFamily &&
          other.pattern == this.pattern &&
          other.fit == this.fit &&
          other.warmth == this.warmth &&
          other.lastWornAt == this.lastWornAt &&
          other.timesWorn == this.timesWorn &&
          other.isVirtual == this.isVirtual &&
          other.photoPath == this.photoPath &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GarmentsCompanion extends UpdateCompanion<GarmentRow> {
  final Value<String> id;
  final Value<GarmentCategory> category;
  final Value<String> subtype;
  final Value<int> formality;
  final Value<int> primaryColor;
  final Value<ColorFamily> colorFamily;
  final Value<int?> secondaryColor;
  final Value<ColorFamily?> secondaryColorFamily;
  final Value<GarmentPattern> pattern;
  final Value<Fit?> fit;
  final Value<Warmth?> warmth;
  final Value<DateTime?> lastWornAt;
  final Value<int> timesWorn;
  final Value<bool> isVirtual;
  final Value<String> photoPath;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GarmentsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.subtype = const Value.absent(),
    this.formality = const Value.absent(),
    this.primaryColor = const Value.absent(),
    this.colorFamily = const Value.absent(),
    this.secondaryColor = const Value.absent(),
    this.secondaryColorFamily = const Value.absent(),
    this.pattern = const Value.absent(),
    this.fit = const Value.absent(),
    this.warmth = const Value.absent(),
    this.lastWornAt = const Value.absent(),
    this.timesWorn = const Value.absent(),
    this.isVirtual = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GarmentsCompanion.insert({
    required String id,
    required GarmentCategory category,
    required String subtype,
    required int formality,
    required int primaryColor,
    required ColorFamily colorFamily,
    this.secondaryColor = const Value.absent(),
    this.secondaryColorFamily = const Value.absent(),
    this.pattern = const Value.absent(),
    this.fit = const Value.absent(),
    this.warmth = const Value.absent(),
    this.lastWornAt = const Value.absent(),
    this.timesWorn = const Value.absent(),
    this.isVirtual = const Value.absent(),
    required String photoPath,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       category = Value(category),
       subtype = Value(subtype),
       formality = Value(formality),
       primaryColor = Value(primaryColor),
       colorFamily = Value(colorFamily),
       photoPath = Value(photoPath),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<GarmentRow> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<String>? subtype,
    Expression<int>? formality,
    Expression<int>? primaryColor,
    Expression<String>? colorFamily,
    Expression<int>? secondaryColor,
    Expression<String>? secondaryColorFamily,
    Expression<String>? pattern,
    Expression<String>? fit,
    Expression<String>? warmth,
    Expression<DateTime>? lastWornAt,
    Expression<int>? timesWorn,
    Expression<bool>? isVirtual,
    Expression<String>? photoPath,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (subtype != null) 'subtype': subtype,
      if (formality != null) 'formality': formality,
      if (primaryColor != null) 'primary_color': primaryColor,
      if (colorFamily != null) 'color_family': colorFamily,
      if (secondaryColor != null) 'secondary_color': secondaryColor,
      if (secondaryColorFamily != null)
        'secondary_color_family': secondaryColorFamily,
      if (pattern != null) 'pattern': pattern,
      if (fit != null) 'fit': fit,
      if (warmth != null) 'warmth': warmth,
      if (lastWornAt != null) 'last_worn_at': lastWornAt,
      if (timesWorn != null) 'times_worn': timesWorn,
      if (isVirtual != null) 'is_virtual': isVirtual,
      if (photoPath != null) 'photo_path': photoPath,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GarmentsCompanion copyWith({
    Value<String>? id,
    Value<GarmentCategory>? category,
    Value<String>? subtype,
    Value<int>? formality,
    Value<int>? primaryColor,
    Value<ColorFamily>? colorFamily,
    Value<int?>? secondaryColor,
    Value<ColorFamily?>? secondaryColorFamily,
    Value<GarmentPattern>? pattern,
    Value<Fit?>? fit,
    Value<Warmth?>? warmth,
    Value<DateTime?>? lastWornAt,
    Value<int>? timesWorn,
    Value<bool>? isVirtual,
    Value<String>? photoPath,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GarmentsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      subtype: subtype ?? this.subtype,
      formality: formality ?? this.formality,
      primaryColor: primaryColor ?? this.primaryColor,
      colorFamily: colorFamily ?? this.colorFamily,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      secondaryColorFamily: secondaryColorFamily ?? this.secondaryColorFamily,
      pattern: pattern ?? this.pattern,
      fit: fit ?? this.fit,
      warmth: warmth ?? this.warmth,
      lastWornAt: lastWornAt ?? this.lastWornAt,
      timesWorn: timesWorn ?? this.timesWorn,
      isVirtual: isVirtual ?? this.isVirtual,
      photoPath: photoPath ?? this.photoPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $GarmentsTable.$convertercategory.toSql(category.value),
      );
    }
    if (subtype.present) {
      map['subtype'] = Variable<String>(subtype.value);
    }
    if (formality.present) {
      map['formality'] = Variable<int>(formality.value);
    }
    if (primaryColor.present) {
      map['primary_color'] = Variable<int>(primaryColor.value);
    }
    if (colorFamily.present) {
      map['color_family'] = Variable<String>(
        $GarmentsTable.$convertercolorFamily.toSql(colorFamily.value),
      );
    }
    if (secondaryColor.present) {
      map['secondary_color'] = Variable<int>(secondaryColor.value);
    }
    if (secondaryColorFamily.present) {
      map['secondary_color_family'] = Variable<String>(
        $GarmentsTable.$convertersecondaryColorFamilyn.toSql(
          secondaryColorFamily.value,
        ),
      );
    }
    if (pattern.present) {
      map['pattern'] = Variable<String>(
        $GarmentsTable.$converterpattern.toSql(pattern.value),
      );
    }
    if (fit.present) {
      map['fit'] = Variable<String>(
        $GarmentsTable.$converterfitn.toSql(fit.value),
      );
    }
    if (warmth.present) {
      map['warmth'] = Variable<String>(
        $GarmentsTable.$converterwarmthn.toSql(warmth.value),
      );
    }
    if (lastWornAt.present) {
      map['last_worn_at'] = Variable<DateTime>(lastWornAt.value);
    }
    if (timesWorn.present) {
      map['times_worn'] = Variable<int>(timesWorn.value);
    }
    if (isVirtual.present) {
      map['is_virtual'] = Variable<bool>(isVirtual.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GarmentsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('subtype: $subtype, ')
          ..write('formality: $formality, ')
          ..write('primaryColor: $primaryColor, ')
          ..write('colorFamily: $colorFamily, ')
          ..write('secondaryColor: $secondaryColor, ')
          ..write('secondaryColorFamily: $secondaryColorFamily, ')
          ..write('pattern: $pattern, ')
          ..write('fit: $fit, ')
          ..write('warmth: $warmth, ')
          ..write('lastWornAt: $lastWornAt, ')
          ..write('timesWorn: $timesWorn, ')
          ..write('isVirtual: $isVirtual, ')
          ..write('photoPath: $photoPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OutfitLogsTable extends OutfitLogs
    with TableInfo<$OutfitLogsTable, OutfitLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OutfitLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wornAtMeta = const VerificationMeta('wornAt');
  @override
  late final GeneratedColumn<DateTime> wornAt = GeneratedColumn<DateTime>(
    'worn_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _garmentIdsMeta = const VerificationMeta(
    'garmentIds',
  );
  @override
  late final GeneratedColumn<String> garmentIds = GeneratedColumn<String>(
    'garment_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, wornAt, garmentIds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'outfit_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutfitLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('worn_at')) {
      context.handle(
        _wornAtMeta,
        wornAt.isAcceptableOrUnknown(data['worn_at']!, _wornAtMeta),
      );
    } else if (isInserting) {
      context.missing(_wornAtMeta);
    }
    if (data.containsKey('garment_ids')) {
      context.handle(
        _garmentIdsMeta,
        garmentIds.isAcceptableOrUnknown(data['garment_ids']!, _garmentIdsMeta),
      );
    } else if (isInserting) {
      context.missing(_garmentIdsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OutfitLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutfitLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      wornAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}worn_at'],
      )!,
      garmentIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}garment_ids'],
      )!,
    );
  }

  @override
  $OutfitLogsTable createAlias(String alias) {
    return $OutfitLogsTable(attachedDatabase, alias);
  }
}

class OutfitLog extends DataClass implements Insertable<OutfitLog> {
  final String id;
  final DateTime wornAt;
  final String garmentIds;
  const OutfitLog({
    required this.id,
    required this.wornAt,
    required this.garmentIds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['worn_at'] = Variable<DateTime>(wornAt);
    map['garment_ids'] = Variable<String>(garmentIds);
    return map;
  }

  OutfitLogsCompanion toCompanion(bool nullToAbsent) {
    return OutfitLogsCompanion(
      id: Value(id),
      wornAt: Value(wornAt),
      garmentIds: Value(garmentIds),
    );
  }

  factory OutfitLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutfitLog(
      id: serializer.fromJson<String>(json['id']),
      wornAt: serializer.fromJson<DateTime>(json['wornAt']),
      garmentIds: serializer.fromJson<String>(json['garmentIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wornAt': serializer.toJson<DateTime>(wornAt),
      'garmentIds': serializer.toJson<String>(garmentIds),
    };
  }

  OutfitLog copyWith({String? id, DateTime? wornAt, String? garmentIds}) =>
      OutfitLog(
        id: id ?? this.id,
        wornAt: wornAt ?? this.wornAt,
        garmentIds: garmentIds ?? this.garmentIds,
      );
  OutfitLog copyWithCompanion(OutfitLogsCompanion data) {
    return OutfitLog(
      id: data.id.present ? data.id.value : this.id,
      wornAt: data.wornAt.present ? data.wornAt.value : this.wornAt,
      garmentIds: data.garmentIds.present
          ? data.garmentIds.value
          : this.garmentIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutfitLog(')
          ..write('id: $id, ')
          ..write('wornAt: $wornAt, ')
          ..write('garmentIds: $garmentIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, wornAt, garmentIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutfitLog &&
          other.id == this.id &&
          other.wornAt == this.wornAt &&
          other.garmentIds == this.garmentIds);
}

class OutfitLogsCompanion extends UpdateCompanion<OutfitLog> {
  final Value<String> id;
  final Value<DateTime> wornAt;
  final Value<String> garmentIds;
  final Value<int> rowid;
  const OutfitLogsCompanion({
    this.id = const Value.absent(),
    this.wornAt = const Value.absent(),
    this.garmentIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OutfitLogsCompanion.insert({
    required String id,
    required DateTime wornAt,
    required String garmentIds,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       wornAt = Value(wornAt),
       garmentIds = Value(garmentIds);
  static Insertable<OutfitLog> custom({
    Expression<String>? id,
    Expression<DateTime>? wornAt,
    Expression<String>? garmentIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wornAt != null) 'worn_at': wornAt,
      if (garmentIds != null) 'garment_ids': garmentIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OutfitLogsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? wornAt,
    Value<String>? garmentIds,
    Value<int>? rowid,
  }) {
    return OutfitLogsCompanion(
      id: id ?? this.id,
      wornAt: wornAt ?? this.wornAt,
      garmentIds: garmentIds ?? this.garmentIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wornAt.present) {
      map['worn_at'] = Variable<DateTime>(wornAt.value);
    }
    if (garmentIds.present) {
      map['garment_ids'] = Variable<String>(garmentIds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OutfitLogsCompanion(')
          ..write('id: $id, ')
          ..write('wornAt: $wornAt, ')
          ..write('garmentIds: $garmentIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GarmentsTable garments = $GarmentsTable(this);
  late final $OutfitLogsTable outfitLogs = $OutfitLogsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    garments,
    outfitLogs,
    settings,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$GarmentsTableCreateCompanionBuilder = GarmentsCompanion Function({
  required String id,
  required GarmentCategory category,
  required String subtype,
  required int formality,
  required int primaryColor,
  required ColorFamily colorFamily,
  Value<int?> secondaryColor,
  Value<ColorFamily?> secondaryColorFamily,
  Value<GarmentPattern> pattern,
  Value<Fit?> fit,
  Value<Warmth?> warmth,
  Value<DateTime?> lastWornAt,
  Value<int> timesWorn,
  Value<bool> isVirtual,
  required String photoPath,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$GarmentsTableUpdateCompanionBuilder = GarmentsCompanion Function({
  Value<String> id,
  Value<GarmentCategory> category,
  Value<String> subtype,
  Value<int> formality,
  Value<int> primaryColor,
  Value<ColorFamily> colorFamily,
  Value<int?> secondaryColor,
  Value<ColorFamily?> secondaryColorFamily,
  Value<GarmentPattern> pattern,
  Value<Fit?> fit,
  Value<Warmth?> warmth,
  Value<DateTime?> lastWornAt,
  Value<int> timesWorn,
  Value<bool> isVirtual,
  Value<String> photoPath,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$GarmentsTableFilterComposer
    extends Composer<_$AppDatabase, $GarmentsTable> {
  $$GarmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<GarmentCategory, GarmentCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get subtype => $composableBuilder(
    column: $table.subtype,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get formality => $composableBuilder(
    column: $table.formality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get primaryColor => $composableBuilder(
    column: $table.primaryColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ColorFamily, ColorFamily, String>
  get colorFamily => $composableBuilder(
    column: $table.colorFamily,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get secondaryColor => $composableBuilder(
    column: $table.secondaryColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ColorFamily?, ColorFamily, String>
  get secondaryColorFamily => $composableBuilder(
    column: $table.secondaryColorFamily,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<GarmentPattern, GarmentPattern, String>
  get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Fit?, Fit, String> get fit =>
      $composableBuilder(
        column: $table.fit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Warmth?, Warmth, String> get warmth =>
      $composableBuilder(
        column: $table.warmth,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get lastWornAt => $composableBuilder(
    column: $table.lastWornAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesWorn => $composableBuilder(
    column: $table.timesWorn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVirtual => $composableBuilder(
    column: $table.isVirtual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GarmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $GarmentsTable> {
  $$GarmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtype => $composableBuilder(
    column: $table.subtype,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get formality => $composableBuilder(
    column: $table.formality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get primaryColor => $composableBuilder(
    column: $table.primaryColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorFamily => $composableBuilder(
    column: $table.colorFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get secondaryColor => $composableBuilder(
    column: $table.secondaryColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get secondaryColorFamily => $composableBuilder(
    column: $table.secondaryColorFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pattern => $composableBuilder(
    column: $table.pattern,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fit => $composableBuilder(
    column: $table.fit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warmth => $composableBuilder(
    column: $table.warmth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastWornAt => $composableBuilder(
    column: $table.lastWornAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesWorn => $composableBuilder(
    column: $table.timesWorn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVirtual => $composableBuilder(
    column: $table.isVirtual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GarmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GarmentsTable> {
  $$GarmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GarmentCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get subtype =>
      $composableBuilder(column: $table.subtype, builder: (column) => column);

  GeneratedColumn<int> get formality =>
      $composableBuilder(column: $table.formality, builder: (column) => column);

  GeneratedColumn<int> get primaryColor => $composableBuilder(
    column: $table.primaryColor,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ColorFamily, String> get colorFamily =>
      $composableBuilder(
        column: $table.colorFamily,
        builder: (column) => column,
      );

  GeneratedColumn<int> get secondaryColor => $composableBuilder(
    column: $table.secondaryColor,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ColorFamily?, String>
  get secondaryColorFamily => $composableBuilder(
    column: $table.secondaryColorFamily,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<GarmentPattern, String> get pattern =>
      $composableBuilder(column: $table.pattern, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Fit?, String> get fit =>
      $composableBuilder(column: $table.fit, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Warmth?, String> get warmth =>
      $composableBuilder(column: $table.warmth, builder: (column) => column);

  GeneratedColumn<DateTime> get lastWornAt => $composableBuilder(
    column: $table.lastWornAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesWorn =>
      $composableBuilder(column: $table.timesWorn, builder: (column) => column);

  GeneratedColumn<bool> get isVirtual =>
      $composableBuilder(column: $table.isVirtual, builder: (column) => column);

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GarmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GarmentsTable,
          GarmentRow,
          $$GarmentsTableFilterComposer,
          $$GarmentsTableOrderingComposer,
          $$GarmentsTableAnnotationComposer,
          $$GarmentsTableCreateCompanionBuilder,
          $$GarmentsTableUpdateCompanionBuilder,
          (
            GarmentRow,
            BaseReferences<_$AppDatabase, $GarmentsTable, GarmentRow>,
          ),
          GarmentRow,
          PrefetchHooks Function()
        > {
  $$GarmentsTableTableManager(_$AppDatabase db, $GarmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GarmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GarmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GarmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<GarmentCategory> category = const Value.absent(),
                Value<String> subtype = const Value.absent(),
                Value<int> formality = const Value.absent(),
                Value<int> primaryColor = const Value.absent(),
                Value<ColorFamily> colorFamily = const Value.absent(),
                Value<int?> secondaryColor = const Value.absent(),
                Value<ColorFamily?> secondaryColorFamily = const Value.absent(),
                Value<GarmentPattern> pattern = const Value.absent(),
                Value<Fit?> fit = const Value.absent(),
                Value<Warmth?> warmth = const Value.absent(),
                Value<DateTime?> lastWornAt = const Value.absent(),
                Value<int> timesWorn = const Value.absent(),
                Value<bool> isVirtual = const Value.absent(),
                Value<String> photoPath = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GarmentsCompanion(
                id: id,
                category: category,
                subtype: subtype,
                formality: formality,
                primaryColor: primaryColor,
                colorFamily: colorFamily,
                secondaryColor: secondaryColor,
                secondaryColorFamily: secondaryColorFamily,
                pattern: pattern,
                fit: fit,
                warmth: warmth,
                lastWornAt: lastWornAt,
                timesWorn: timesWorn,
                isVirtual: isVirtual,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required GarmentCategory category,
                required String subtype,
                required int formality,
                required int primaryColor,
                required ColorFamily colorFamily,
                Value<int?> secondaryColor = const Value.absent(),
                Value<ColorFamily?> secondaryColorFamily = const Value.absent(),
                Value<GarmentPattern> pattern = const Value.absent(),
                Value<Fit?> fit = const Value.absent(),
                Value<Warmth?> warmth = const Value.absent(),
                Value<DateTime?> lastWornAt = const Value.absent(),
                Value<int> timesWorn = const Value.absent(),
                Value<bool> isVirtual = const Value.absent(),
                required String photoPath,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GarmentsCompanion.insert(
                id: id,
                category: category,
                subtype: subtype,
                formality: formality,
                primaryColor: primaryColor,
                colorFamily: colorFamily,
                secondaryColor: secondaryColor,
                secondaryColorFamily: secondaryColorFamily,
                pattern: pattern,
                fit: fit,
                warmth: warmth,
                lastWornAt: lastWornAt,
                timesWorn: timesWorn,
                isVirtual: isVirtual,
                photoPath: photoPath,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GarmentsTable, GarmentRow>(table),
                  BaseReferences<_$AppDatabase, $GarmentsTable, GarmentRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GarmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GarmentsTable,
      GarmentRow,
      $$GarmentsTableFilterComposer,
      $$GarmentsTableOrderingComposer,
      $$GarmentsTableAnnotationComposer,
      $$GarmentsTableCreateCompanionBuilder,
      $$GarmentsTableUpdateCompanionBuilder,
      (GarmentRow, BaseReferences<_$AppDatabase, $GarmentsTable, GarmentRow>),
      GarmentRow,
      PrefetchHooks Function()
    >;
typedef $$OutfitLogsTableCreateCompanionBuilder = OutfitLogsCompanion Function({
  required String id,
  required DateTime wornAt,
  required String garmentIds,
  Value<int> rowid,
});
typedef $$OutfitLogsTableUpdateCompanionBuilder = OutfitLogsCompanion Function({
  Value<String> id,
  Value<DateTime> wornAt,
  Value<String> garmentIds,
  Value<int> rowid,
});

class $$OutfitLogsTableFilterComposer
    extends Composer<_$AppDatabase, $OutfitLogsTable> {
  $$OutfitLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get wornAt => $composableBuilder(
    column: $table.wornAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get garmentIds => $composableBuilder(
    column: $table.garmentIds,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OutfitLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $OutfitLogsTable> {
  $$OutfitLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get wornAt => $composableBuilder(
    column: $table.wornAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get garmentIds => $composableBuilder(
    column: $table.garmentIds,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OutfitLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OutfitLogsTable> {
  $$OutfitLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get wornAt =>
      $composableBuilder(column: $table.wornAt, builder: (column) => column);

  GeneratedColumn<String> get garmentIds => $composableBuilder(
    column: $table.garmentIds,
    builder: (column) => column,
  );
}

class $$OutfitLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OutfitLogsTable,
          OutfitLog,
          $$OutfitLogsTableFilterComposer,
          $$OutfitLogsTableOrderingComposer,
          $$OutfitLogsTableAnnotationComposer,
          $$OutfitLogsTableCreateCompanionBuilder,
          $$OutfitLogsTableUpdateCompanionBuilder,
          (
            OutfitLog,
            BaseReferences<_$AppDatabase, $OutfitLogsTable, OutfitLog>,
          ),
          OutfitLog,
          PrefetchHooks Function()
        > {
  $$OutfitLogsTableTableManager(_$AppDatabase db, $OutfitLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OutfitLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OutfitLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OutfitLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> wornAt = const Value.absent(),
                Value<String> garmentIds = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OutfitLogsCompanion(
                id: id,
                wornAt: wornAt,
                garmentIds: garmentIds,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime wornAt,
                required String garmentIds,
                Value<int> rowid = const Value.absent(),
              }) => OutfitLogsCompanion.insert(
                id: id,
                wornAt: wornAt,
                garmentIds: garmentIds,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OutfitLogsTable, OutfitLog>(table),
                  BaseReferences<_$AppDatabase, $OutfitLogsTable, OutfitLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OutfitLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OutfitLogsTable,
      OutfitLog,
      $$OutfitLogsTableFilterComposer,
      $$OutfitLogsTableOrderingComposer,
      $$OutfitLogsTableAnnotationComposer,
      $$OutfitLogsTableCreateCompanionBuilder,
      $$OutfitLogsTableUpdateCompanionBuilder,
      (OutfitLog, BaseReferences<_$AppDatabase, $OutfitLogsTable, OutfitLog>),
      OutfitLog,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GarmentsTableTableManager get garments =>
      $$GarmentsTableTableManager(_db, _db.garments);
  $$OutfitLogsTableTableManager get outfitLogs =>
      $$OutfitLogsTableTableManager(_db, _db.outfitLogs);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
}
