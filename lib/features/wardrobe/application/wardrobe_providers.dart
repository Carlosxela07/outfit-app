import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outfit_engine/outfit_engine.dart';
import 'package:uuid/uuid.dart';

import '../../../core/storage/garment_photos.dart';
import '../data/garment_repository.dart';

final garmentPhotoPickerProvider =
    Provider<Future<XFile?> Function(ImageSource)>((ref) {
      final picker = ImagePicker();
      return (source) => picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
    });

final garmentPhotosProvider = Provider<GarmentPhotos>(
  (ref) => const GarmentPhotos(),
);

final wardrobeItemsProvider = StreamProvider.autoDispose
    .family<List<WardrobeItem>, GarmentCategory?>(
      (ref, category) =>
          ref.watch(garmentRepositoryProvider).watchItems(category: category),
    );

final wardrobeActionsProvider = Provider<WardrobeActions>(
  (ref) => WardrobeActions(
    ref.watch(garmentRepositoryProvider),
    ref.watch(garmentPhotosProvider),
  ),
);

class WardrobeActions {
  const WardrobeActions(this._repository, this._photos);

  final GarmentRepository _repository;
  final GarmentPhotos _photos;

  Future<void> add(GarmentDraft draft) async {
    final id = const Uuid().v4();
    final photoPath = await _photos.save(id, draft.photoPath);
    try {
      await _repository.add(
        GarmentDraft(
          category: draft.category,
          subtype: draft.subtype,
          formality: draft.formality,
          primaryColor: draft.primaryColor,
          colorFamily: draft.colorFamily,
          photoPath: photoPath,
          fit: draft.fit,
          warmth: draft.warmth,
        ),
        id: id,
      );
    } catch (_) {
      await _photos.delete(photoPath);
      rethrow;
    }
  }

  Future<void> update(Garment garment) => _repository.update(garment);

  Future<void> delete(WardrobeItem item) => _repository.delete(
    item.garment.id,
    deletePhoto: () => _photos.delete(item.photoPath),
  );
}
