import 'package:outfit_engine/outfit_engine.dart';

const categoryLabels = {
  GarmentCategory.top: 'Superior',
  GarmentCategory.bottom: 'Inferior',
  GarmentCategory.outerwear: 'Capas',
  GarmentCategory.shoes: 'Calzado',
  GarmentCategory.accessory: 'Accesorios',
};

const subtypeLabels = {
  GarmentCategory.top: {
    'tshirt': 'Camiseta',
    'shirt': 'Camisa',
    'polo': 'Polo',
    'sweatshirt': 'Sudadera',
    'blouse': 'Blusa',
  },
  GarmentCategory.bottom: {
    'pants': 'Pantalón',
    'jeans': 'Jeans',
    'shorts': 'Short',
    'joggers': 'Joggers',
    'skirt': 'Falda',
  },
  GarmentCategory.outerwear: {
    'jacket': 'Chaqueta',
    'overshirt': 'Sobrecamisa',
    'sweater': 'Suéter',
    'vest': 'Chaleco',
    'casual_jacket': 'Chamarra',
    'coat': 'Abrigo',
    'cardigan': 'Cárdigan',
    'blazer': 'Blazer',
  },
  GarmentCategory.shoes: {
    'sneakers': 'Tenis',
    'boots': 'Botas',
    'sandals': 'Sandalias',
    'loafers': 'Mocasines',
  },
  GarmentCategory.accessory: {
    'belt': 'Cinturón',
    'cap': 'Gorra',
    'scarf': 'Bufanda',
    'watch': 'Reloj',
    'bag': 'Bolso',
  },
};

const typicalFormalityBySubtype = {
  'tshirt': 2,
  'shirt': 3,
  'polo': 3,
  'sweatshirt': 1,
  'blouse': 3,
  'pants': 3,
  'jeans': 2,
  'shorts': 1,
  'joggers': 1,
  'skirt': 3,
  'jacket': 3,
  'overshirt': 2,
  'sweater': 3,
  'vest': 3,
  'casual_jacket': 2,
  'coat': 4,
  'cardigan': 3,
  'blazer': 4,
  'sneakers': 2,
  'boots': 3,
  'sandals': 1,
  'loafers': 4,
  'belt': 2,
  'cap': 2,
  'scarf': 2,
  'watch': 2,
  'bag': 2,
};

const colorFamilyLabels = {
  ColorFamily.neutral: 'Neutro',
  ColorFamily.warm: 'Cálido',
  ColorFamily.cool: 'Frío',
  ColorFamily.accent: 'Acento',
};

const formalityLabels = [
  'Muy casual',
  'Casual',
  'Intermedio',
  'Arreglado',
  'Formal',
];
const fitLabels = {
  Fit.slim: 'Ajustado',
  Fit.regular: 'Regular',
  Fit.loose: 'Holgado',
};
const warmthLabels = {
  Warmth.light: 'Ligero',
  Warmth.medium: 'Medio',
  Warmth.warm: 'Abrigado',
};

const garmentPalette = {
  'Negro': 0xff171717,
  'Gris': 0xff808080,
  'Blanco': 0xffffffff,
  'Crema': 0xfff5ecd7,
  'Beige': 0xffc8ad8d,
  'Café': 0xff754b35,
  'Rojo': 0xffcc2525,
  'Vino': 0xff762038,
  'Naranja': 0xffef802a,
  'Amarillo': 0xffefc82c,
  'Oliva': 0xff77823c,
  'Verde': 0xff257142,
  'Celeste': 0xff75b7e3,
  'Azul marino': 0xff20385e,
  'Morado': 0xff75459e,
  'Rosa': 0xffe486ac,
};
